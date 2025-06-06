import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final imagePathFile = File('${dir.path}/profile_image_path.txt');
      if (await imagePathFile.exists()) {
        final imagePath = await imagePathFile.readAsString();
        setState(() {
          _profileImage = File(imagePath);
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                radius: 22,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? SvgPicture.asset(
                  'assets/headerProfile.svg',
                  width: 28,
                  height: 28,
                )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
