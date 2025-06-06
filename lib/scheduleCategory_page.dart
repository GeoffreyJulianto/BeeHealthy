import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'footer.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'result_1.dart';
import 'result_new.dart';
import 'schedule_page.dart';

class ScheduleCategoryPage extends StatefulWidget {
  const ScheduleCategoryPage({super.key});

  @override
  State<ScheduleCategoryPage> createState() => _ScheduleCategoryPageState();
}

class _ScheduleCategoryPageState extends State<ScheduleCategoryPage> {
  int _selectedIndex = 1;
  String selectedCategory = "Productivity";
  String description = "";
  TimeOfDay startTime = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);
  DateTime selectedDate = DateTime.now();

  void _onItemTapped(int index) async {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SchedulePage()));
        break;
      case 2:
        try {
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/signup_data.json');
          if (await file.exists()) {
            final jsonString = await file.readAsString();
            final Map<String, dynamic> data = jsonDecode(jsonString);
            final bool result = data['result'] == true;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => result ? Result1() : ResultNew()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultNew()));
          }
        } catch (e) {
          debugPrint('Error reading result from file: $e');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultNew()));
        }
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }

  Future<void> _saveSchedule() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/schedule_data.json');

    List<Map<String, dynamic>> schedules = [];

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      schedules = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    }

    final newSchedule = {
      "category": selectedCategory,
      "start_time": "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}",
      "end_time": "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}",
      "description": description,
      "date": "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
    };

    schedules.add(newSchedule);
    await file.writeAsString(jsonEncode(schedules));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SchedulePage()));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.60, 1.0],
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFF8ECBC0),
                  Color(0xFF1F2B37),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const SchedulePage()),
                              );
                            },
                          ),
                        ),
                        const Text(
                          "Add a New Plan",
                          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA941),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${selectedDate.year}-${selectedDate.month}-${selectedDate.day}", style: TextStyle(color: Colors.black)),
                          Icon(Icons.calendar_today, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _timeBox("Start time", startTime, () => _pickTime(true)),
                        _timeBox("End time", endTime, () => _pickTime(false)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text("Select a Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        _categoryButton("Leisure", Colors.yellow),
                        const SizedBox(width: 16),
                        _categoryButton("Productivity", Color(0xFFFFA941)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFA941),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                            border: Border.all(color: Colors.black),
                          ),
                          child: TextField(
                            maxLines: 4,
                            onChanged: (val) => setState(() => description = val),
                            decoration: const InputDecoration.collapsed(hintText: "Enter a short description..."),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA941),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _saveSchedule,
                      child: const Text("Save Changes"),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _timeBox(String label, TimeOfDay time, VoidCallback onTap) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
            ),
            child: Text("${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}"),
          ),
        ),
      ],
    );
  }

  Widget _categoryButton(String category, Color color) {
    final isSelected = selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedCategory = category),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
