import 'dart:async';
import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 새 변수
  static double bY = 0;
  double initial = bY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // 중력이 얼마나 강한지
  double velocity = 3.5; // 점프가 얼마나 강한지
  double birdW = 0.1; // 화면의 전체 너비
  double birdH = 0.1; // 화면의 전체 높이
  bool Started = false; // 게임 설정
  int score = 0;
  int highscore = 0;

  // 장애물 변수
  static List<double> bX = [2, 2 + 1.5];
  static double bW = 0.5;
  List<List<double>> bH = [
    // 화면의 전체 높이, [상단 높이, 하단 높이]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    Started = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // 점프는 거꾸로 된 포물선과 동일하여 간단한 이차 방정식
      height = gravity * time * time + velocity * time;

      setState(() {
        bY = initial - height;
      });

      //새가 죽는
      if (gameover()) {
        timer.cancel();
        if(score > highscore) {
          highscore = score;
        }
        _showDialog();
      }

      // 장애물 이동
      move();

      time += 0.01; //시간
    });
  }

  void move() {
    for (int i = 0; i < bX.length; i++) {
      // 장애물 이동
      setState(() {
        bX[i] -= 0.005;
      });

      // 장애물이 화면의 왼쪽 부분을 벗어나면 계속 반복합니다.
      if (bX[i] < -1.5) {
        bX[i] += 3;
      }
      if(bX[i] < -1 && bX[i] > -1.006 ) { // 장애물이 0.005씩 움직이기 때문에 점수를 1 증가 시키려면 0.005가 움직일 때의 점수를 준
        score++;
      }
    }
  }

  void restart() {
    Navigator.pop(context); // 대화창을 닫으며 초기화 한다
    setState(() {
      bY = 0;
      Started = false;
      time = 0;
      score = 0;
      initial = bY;
      bX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.black),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: restart,
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.lightGreen,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initial = bY;
    });
  }

  bool gameover() {
    // 새가 상단, 하단에 닿는지
    if (bY < -1 || bY > 1) {
      return true;
    }

    // 장애물에 부딪히면 x,y좌표 내에 있는지 확인
    for (int i = 0; i < bX.length; i++) {
      if (bX[i] <= birdW &&
          bX[i] + bW >= -birdW &&
          (bY <= -1 + bH[i][0] ||
              bY + birdH >= 1 - bH[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Started ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.lightBlue,
                child: Center(
                  child: Stack(
                    children: [
                      // bird
                      Bird(
                        bY: bY,
                        birdW: birdW,
                        birdH: birdH,
                      ),

                      // tap to play
                      Container(
                        alignment: Alignment(0,-0.3),
                        child: Started
                            ? Text(" ")
                            : Text("T A P  T O  P L A Y !",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white
                            )),
                      ),

                      // 상단 장애물1
                      Barrier(
                        bX: bX[0],
                        bW: bW,
                        bH: bH[0][0],
                        BBarrier: false,
                      ),

                      // 하단 장애물1
                      Barrier(
                        bX: bX[0],
                        bW: bW,
                        bH: bH[0][1],
                        BBarrier: true,
                      ),

                      // 상단 장애물2
                      Barrier(
                        bX: bX[1],
                        bW: bW,
                        bH: bH[1][0],
                        BBarrier: false,
                      ),

                      // 하단 장애물2
                      Barrier(
                        bX: bX[1],
                        bW: bW,
                        bH: bH[1][1],
                        BBarrier: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SCORE",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(score.toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 35)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("BEST",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(highscore.toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 35)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}