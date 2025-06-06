import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap, // ← use the passed callback
      backgroundColor: const Color(0xFF1A1A2E),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/home.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? Colors.orange : const Color.fromARGB(255, 135, 206, 250),
              BlendMode.srcIn,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/plans.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? Colors.orange : const Color.fromARGB(255, 135, 206, 250),
              BlendMode.srcIn,
            ),
          ),
          label: 'Plans',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/results.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 2 ? Colors.orange : const Color.fromARGB(255, 135, 206, 250),
              BlendMode.srcIn,
            ),
          ),
          label: 'Results',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/profile.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 3 ? Colors.orange : const Color.fromARGB(255, 135, 206, 250),
              BlendMode.srcIn,
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}

