import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final bY; //y축
  final double birdW; //가로
  final double birdH; // 세로

  Bird({this.bY, required this.birdW, required this.birdH});

  @override

  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, (2 * bY + birdH) / (2 - birdH)),
        child: Image.asset(
          'build/web/assets/images/bird.png',
          width: MediaQuery.of(context).size.height * birdW / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * birdH/ 2,
          fit: BoxFit.fill,
        ));
  }
}