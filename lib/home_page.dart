import 'package:flutter/material.dart';
import 'footer.dart';
import 'header.dart';
import 'schedule_page.dart';
import 'result_new.dart';
import 'profile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // Needed for jsonDecode
import 'dart:io';      // Needed for File
import 'questionresult1.dart';

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

  final List<Widget> _pages = [
    const HomePage(),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          children: [
            const Header(),
            // const SizedBox(height: 10),
            const Text("Welcome,", style: TextStyle(fontSize: 18)),
            Text(
              _username ?? "Loading...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                  Text("Wednesday, 1st January", style: TextStyle(color: Colors.black)),
                  Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${_username ?? 'User'}'s Activity",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            buildTimeline([
              Activity("Sleep time", Colors.blue, 0, 7),
              Activity("Leisure time", Colors.green, 8, 9.5),
              Activity("Productivity time", Colors.pink, 10, 17),
              Activity("Leisure time", Colors.green, 18, 20),
              Activity("Sleep time", Colors.blue, 21, 0),
            ]),
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
                children: const [
                  _summaryItem(Icons.bed, "Sleep", "10 Hours"),
                  _summaryItem(Icons.work, "Productive", "8 Hours"),
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
              MaterialPageRoute(builder: (context) => ProductivityProfile1())
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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

Widget buildTimeline(List<Activity> activities) {
  const double hourHeight = 20;
  const double timelineWidth = 3;
  const double blockWidth = 18;
  const double leftLabelWidth = 100;
  const double timelineCenter = 130;

  final double lineHeight = 24 * hourHeight;

  // Helper to get the center of an activity block
  double _activityCenter(Activity a) =>
      ((a.startHour + (a.duration / 2)) * hourHeight);

  return Center(
    child: SizedBox(
      width: 270,
      height: lineHeight + 16,
      child: Stack(
        children: [
          // Central vertical line
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
          // Hour markers (now inside the timeline, at 0, 12, 24)
          for (var h = 0; h <= 24; h += 12)
            Positioned(
              left: timelineCenter + blockWidth / 2 + 8,
              top: (h * hourHeight) - 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                color: Colors.white,
                child: Text(
                  _formatHour(h.toDouble()),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
          // Activity blocks and their labels
          ...activities.map((activity) {
            final double topOffset = activity.startHour * hourHeight;
            final double height = activity.duration * hourHeight;
            final double centerY = _activityCenter(activity);

            return Stack(
              children: [
                // Block directly on center line
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
                // Time range + label centered vertically to the left of the block
                Positioned(
                  top: centerY - 22, 
                  left: timelineCenter - leftLabelWidth - blockWidth / 1,
                  width: leftLabelWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
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

// Extension to darken a color for label text
extension ColorShade on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}



String _formatHour(double hour) {
  final int h = hour.floor();
  final int m = ((hour - h) * 60).round();
  return '${h.toString().padLeft(2, '0')}.${m.toString().padLeft(2, '0')}';
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
