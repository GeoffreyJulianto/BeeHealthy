import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const BeeProductiveApp());
}

class BeeProductiveApp extends StatelessWidget {
  const BeeProductiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeeHealthy',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🐝 Bee image placeholder
                SizedBox(
                  height: 150,
                  child: Image.asset(
                    'assets/bee_img_logo.png', // Replace with your image asset
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to\nBeeHealthy!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(229, 155, 60, 1),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text('SIGN UP',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Or'),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 10),
                _socialButton('Sign in with Apple', 'assets/apple_logo.png'),
                const SizedBox(height: 10),
                _socialButton('Sign in with Google', 'assets/google_logo.png'),
                const SizedBox(height: 10),
                _socialButton('Sign in with Facebook', 'assets/facebook_logo.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  Widget _socialButton(String text, String imagePath) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5), // Customize this as needed
              child: Image.asset(
                imagePath,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(text, style: TextStyle(fontSize: 15, color: Colors.black)),
          ],
        ),
      ),
    );
  }

