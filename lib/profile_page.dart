import 'package:flutter/material.dart';
import 'main.dart';
import 'result_2.dart';
import 'result_1.dart';
import 'result_new.dart';
import 'home_page.dart';
import 'footer.dart';
import 'schedule_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // Needed for jsonDecode
import 'dart:io';      // Needed for File


void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  String? _username;

  final List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.receipt_long,
    Icons.person,
  ];

  final List<String> _labels = [
    "Home",
    "Plans",
    "Results",
    "Profile",
  ];

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

  Future<void> _loadUsername() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/signup_data.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> user = jsonDecode(jsonString);
        setState(() {
          _username = user['username'];
        });
      }
    } catch (e) {
      // Handle any read/parse errors
      debugPrint('Error loading username: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 3),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xCCD1DEC1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(flex: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    "${_username ?? 'User'}'s Profile",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    color: Colors.black26,
                    thickness: 2,
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
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
