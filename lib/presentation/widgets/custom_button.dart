import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final onTap;
  final Color color;
  final Widget child;

  const CustomButton({
    Key key,
    @required this.height,
    @required this.width,
    @required this.onTap,
    @required this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[500],
        borderRadius: BorderRadius.circular(4),
      ),
      child: new Material(
        child: new InkWell(
          onTap: onTap,
          child: child,
        ),
        color: Colors.transparent,
      ),
    );
  }
}
