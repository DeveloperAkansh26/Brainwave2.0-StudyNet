import 'dart:math' as math;
import 'package:flutter/material.dart';

class NotesPageStudent extends StatefulWidget {
  const NotesPageStudent({super.key});

  @override
  State<NotesPageStudent> createState() => _NotesPageStudentState();
}

class _NotesPageStudentState extends State<NotesPageStudent> {
  String? _selectedLecture;
  bool _showNotes = false;

  final List<String> _lectures = ["Lecture 1", "Lecture 2", "Lecture 3"];

  // Expanded topic list for bigger mindmap
  final List<String> _topics = [
    "Machine Learning basics",
    "Supervised Learning",
    "Unsupervised Learning",
    "Overfitting",
    "Underfitting",
    "Activation Functions",
    "Gradient Descent",
    "Neural Networks",
    "Evaluation Metrics",
    "Regularization"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            )),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Lecture Dropdown
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Choose Lecture"),
                    value: _selectedLecture,
                    isExpanded: true,
                    items: _lectures.map((lecture) {
                      return DropdownMenuItem<String>(
                        value: lecture,
                        child: Text(lecture),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLecture = value;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Generate Notes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLecture != null) {
                    setState(() {
                      _showNotes = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a lecture first"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Generate Notes",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_showNotes)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Topics Covered",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        children: _topics
                            .map((topic) => Text(
                                  "• $topic",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Mindmap",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: SizedBox(
                          height: 500, // bigger mindmap
                          width: double.infinity,
                          child: CustomPaint(
                            painter: MindMapPainter(_topics),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MindMapPainter extends CustomPainter {
  final List<String> topics;
  MindMapPainter(this.topics);

  // Color palette
  final List<Color> colors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Central node position
    final Offset center = Offset(centerX, centerY);

    // Outer nodes
    final double radius = math.min(size.width, size.height) * 0.38; // reduced radius
    final int n = topics.length;
    final double step = (2 * math.pi) / n;

    for (int i = 0; i < n; i++) {
      final double angle = -math.pi / 2 + i * step;
      final Offset node = Offset(centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle));

      // Draw connector (behind circles/text)
      final Path path = Path();
      path.moveTo(center.dx, center.dy);
      final Offset control =
          Offset((center.dx + node.dx) / 2, (center.dy + node.dy) / 2 - 20);
      path.quadraticBezierTo(control.dx, control.dy, node.dx, node.dy);
      canvas.drawPath(path, linePaint);

      // Node circle
      final Color nodeColor = colors[i % colors.length];
      canvas.drawCircle(node, 50, Paint()..color = nodeColor.withOpacity(0.25));
      canvas.drawCircle(node, 42, Paint()..color = nodeColor);

      // Node label (smaller font)
      _drawText(canvas, node, topics[i], Colors.white,
          fontSize: 11, maxWidth: 85);
    }

    // Draw central node LAST (on top of lines)
    const double centerRadius = 48;
    canvas.drawCircle(
        center, centerRadius + 8, Paint()..color = Colors.deepPurple[100]!);
    canvas.drawCircle(center, centerRadius,
        Paint()..color = Colors.deepPurple.shade700);
    _drawText(canvas, center, "ML", Colors.white,
        fontSize: 18, maxWidth: 120);
  }

  void _drawText(Canvas canvas, Offset position, String text, Color color,
      {double fontSize = 12, double maxWidth = 80}) {
    final TextSpan span = TextSpan(
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins"),
      text: text,
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    tp.paint(
        canvas, Offset(position.dx - tp.width / 2, position.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
