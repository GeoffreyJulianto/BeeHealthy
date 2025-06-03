import 'package:flutter/material.dart';
import 'footer.dart';
import 'main.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'schedule_page.dart';
import 'questions.dart';


class ResultNew extends StatefulWidget {
  @override
  State<ResultNew> createState() => _ResultNewState();
}

class _ResultNewState extends State<ResultNew> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 250),
            Center(
              child: Text(
                'You haven\'t unlocked this feature yet.\n\n Please answer our survey so we can\nunderstand you better and give a recommendation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 120),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 16, width: 15,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SleepSurveyBundle()), //ini nanti tinggal diganti sesuai page yang mau dituju
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE0953C),
                      foregroundColor: Colors.black87,
                      minimumSize: Size(200, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), side: BorderSide(color: Colors.black87, width: 1)
                      ),
                    ),
                    child: Text('Go to Quiz', style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  // const SizedBox(height: 16, width: 15,),
                ]
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


      //ini buat navbar component
      bottomNavigationBar: Footer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
