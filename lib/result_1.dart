import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'footer.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'schedule_page.dart';

class Result1 extends StatefulWidget {
  @override
  State<Result1> createState() => _Result1State();
}

class _Result1State extends State<Result1> {
  int _selectedIndex = 2;

  double sleepPercentage = 0.0;
  double productivityPercentage = 0.0;
  double leisurePercentage = 0.0;

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
          MaterialPageRoute(builder: (context) => Result1()),
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
          height: 200 * percentage,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Future<void> calculateDailyProgress() async {
    final directory = await getApplicationDocumentsDirectory();

    final profileFile = File('${directory.path}/productivity_profile.json');
    final scheduleFile = File('${directory.path}/schedule_data.json');

    if (!await profileFile.exists() || !await scheduleFile.exists()) return;

    final profileData = json.decode(await profileFile.readAsString());
    final scheduleData = json.decode(await scheduleFile.readAsString());

    final double refSleep = (profileData['sleep'] as num).toDouble();
    final double refProductivity = (profileData['productivity'] as num).toDouble();
    final double refLeisure = (profileData['leisure'] as num).toDouble();

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";

    double totalProductivity = 0.0;
    double totalLeisure = 0.0;

    // Default sleep time: 00:00 to 06:00
    final double sleepStart = 0.0;
    final double sleepEnd = 6.0;
    double totalSleep = sleepEnd - sleepStart;

    for (var item in scheduleData) {
      if (item['date'] != todayStr) continue;

      final category = (item['category'] as String).toLowerCase();
      final startParts = item['start_time'].split(":");
      final endParts = item['end_time'].split(":");

      final startHour = double.parse(startParts[0]) + double.parse(startParts[1]) / 60.0;
      final endHour = double.parse(endParts[0]) + double.parse(endParts[1]) / 60.0;
      final duration = (endHour - startHour).clamp(0.0, 24.0);

      if (category == 'productivity') {
        totalProductivity += duration;
      } else if (category == 'leisure') {
        totalLeisure += duration;
      }

      // Deduct overlap from default sleep time
      double overlapStart = startHour.clamp(sleepStart, sleepEnd);
      double overlapEnd = endHour.clamp(sleepStart, sleepEnd);
      double overlap = (overlapEnd - overlapStart).clamp(0.0, 6.0);
      totalSleep -= overlap;
    }

    totalSleep = totalSleep.clamp(0.0, refSleep);

    setState(() {
      sleepPercentage = (totalSleep / refSleep).clamp(0.0, 1.0);
      productivityPercentage = (totalProductivity / refProductivity).clamp(0.0, 1.0);
      leisurePercentage = (totalLeisure / refLeisure).clamp(0.0, 1.0);
    });
  }

  Future<void> resetQuiz() async {
    final directory = await getApplicationDocumentsDirectory();

    final profileFile = File('${directory.path}/productivity_profile.json');
    if (await profileFile.exists()) {
      await profileFile.delete();
    }

    final answersFile = File('${directory.path}/survey_answers.json');
    if (await answersFile.exists()) {
      await answersFile.delete();
    }

    final signupFile = File('${directory.path}/signup_data.json');
    if (await signupFile.exists()) {
      final content = await signupFile.readAsString();
      final data = jsonDecode(content);
      data['result'] = false;
      await signupFile.writeAsString(jsonEncode(data), flush: true);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz reset successfully.")),
    );
  }

  @override
  void initState() {
    super.initState();
    calculateDailyProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(
                    'Your Productivity Summary',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      productivityPercentage >= 1.0
                          ? "You have achieved today's productivity goal. Good Job"
                          : "You haven't achieved today's productivity goal. Let's do better",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    buildBar(productivityPercentage, Color(0xFFE981DB)),
                    SizedBox(height: 8),
                    Text("Productivity"),
                  ],
                ),
                Column(
                  children: [
                    buildBar(sleepPercentage, Color(0xFF0542AB)),
                    SizedBox(height: 8),
                    Text("Sleep"),
                  ],
                ),
                Column(
                  children: [
                    buildBar(leisurePercentage, Color(0xFF22BA36)),
                    SizedBox(height: 8),
                    Text("Leisure"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFA941),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Reset Quiz"),
                    content: const Text("Are you sure you want to reset the quiz?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
                    ],
                  ),
                );

                if (confirm == true) {
                  await resetQuiz();
                }
              },
              child: const Text("Reset Quiz"),
            ),
            SizedBox(height: 40),
            Divider(
              thickness: 2,
              color: Colors.black26,
              indent: 32,
              endIndent: 32,
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
