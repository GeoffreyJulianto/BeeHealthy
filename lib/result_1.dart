import 'package:flutter/material.dart';
import 'footer.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'schedule_page.dart';
import 'result_new.dart';

class Result1 extends StatefulWidget {
  @override
  State<Result1> createState() => _Result2State();
}

class _Result2State extends State<Result1> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SchedulePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultNew()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  Widget buildBar(double percentage, Color fillColor) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 40,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Container(
          width: 40,
          height: 120 * percentage,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            SizedBox(height: 40),
            SizedBox(height: 40),
            SizedBox(height: 40),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Your undefined below 40%\nGood Job!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    buildBar(0.5, Color(0xFFE981DB)), // 50%
                    SizedBox(height: 8),
                    Text("Productivity"),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 8),
                  ],
                ),
                Column(
                  children: [
                    buildBar(0.6, Color(0xFF0542AB)), // 60%
                    SizedBox(height: 8),
                    Text("Sleep"),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 8),
                  ],
                ),
                Column(
                  children: [
                    buildBar(0.9, Color(0xFF22BA36)), // 90%
                    SizedBox(height: 8),
                    Text("Leisure"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 120),

            Divider(
              thickness: 2,
              color: Colors.black26,
              indent: 32,      // 👈 Space from the left edge
              endIndent: 32,   // 👈 Space from the right edge
            ),

          ],
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
