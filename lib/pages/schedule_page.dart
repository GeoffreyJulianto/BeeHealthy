import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:beehealthy/components/footer.dart';
import 'package:beehealthy/pages/home_page.dart';
import 'package:beehealthy/pages/scheduleCategory_page.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedIndex = 1; // Highlight "Plans"

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        // Already on Plans
        break;
      case 2:
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResultsPage()));
        break;
      case 3:
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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
              Color(0xFFFFFFFF), // White
              Color(0xFF8ECBC0), // Light teal
              Color(0xFF1F2B37), // Dark navy
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top AppBar replacement
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

              // const SizedBox(height: 100), // Spacing

              // Add Schedule Button
                GestureDetector(
                onTap: _navigateToScheduleCategory,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1.2),
                  borderRadius: BorderRadius.circular(10),
                  // Remove color to make background transparent and follow page gradient
                  // color: Colors.white.withOpacity(0.85),
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

              // Expand remaining space so footer goes to bottom
              const Spacer(),
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
