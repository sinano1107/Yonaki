import 'package:flutter/material.dart';

class Higanbana extends StatelessWidget {
  final double scale;
  final double bottom;
  final double left;

  Higanbana(this.scale, this.bottom, this.left);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      child: Image.asset('assets/images/higanbana.png', scale: scale),
    );
  }
}
