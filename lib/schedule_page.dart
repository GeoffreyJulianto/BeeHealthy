import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'footer.dart';
import 'scheduleCategory_page.dart';
import 'home_page.dart';
import 'result_new.dart';
import 'profile_page.dart';
import 'result_1.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedIndex = 1;
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/schedule_data.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> data = jsonDecode(jsonString);
        setState(() {
          _schedules = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint('Error loading schedules: $e');
    }
  }

  Future<void> _saveSchedules() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/schedule_data.json');
      final jsonString = jsonEncode(_schedules);
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving schedules: $e');
    }
  }

  Future<void> _deleteSchedule(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Schedule"),
        content: const Text("Are you sure you want to delete this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _schedules.removeAt(index);
      });
      await _saveSchedules();
    }
  }

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

  void _navigateToScheduleCategory() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScheduleCategoryPage()),
    );
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
              Color(0xFFFFFFFF),
              Color(0xFF8ECBC0),
              Color(0xFF1F2B37),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Add New Schedule",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _navigateToScheduleCategory,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Add a new schedule',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _schedules.isEmpty
                    ? const Center(
                  child: Text(
                    "No schedules available.",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: _schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = _schedules[index];
                    final color = schedule['category'] == 'Productivity'
                        ? const Color(0xFFFFA941)
                        : Colors.yellow;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${schedule['date']} | ${schedule['start_time']} - ${schedule['end_time']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(schedule['description'] ?? '',
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSchedule(index),
                          ),
                        ],
                      ),
                    );
                  },
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
