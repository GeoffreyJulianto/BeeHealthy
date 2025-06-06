// Your imports remain unchanged
import 'package:flutter/material.dart';
import 'footer.dart';
import 'header.dart';
import 'schedule_page.dart';
import 'result_new.dart';
import 'profile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'result_1.dart';
import 'scheduleCategory_page.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _username;
  DateTime _selectedDate = DateTime.now();
  List<Activity> _dailyActivities = [];

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

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _loadActivitiesForDate(picked);
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
      debugPrint('Error loading username: $e');
    }
  }

  Future<void> _loadActivitiesForDate(DateTime date) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/schedule_data.json');
      if (!await file.exists()) return;

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);

      final dateString = "${date.year}-${date.month}-${date.day}";

      List<Activity> dayActivities = jsonData
          .where((item) => item['date'] == dateString)
          .map((item) => Activity(
        item['description'],
        item['category'] == 'Leisure' ? Colors.green : Colors.pink,
        _parseTimeToDouble(item['start_time']),
        _parseTimeToDouble(item['end_time']),
      ))
          .toList();

      // 🛌 Default sleep from 00.00 to 06.00 if there's at least 1 schedule
      if (dayActivities.isNotEmpty) {
        const double sleepStart = 0.0;
        const double sleepEnd = 6.0;

        // Check overlaps
        bool isFullyOverlapped = dayActivities.any((a) =>
        a.startHour <= sleepStart && a.endHour >= sleepEnd);

        if (!isFullyOverlapped) {
          List<Activity> adjustedSleeps = [];

          // Check partial overlaps and slice accordingly
          bool leftFree = dayActivities.every((a) => a.startHour >= sleepEnd);
          bool rightFree = dayActivities.every((a) => a.endHour <= sleepStart);

          if (leftFree) {
            adjustedSleeps
                .add(Activity('Sleep', Colors.blueGrey, sleepStart, sleepEnd));
          } else {
            // Create non-overlapping segments
            List<Activity> overlaps = dayActivities
                .where((a) => a.endHour > sleepStart && a.startHour < sleepEnd)
                .toList();

            double sleepSegmentStart = sleepStart;

            overlaps.sort((a, b) => a.startHour.compareTo(b.startHour));

            for (var overlap in overlaps) {
              if (overlap.startHour > sleepSegmentStart) {
                adjustedSleeps.add(Activity(
                    'Sleep',
                    Colors.blueGrey,
                    sleepSegmentStart,
                    overlap.startHour.clamp(sleepSegmentStart, sleepEnd)));
              }
              sleepSegmentStart = overlap.endHour > sleepSegmentStart
                  ? overlap.endHour
                  : sleepSegmentStart;
            }

            if (sleepSegmentStart < sleepEnd) {
              adjustedSleeps.add(
                  Activity('Sleep', Colors.blueGrey, sleepSegmentStart, sleepEnd));
            }
          }

          // Add final sleep segments
          dayActivities.addAll(adjustedSleeps);
        }
      }

      setState(() {
        _dailyActivities = dayActivities;
      });
    } catch (e) {
      debugPrint("Error loading activities for date: $e");
    }
  }

  double _parseTimeToDouble(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour + (minute / 60);
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadActivitiesForDate(_selectedDate);
  }

  // Calculate total hours for a given label
  double _calculateTotalHours(String label) {
    double total = 0.0;
    for (var activity in _dailyActivities) {
      if (activity.label.toLowerCase() == label.toLowerCase()) {
        total += activity.duration;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic hours here to update UI on build
    double totalSleepHours = _calculateTotalHours('Sleep');
    double totalProductiveHours = _dailyActivities
        .where((a) =>
    a.label.toLowerCase() != 'sleep' &&
        a.color == Colors.pink) // Assuming pink = productive
        .fold(0.0, (sum, a) => sum + a.duration);

    String formatHours(double hours) {
      int h = hours.floor();
      int m = ((hours - h) * 60).round();
      if (m == 0) return "$h Hours";
      return "$h h $m m";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          children: [
            const Header(),
            const Text("Welcome,", style: TextStyle(fontSize: 18)),
            Text(
              _username ?? "Loading...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFA941),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_formatDate(_selectedDate)}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${_username ?? 'User'}'s Activity",
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            /// 👇 Timeline or fallback
            _dailyActivities.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: const [
                  Icon(Icons.event_busy,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No activities scheduled for this day.",
                    style:
                    TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : buildTimeline(_dailyActivities),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(Icons.bed, "Sleep", formatHours(totalSleepHours)),
                  _summaryItem(
                      Icons.work, "Productive", formatHours(totalProductiveHours)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ScheduleCategoryPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_weekdayName(date.weekday)}, ${date.day} ${_monthName(date.month)}";
  }

  String _weekdayName(int weekday) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return names[weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

// Activity class
class Activity {
  final String label;
  final Color color;
  final double startHour;
  final double endHour;

  Activity(this.label, this.color, this.startHour, this.endHour);

  double get duration => endHour >= startHour
      ? endHour - startHour
      : (24 - startHour + endHour);
}

// Timeline builder
Widget buildTimeline(List<Activity> activities) {
  const double hourHeight = 20;
  const double timelineWidth = 3;
  const double blockWidth = 18;
  const double leftLabelWidth = 100;
  const double timelineCenter = 130;

  final double lineHeight = 24 * hourHeight;

  double _activityCenter(Activity a) =>
      ((a.startHour + (a.duration / 2)) * hourHeight);

  return Center(
    child: SizedBox(
      width: 270,
      height: lineHeight + 16,
      child: Stack(
        children: [
          Positioned(
            left: timelineCenter,
            top: 0,
            bottom: 0,
            child: Container(
              width: timelineWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          for (var h = 0; h <= 24; h += 12)
            Positioned(
              left: timelineCenter + blockWidth / 2 + 8,
              top: (h * hourHeight) - 5,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                color: Colors.white,
                child: Text(
                  _formatHour(h.toDouble()),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
          ...activities.map((activity) {
            final double topOffset = activity.startHour * hourHeight;
            final double height = activity.duration * hourHeight;
            final double centerY = _activityCenter(activity);

            return Stack(
              children: [
                Positioned(
                  top: topOffset,
                  left: timelineCenter - blockWidth / 2,
                  child: Container(
                    width: blockWidth,
                    height: height,
                    decoration: BoxDecoration(
                      color: activity.color,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: activity.color.withOpacity(0.18),
                          blurRadius: 4,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: centerY - 22,
                  left: timelineCenter - leftLabelWidth - blockWidth / 1,
                  width: leftLabelWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: activity.color.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          activity.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: activity.color.darken(0.2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${_formatHour(activity.startHour)} - ${_formatHour(activity.endHour)}",
                        style:
                        const TextStyle(fontSize: 10, color: Colors.black54),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    ),
  );
}

String _formatHour(double hour) {
  final int h = hour.floor();
  final int m = ((hour - h) * 60).round();
  return '${h.toString().padLeft(2, '0')}.${m.toString().padLeft(2, '0')}';
}

extension ColorShade on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class _summaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;

  const _summaryItem(this.icon, this.label, this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(time),
      ],
    );
  }
}
