import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'settings_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Offset> balls = [];
  List<Offset> hearts = [];
  List<Offset> boosters = [];

  double paddleX = 100;
  double paddleWidth = 100;
  final double normalPaddleWidth = 100;
  final double boostedPaddleWidth = 180;
  bool isBoosted = false;

  double ballSize = 30;
  double paddleHeight = 20;

  int score = 0;
  int lives = 3;
  bool isGameOver = false;
  bool isPaused = false;

  late Timer gameLoop;
  Random rand = Random();
  late double speed;

  Color currentBgColor = Settings.backgroundColor;
  String praise = "Cupu";

  double screenWidth = 300;
  double screenHeight = 300;

  final List<Color> themes = [
    Colors.indigo[900]!,
    Colors.teal[800]!,
    Colors.deepPurple[700]!,
    Colors.orange[900]!,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      screenWidth = size.width;
      screenHeight = size.height;
      paddleX = (screenWidth - paddleWidth) / 2;
      startGame();
    });
    setSpeed();
  }

  void setSpeed() {
    speed = switch (Settings.difficulty) {
      'Mudah' => 4,
      'Sedang' => 6,
      'Sulit' => 8,
      _ => 6,
    };
  }

  void handleScoreUpdate() {
    if (score % 10 == 0 && score != 0) {
      speed += 0.5;
      int themeIndex = (score ~/ 10) % themes.length;
      currentBgColor = themes[themeIndex];
    }

    if (score % 20 == 0 && balls.length < 4) {
      double spacing = -100.0 * balls.length;
      balls.add(Offset(rand.nextDouble() * (screenWidth - ballSize), spacing));
    }

    if (rand.nextDouble() < 0.1 && hearts.length < 1) {
      hearts.add(Offset(rand.nextDouble() * (screenWidth - ballSize), -150));
    }

    if (rand.nextDouble() < 0.1 && boosters.length < 1) {
      boosters.add(Offset(rand.nextDouble() * (screenWidth - ballSize), -200));
    }

    if (score < 10) {
      praise = "Cupu";
    } else if (score < 20) {
      praise = "Lumayan";
    } else if (score < 30) {
      praise = "Mantap";
    } else if (score < 40) {
      praise = "Hebat";
    } else {
      praise = "Jago!";
    }
  }

  void startGame() {
    balls = [Offset(rand.nextDouble() * (screenWidth - ballSize), 0)];
    hearts.clear();
    boosters.clear();
    score = 0;
    lives = 3;
    isGameOver = false;
    isPaused = false;
    isBoosted = false;
    paddleWidth = normalPaddleWidth;
    praise = "Cupu";
    currentBgColor = Settings.backgroundColor;

    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (isPaused || isGameOver) return;

      setState(() {
        for (int i = 0; i < balls.length; i++) {
          double x = balls[i].dx;
          double y = balls[i].dy + speed;
          double paddleY = screenHeight * 0.8;

          if (y + ballSize >= paddleY &&
              y <= paddleY + paddleHeight &&
              x + ballSize > paddleX &&
              x < paddleX + paddleWidth) {
            score += 1;
            handleScoreUpdate();
            x = rand.nextDouble() * (screenWidth - ballSize);
            y = -100.0 * i;
          }

          if (y > screenHeight) {
            lives -= 1;
            if (lives <= 0) {
              isGameOver = true;
              gameLoop.cancel();
              showGameOverDialog();
              return;
            } else {
              x = rand.nextDouble() * (screenWidth - ballSize);
              y = -100.0 * i;
            }
          }

          balls[i] = Offset(x, y);
        }

        for (int i = 0; i < hearts.length; i++) {
          double x = hearts[i].dx;
          double y = hearts[i].dy + speed;
          double paddleY = screenHeight * 0.8;

          if (y + ballSize >= paddleY &&
              y <= paddleY + paddleHeight &&
              x + ballSize > paddleX &&
              x < paddleX + paddleWidth) {
            if (lives < 3) lives += 1;
            hearts.removeAt(i);
            break;
          }

          if (y > screenHeight) {
            hearts.removeAt(i);
            break;
          }

          hearts[i] = Offset(x, y);
        }

        for (int i = 0; i < boosters.length; i++) {
          double x = boosters[i].dx;
          double y = boosters[i].dy + speed;
          double paddleY = screenHeight * 0.8;

          if (y + ballSize >= paddleY &&
              y <= paddleY + paddleHeight &&
              x + ballSize > paddleX &&
              x < paddleX + paddleWidth) {
            boosters.removeAt(i);
            activateBooster();
            break;
          }

          if (y > screenHeight) {
            boosters.removeAt(i);
            break;
          }

          boosters[i] = Offset(x, y);
        }
      });
    });
  }

  void activateBooster() {
    if (isBoosted) return;

    setState(() {
      isBoosted = true;
      paddleWidth = boostedPaddleWidth;
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        isBoosted = false;
        paddleWidth = normalPaddleWidth;
      });
    });
  }

  void movePaddle(double dx) {
    setState(() {
      paddleX += dx;
      if (paddleX < 0) paddleX = 0;
      if (paddleX > screenWidth - paddleWidth) {
        paddleX = screenWidth - paddleWidth;
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Skor kamu: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                startGame();
              });
            },
            child: const Text("Main Lagi"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Kembali"),
          ),
        ],
      ),
    );
  }

  void showPauseDialog() {
    setState(() {
      isPaused = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pause"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isPaused = false;
              });
            },
            child: const Text("Lanjut"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameLoop.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color paddleColor = Settings.paddleColor;
    if (paddleColor.value == Settings.backgroundColor.value) {
      paddleColor = Colors.white;
    }

    return Scaffold(
      backgroundColor: currentBgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          screenWidth = constraints.maxWidth;
          screenHeight = constraints.maxHeight;

          return GestureDetector(
            onPanUpdate: (details) {
              if (!isPaused) {
                movePaddle(details.delta.dx);
              }
            },
            child: Stack(
              children: [
                for (final ball in balls)
                  Positioned(
                    left: ball.dx,
                    top: ball.dy,
                    child: Container(
                      width: ballSize,
                      height: ballSize,
                      decoration: BoxDecoration(
                        color: Settings.ballColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                for (final heart in hearts)
                  Positioned(
                    left: heart.dx,
                    top: heart.dy,
                    child: Icon(Icons.favorite, color: Colors.pink, size: ballSize),
                  ),

                for (final booster in boosters)
                  Positioned(
                    left: booster.dx,
                    top: booster.dy,
                    child: Icon(Icons.flash_on, color: Colors.amber, size: ballSize),
                  ),

                Positioned(
                  left: paddleX,
                  top: screenHeight * 0.8,
                  child: Container(
                    width: paddleWidth,
                    height: paddleHeight,
                    decoration: BoxDecoration(
                      color: paddleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text("Skor: $score", style: const TextStyle(color: Colors.white, fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(praise, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          return Icon(
                            i < lives ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent,
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.pause, color: Colors.white, size: 30),
                    onPressed: showPauseDialog,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
