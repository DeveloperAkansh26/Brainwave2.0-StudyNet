import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage>
    with TickerProviderStateMixin {
  final List<Map<String, String>> flashcards = [
    {"question": "Start Flashcards", "answer": ""},
    {
      "question": "What is supervised learning?",
      "answer": "A type of ML where the model is trained on labeled data."
    },
    {
      "question": "Define overfitting.",
      "answer":
          "When the model performs well on training data but poorly on test data."
    },
    {
      "question": "What is gradient descent?",
      "answer":
          "An optimization algorithm to minimize loss by updating weights."
    },
    {
      "question": "Explain confusion matrix.",
      "answer":
          "A table that describes the performance of a classification model."
    },
  ];

  late final AnimationController _flipController;
  late final AnimationController _swipeController;

  int currentIndex = 0;
  bool isShowingAnswer = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // ignore taps while animating
    if (_flipController.isAnimating || _swipeController.isAnimating) return;

    final current = flashcards[currentIndex];

    // START card: just swipe it out (tilt left)
    if (current["question"] == "Start Flashcards" && (current["answer"] ?? "") == "") {
      _swipeLeftThenNext();
      return;
    }

    // If question side visible -> flip to answer
    if (!isShowingAnswer) {
      _flipController.forward().whenComplete(() {
        setState(() => isShowingAnswer = true);
      });
      return;
    }

    // If answer is visible -> swipe left out and go to next
    if (isShowingAnswer) {
      _swipeLeftThenNext();
    }
  }

  void _swipeLeftThenNext() {
    // animate swipe left (value 0.0 -> 1.0); animation builder will map to dx and tilt
    _swipeController.forward().whenComplete(() {
      _swipeController.reset();
      _flipController.reset();
      setState(() {
        isShowingAnswer = false;
        if (currentIndex < flashcards.length - 1) {
          currentIndex++;
        } else {
          // finished all cards
          _showFinishedDialog();
        }
      });
    });
  }

  Future<void> _showFinishedDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text("Finished!"),
        content: const Text("You've gone through all flashcards."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(c).pop();
            },
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(c).pop();
              setState(() {
                currentIndex = 0;
                isShowingAnswer = false;
                _flipController.reset();
                _swipeController.reset();
              });
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final screenW = MediaQuery.of(context).size.width;
  final cardHeight = MediaQuery.of(context).size.height * 0.78;

  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Flashcards",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Center(
        child: GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_swipeController, _flipController]),
            builder: (context, _) {
              final swipeVal = _swipeController.value;
              final dx = -1.6 * swipeVal * screenW;
              final tilt = -0.22 * swipeVal;

              final flipVal = _flipController.value;
              final angle = flipVal * math.pi;
              final showFront = angle <= (math.pi / 2);

              // Card surface (with gloss overlay)
              Widget cardSurface(String text, double fontSize) {
                return Container(
                  width: double.infinity,
                  height: cardHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: pastelColors[currentIndex % pastelColors.length],
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 30,
                        spreadRadius: 4,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Card text
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      // FULL glossy overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Decide front/back text
              final frontText = flashcards[currentIndex]["question"]!;
              final backText = flashcards[currentIndex]["answer"]!;

              // Build card sides
              final front = cardSurface(frontText, 32);
              final back = cardSurface(backText, 22);

              // Flip transform on the whole card
              Widget rotatedCard;
              if (showFront) {
                rotatedCard = Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child: front,
                );
              } else {
                rotatedCard = Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle - math.pi),
                  alignment: Alignment.center,
                  child: back,
                );
              }

              // Apply swipe + tilt to whole card
              final transform = Matrix4.identity()
                ..translate(dx)
                ..rotateZ(tilt);

              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: rotatedCard,
              );
            },
          ),
        ),
      ),
    ),
  );
}


  // Pastel color palette
  final List<Color> pastelColors = [
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
  ];
}
