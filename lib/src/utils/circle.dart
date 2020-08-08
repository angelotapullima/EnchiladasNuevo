import 'package:flutter/material.dart';


class CircleContainer extends StatelessWidget {
  final double radius;
  final Color color;
  final Widget widget;
  const CircleContainer({Key key, @required this.radius,@required this.color, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: radius*2,
      height: radius*2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(this.radius),
        color: this.color
      ),
      child: Center(
        child: this.widget,
      ),

    );
  }
}