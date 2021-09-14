import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final bW; //장애물 가로
  final bH; // 장애물 세로
  final bX;
  final bool BBarrier; // 하단 장애물

  Barrier(
      {this.bH,
        this.bW,
        required this.BBarrier,
        this.bX});

  @override

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * bX + bW) / (2 - bW),
          BBarrier ? 1 : -1),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.lightGreen,
            border: Border.all(width: 10,color: Colors.green),
            borderRadius: BorderRadius.circular(10)
        ),
        width: MediaQuery.of(context).size.width * bW / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * bH / 2,
      ),
    );
  }
}