// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class WidgetCustom {
  static AnimatedContainer createContainerCustom(
    BuildContext context,
    double height,
    bool active, {
    Widget? child,
    double maxHeight = 90,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 110, 110, 110),
      ),
      height: active ? height * 0.25 : 0,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: child,
    );
  }
}
