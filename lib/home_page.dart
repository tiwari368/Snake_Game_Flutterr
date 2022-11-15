import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snakee_game_dev/blank_pixel.dart';
import 'package:snakee_game_dev/food_pixel.dart';
import 'package:snakee_game_dev/main.dart';
import 'package:snakee_game_dev/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //griddimensions
  int rowSize = 10;
  int totalNumberofSquare = 100;

  //user scopre
  int currentScore = 0;
  // snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];
  //snake direction is initially right;
  var csnakeDir = snake_Direction.RIGHT;
  //food position
  int foodPos = 55;
  //start game
  void startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        snakeMove();
        //keep the snake moving...

        //check if game is over

        if (gameOver()) {
          timer.cancel();

          //display message to the userr
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('GAMEOVER'),
                content: Text('Current Score is : ' + currentScore.toString()),
              );
            },
          );
        }
      });
    });
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberofSquare);
    }
  }

  void snakeMove() {
    switch (csnakeDir) {
      case snake_Direction.RIGHT:
        {
          //add a new head
          //also adjusting the snake now
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          //add a new head
          //adjusting the snake
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          //add a new head
          //adjusting the snake
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberofSquare);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          //add a new head
          //adjusting the snake
          if (snakePos.last + rowSize > totalNumberofSquare) {
            snakePos.add(snakePos.last + rowSize - totalNumberofSquare);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      //remove tail
      snakePos.removeAt(0);
    }
  }

  //game over
  bool gameOver() {
    //the game is over when snake touches it self
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            //high scores
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //user current score
                      Text(
                        currentScore.toString(),
                        style: TextStyle(fontSize: 36),
                      ),

                      //High scores
                      Text('HighScores...'),
                    ],
                  )
                ],
              ),
            ),
            //game grid
            Expanded(
                flex: 3,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0 &&
                        csnakeDir != snake_Direction.UP) {
                      csnakeDir = snake_Direction.DOWN;
                    } else if (details.delta.dy < 0 &&
                        csnakeDir != snake_Direction.DOWN) {
                      csnakeDir = snake_Direction.UP;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        csnakeDir != snake_Direction.LEFT) {
                      csnakeDir = snake_Direction.RIGHT;
                    } else if (details.delta.dx < 0 &&
                        csnakeDir != snake_Direction.RIGHT) {
                      csnakeDir = snake_Direction.LEFT;
                    }
                  },
                  child: GridView.builder(
                      itemCount: totalNumberofSquare,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10),
                      itemBuilder: (context, index) {
                        if (snakePos.contains(index)) {
                          return const SnakePixel();
                        } else if (foodPos == index) {
                          return const FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                        ;
                      }),
                )),

            //play button
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    child: Text('Play'),
                    color: Colors.pink,
                    onPressed: startGame,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
