import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color to match scroll content
      // padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Image.asset(
            'assets/logo.png',
            width: 100,
            height: 100,
            ),
            Row(
            children: [
              IconButton(
              icon: SvgPicture.asset(
                'assets/notification.svg',
                width: 40,
                height: 40,
              ),
              onPressed: () {},
              ),
              const SizedBox(width: 4),
              CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/headerProfile.svg',
                width: 40,
                height: 40,
                // color: Colors.white,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
