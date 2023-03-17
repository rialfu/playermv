import 'package:flutter/material.dart';

// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
// class CustomSlider extends StatelessWidget {
//   final int position;
//   final int max;
//   final Function(DragDownDetails details)? onPanDown;
//   final Function(DragUpdateDetails details, int change)? onPanUpdate;
//   final Function(DragEndDetails details, int change)? onPanEnd;
//   final Function? onTapDown;
//   const CustomSlider({
//     super.key,
//     this.position = 0,
//     this.max = 100,
//     this.onPanDown,
//     this.onTapDown,
//     this.onPanEnd,
//     this.onPanUpdate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class ChildCustomSlider extends StatefulWidget {
//   // final int position;
//   final ValueNotifier<int> position;
//   // final ValueNotifier<int> max;
//   final Function(DragDownDetails details)? onPanDown;
//   final Function(DragUpdateDetails details, int change)? onPanUpdate;
//   final Function(DragEndDetails details, int change)? onPanEnd;
//   final Function? onTapDown;
//   const ChildCustomSlider(
//     this.position, {
//     super.key,
//     // this.position =0,

//     // this.max = 100,
//     this.onPanDown,
//     this.onTapDown,
//     this.onPanEnd,
//     this.onPanUpdate,
//   });

//   // const ChildCustomSlider({super.key});
//   factory ChildCustomSlider.custom(int now) {
//     const ValueNotifier<int> vn = ValueNotifier(now);
//     return const ChildCustomSlider(vn);
//   }

//   @override
//   State<ChildCustomSlider> createState() => _ChildCustomSliderState();
// }

// class _ChildCustomSliderState extends State<ChildCustomSlider> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
class CustomSlider extends StatefulWidget {
  final int position;
  final int max;
  final Function(DragDownDetails details)? onPanDown;
  final Function(DragUpdateDetails details, int change)? onPanUpdate;
  final Function(DragEndDetails details, int change)? onPanEnd;
  final Function(TapDownDetails details, int change)? onTapDown;

  const CustomSlider({
    super.key,
    this.position = 0,
    this.max = 100,
    this.onPanDown,
    this.onTapDown,
    this.onPanEnd,
    this.onPanUpdate,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double position = 0;
  double max = 0;
  double widthComponent = 0;
  String type = "sliders";

  // double cache = 0;
  @override
  void initState() {
    print('customslider:${widget.position} : ${widget.max}');
    super.initState();
    setState(() {
      position = widget.position.toDouble();
      max = widget.max.toDouble();
    });
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      position = widget.position.toDouble();
      max = widget.max.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('customslider build:${widget.position} : ${widget.max}');
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 30),
            decoration: BoxDecoration(border: Border.all(width: 1)),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            height: double.infinity,
            // width: double.infinity,
            child: LayoutBuilder(builder: (context, snapshot) {
              return GestureDetector(
                onTapDown: (details) {
                  double now = details.localPosition.dx;
                  now = now < 0 ? 0 : now;
                  now = now > snapshot.maxWidth ? snapshot.maxWidth : now;
                  now = (now / snapshot.maxWidth) * max;
                  now = now > max ? max : now;
                  if (widget.onTapDown != null) {
                    widget.onTapDown!(details, now.toInt());
                  }
                  setState(() {
                    position = now;
                  });
                },
                onPanDown: (details) {
                  if (widget.onPanDown != null) {
                    widget.onPanDown!(details);
                  }
                },
                onPanUpdate: (details) {
                  print("onPanUp");
                  double now = details.localPosition.dx;
                  now = now < 0 ? 0 : now;
                  now = now > snapshot.maxWidth ? snapshot.maxWidth : now;
                  now = (now / snapshot.maxWidth) * max;
                  now = now > max ? max : now;
                  if (widget.onPanUpdate != null) {
                    widget.onPanUpdate!(details, now.toInt());
                  }
                  setState(() {
                    position = now;
                  });
                },
                onPanEnd: (details) {
                  if (widget.onPanEnd != null) {
                    widget.onPanEnd!(details, position.toInt());
                  }
                  // details.
                },
                child: Stack(
                  children: [
                    Container(
                      color: Colors.red,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      child: Container(
                        color: Colors.blue,
                        height: double.infinity,
                        width: position / max * snapshot.maxWidth,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
