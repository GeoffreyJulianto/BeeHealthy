import 'package:flutter/material.dart';
import 'footer.dart';
// import 'package:beehealthy/components/header.dart';
import 'schedule_page.dart';
import 'home_page.dart';
import 'result_new.dart';
import 'profile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'result_1.dart';


class ScheduleCategoryPage extends StatefulWidget {
  const ScheduleCategoryPage({super.key});

  @override
  State<ScheduleCategoryPage> createState() => _ScheduleCategoryPageState();
}

class _ScheduleCategoryPageState extends State<ScheduleCategoryPage> {
  int _selectedIndex = 1; // Highlight "Plans"

  void _onItemTapped(int index) async {
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
        try {
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/signup_data.json');
          if (await file.exists()) {
            final jsonString = await file.readAsString();
            final Map<String, dynamic> data = jsonDecode(jsonString);
            final bool result = data['result'] == true;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => result ? Result1() : ResultNew(),
              ),
            );
          } else {
            // Fallback if file not found
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ResultNew()),
            );
          }
        } catch (e) {
          debugPrint('Error reading result from file: $e');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResultNew()),
          );
        }
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
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.60, 1.0],
            colors: [
              Color(0xFFFFFFFF), // White
              Color(0xFF8ECBC0), // Light teal
              Color(0xFF1F2B37), // Dark navy
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SchedulePage(),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        const Text(
                          "Add a New Plan",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFFFA941),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Friday, 10th January", style: TextStyle(color: Colors.black)),
                          Icon(Icons.arrow_drop_down, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Start and End Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _timeBox("Start time", "14", "00"),
                    _timeBox("End time", "18", "00"),
                  ],
                ),
              ),

              // Duration Selection
              const Padding(
                padding: EdgeInsets.only(left: 0.0, top: 16, bottom: 8),
                child: Center(
                  child: Text(
                  "Select a Duration",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                  child: Wrap(
                    spacing: 10,
                    children: ["15m", "30m", "45m", "1h"].map((label) {
                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Circular rectangle
                      ),
                      ),
                      onPressed: () {},
                      child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      ),
                    );
                    }).toList(),
                  ),
                  ),
                ),

              // Category Selection
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
                child: Center(
                  child: Text(
                    "Select a Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),

                        child: const Center(
                          child: Text(
                          "Leisure",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),


                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFA941),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(
                          child: Text(
                          "Productivity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Description Box
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
                child: Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                  ),
                  height: 100,
                  child: const Text(
                    "Pre - Training Assistant Laboratory",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              // Save Button
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFA941), // replaces `primary`
            foregroundColor: Colors.black,           // replaces `onPrimary`
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),

                  onPressed: () {},
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),

        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _timeBox(String label, String hour, String minute) {
  return Column(
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Row(
        children: [
          _timeField(hour),
          const Text(
            " : ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _timeField(minute),
        ],
      ),
    ],
  );
}

Widget _timeField(String value) {
  return Container(
    width: 40,
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.zero, // Rectangle shape (no rounded corners)
      border: Border.all(color: Colors.black),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
      ],
    ),
    child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

