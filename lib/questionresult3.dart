import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProductivityProfile3(),
  ));
}

class ProductivityProfile3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 72),
          Text(
            "Productivity Profile",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFBE9CEA), // Light blue (top)
                    Color(0xFFBE9CEA), // Still light blue
                    Color(0xFF1F2B37), // Slightly darker at bottom
                  ],
                  stops: [0.0, 0.1, 1.0], // Apply darkening only in last 20%
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/trident.png',
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Typical Maestro",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"Typical Maestro" embodies a revolutionary method for productivity, where you excel at conducting tasks and projects with mastery. Adopting the "Typical Maestro" mindset enchances your performance and leaves a remarkable impression aking to a captivating musical composition',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 36),

                    Center(
                      child: CustomPaint(
                        size: Size(330, 330),
                        painter: PieChartPainter(),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const SizedBox(height: 48),

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE59B3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: Colors.black87, // border color
                              width: 1.5,            // border thickness
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 13),
                        ),
                        onPressed: () {
                          updateJsonResult();
                        },
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/signup_data.json'); // 🔁 Updated file path
  }

  Future<void> updateJsonResult() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonData = json.decode(content);

        if (jsonData is Map) {
          jsonData['result'] = true; // ✅ Set result to true
          await file.writeAsString(json.encode(jsonData));
          print('Updated "result" to true in signup_data.json.');
        } else {
          print('signup_data.json is not a valid JSON object.');
        }
      } else {
        print('signup_data.json does not exist.');
      }
    } catch (e) {
      print('Error updating signup_data.json: $e');
    }
  }
}

class PieChartPainter extends CustomPainter {
  final List<_PieSegment> segments = [
    _PieSegment(color: Color(0xFF9EFFA2), percentage: 0.45, label: '45% (10.8h)\nLeisure'),
    _PieSegment(color: Color(0xFF647BF6), percentage: 0.25, label: '25% (6h)\nSleep'),
    _PieSegment(color: Color(0xFFFFC78B), percentage: 0.3, label: '30% (7.2h)\nProductive'),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

// Draw shadow
    final shadowPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(center, radius - 10, shadowPaint);
    double startAngle = -pi / 2;



    for (final segment in segments) {
      final sweepAngle = segment.percentage * 2 * pi;
      paint.color = segment.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Label positioning
      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius = radius * 0.65;
      final labelX = center.dx + labelRadius * cos(labelAngle);
      final labelY = center.dy + labelRadius * sin(labelAngle);

      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      final textSpan = TextSpan(
        text: segment.label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );

      textPainter.text = textSpan;
      textPainter.layout(maxWidth: radius);

      // White background behind label
      final bgRect = Rect.fromLTWH(
        labelX - textPainter.width / 2 - 4,
        labelY - textPainter.height / 2 - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      );

      final bgPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, Radius.circular(6)),
        bgPaint,
      );

      // Draw text
      canvas.save();
      canvas.translate(
        labelX - textPainter.width / 2,
        labelY - textPainter.height / 2,
      );
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();

      startAngle += sweepAngle;
    }

    // Draw black border around the pie chart
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _PieSegment {
  final Color color;
  final double percentage;
  final String label;

  _PieSegment({
    required this.color,
    required this.percentage,
    required this.label,
  });
}
