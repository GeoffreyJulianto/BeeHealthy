import 'package:flutter/material.dart';
import 'result_1.dart';
import 'result_new.dart';
import 'home_page.dart';
import 'footer.dart';
import 'schedule_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  String? _username;
  File? _profileImage;

  final List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.receipt_long,
    Icons.person,
  ];

  final List<String> _labels = [
    "Home",
    "Plans",
    "Results",
    "Profile",
  ];

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

      final imagePathFile = File('${dir.path}/profile_image_path.txt');
      if (await imagePathFile.exists()) {
        final imagePath = await imagePathFile.readAsString();
        setState(() {
          _profileImage = File(imagePath);
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  Future<void> _pickImage() async {

    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (Platform.isAndroid) {
      final androidVersion = int.parse(androidInfo.version.sdkInt.toString());

      final permission = androidVersion >= 33
          ? Permission.photos  // use Permission.photos for Android 13+
          : Permission.storage;

      final status = await permission.request();

      if (!status.isGranted) {
        debugPrint('Permission denied');
        return;
      }
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);


    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final savedImage = await File(pickedFile.path)
          .copy('${dir.path}/${path.basename(pickedFile.path)}');

      final pathFile = File('${dir.path}/profile_image_path.txt');
      await pathFile.writeAsString(savedImage.path);

      setState(() {
        _profileImage = savedImage;
      });
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
        child: Column(
          children: [
            Spacer(flex: 3),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xCCD1DEC1),
                    shape: BoxShape.circle,
                    image: _profileImage != null
                        ? DecorationImage(
                      image: FileImage(_profileImage!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _profileImage == null
                      ? Icon(
                    Icons.add,
                    size: 80,
                    color: Colors.white,
                  )
                      : null,
                ),
              ),
            ),
            Spacer(flex: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    "${_username ?? 'User'}'s Profile",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    color: Colors.black26,
                    thickness: 2,
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
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
