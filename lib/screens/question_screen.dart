import 'dart:async';
import 'dart:math';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../utils/questions.dart';
import 'success_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int questionIndex = 0;

  double yesSize = 1.0;
  double noSize = 1.0;

  bool hasMoved = false;
  double noTop = 0;
  double noLeft = 0;

  bool musicStarted = false;
  html.AudioElement? audio;

  final Random random = Random();

  /// ================= MUSIC (WEB SAFE) =================

  void startMusicIfNeeded() {
    if (!musicStarted) {
      musicStarted = true;

      audio = html.AudioElement('assets/music/Love.mp3')
        ..loop = true
        ..volume = 0.7
        ..play();
    }
  }

  /// ================= BUTTON LOGIC =================

  void moveNoButton(BuildContext context) {
    final size = MediaQuery.of(context).size;

    setState(() {
      hasMoved = true;
      noLeft = random.nextDouble() * (size.width - 140);
      noTop = random.nextDouble() * (size.height - 140);
    });
  }

  void onNoPressed() {
    startMusicIfNeeded();

    if (questionIndex < questions.length - 1) {
      setState(() {
        yesSize += 0.3;
        noSize -= 0.2;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          questionIndex++;
        });
      });
    }
  }

  void onYesPressed() {
    startMusicIfNeeded();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const SuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLast = questionIndex == questions.length - 1;

    Widget noButton = AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: noSize,
      child: MouseRegion(
        onEnter: isLast ? (_) => moveNoButton(context) : null,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade200,
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: isLast ? () {} : onNoPressed,
          child: const Text("NO 💔"),
        ),
      ),
    );

    Widget yesButton = AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: yesSize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade200,
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onYesPressed,
        child: const Text("YES ❤️"),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: SafeArea(
        child: Stack(
          children: [

            /// MAIN CONTENT
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    images[questionIndex],
                    height: 250,
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      questions[questionIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  if (!isLast || !hasMoved)
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        noButton,
                        const SizedBox(width: 30),
                        yesButton,
                      ],
                    ),

                  if (isLast && hasMoved)
                    yesButton,
                ],
              ),
            ),

            if (isLast && hasMoved)
              Positioned(
                top: noTop,
                left: noLeft,
                child: noButton,
              ),
          ],
        ),
      ),
    );
  }
}
