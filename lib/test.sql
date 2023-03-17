select 
    P.no_pengajuan,  
    nama_debitur, 
    jenis_memo, 
    usulan, 
    nama_ao, 
    nama_cca, --CONVERT(DATE,Q.tglKeluarCCA) AS tglKeluarCCA,  CONVERT(date,Q.tglMasukCCA) AS tglMasukCCA,  
    step, jenis_pengajuan, nik_ao, nik_tl,
    
    sum(sla) as sla
    from( 
        P.no_pengajuan,  
        nama_debitur, 
        jenis_memo, 
        usulan, 
        nama_ao, 
        nama_cca, --CONVERT(DATE,Q.tglKeluarCCA) AS tglKeluarCCA,  CONVERT(date,Q.tglMasukCCA) AS tglMasukCCA,  
        step, jenis_pengajuan, nik_ao, nik_tl,
        CASE WHEN P.version = '2.0' AND ( Q.tglMasukCCA != '' OR Q.tglMasukCCA is not null) AND (Q.tglKeluarCCA != '' OR Q.tglKeluarCCA is not null) THEN  
            (
                DATEDIFF (day, Q.tglMasukCCA, Q.tglKeluarCCA)-
                (
                    (DATEDIFF(wk, Q.tglMasukCCA, Q.tglKeluarCCA) * 2) 
                    +(CASE WHEN DATENAME(dw, Q.tglMasukCCA) = 'Sunday' THEN 1 ELSE 0 END)
                    +(CASE WHEN DATENAME(dw, Q.tglKeluarCCA) = 'Saturday' THEN 1 ELSE 0 END)
                )        
                - (select count(*) from sla_mst_holiday where Q.tglMasukCCA<= tgl_holiday and tgl_holiday <= Q.tglKeluarCCA)
            )
        ELSE  
            SUM(CONVERT(int,DATEDIFF(DAY, CONVERT(date,P.tglMasukCCA), CONVERT(DATE,P.tglKeluarCCA))))
        END  
        AS sla
            
    FROM 
        trx_pega_sla  P  
    LEFT JOIN 
        sla_cca_submited Q  
    ON 
        P.no_pengajuan = Q.no_pengajuan  
    WHERE 
        P.step >= 3 
    GROUP BY 
        P.no_pengajuan, 
        P.nama_debitur, 
        P.jenis_memo, 
        P.usulan, 
        P.nama_ao, 
        P.nama_cca, P.step, 
        P.jenis_pengajuan, 
        P.nik_ao, 
        P.nik_tl, 
        Q.tglMasukCCA,
        Q.tglKeluarCCA, 
        P.version--, Q.tglMasukCCA, Q.tglKeluarCCA
    )
group by 
    P.no_pengajuan,  
    nama_debitur, 
    jenis_memo, 
    usulan, 
    nama_ao, 
    nama_cca, --CONVERT(DATE,Q.tglKeluarCCA) AS tglKeluarCCA,  CONVERT(date,Q.tglMasukCCA) AS tglMasukCCA,  
    step, jenis_pengajuan, nik_ao, nik_tl
