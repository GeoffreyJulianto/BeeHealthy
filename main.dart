import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeeProductive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display', // iOS-like font
      ),

      home: LoginScreen (), debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35),
              // Bee Logo Placeholder
              SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Image.asset(
                    'assets/bee_logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Welcome Text
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'BeeProductive!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 60),
              // Sign in with Apple button
              _buildSignInButton(
                icon: Icon(Icons.apple, color: Colors.black, size: 30,),
                text: 'Sign in with Apple',
                onPressed: () {},
              ),
              SizedBox(height: 20),
              // Sign in with Google button
              _buildSignInButton(
                icon: Image.asset('assets/google_logo.png', width: 27, height: 27),
                text: 'Sign in with Google',
                onPressed: () {},
              ),
              SizedBox(height: 20),
              // Sign in with Facebook button
              _buildSignInButton(
                icon: Icon(Icons.facebook, color: Colors.blue, size: 30),
                text: 'Sign in with Facebook',
                onPressed: () {},
              ),
              SizedBox(height: 15),
              // Divider with text
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              SizedBox(height: 15),
              // Sign up button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.black87,
                  minimumSize: Size(130, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), side: BorderSide(color: Colors.black87, width: 1)
                  ),
                ),
                child: Text('Sign Up', style: TextStyle(fontSize: 17, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton({
    required Widget icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 60),
        side: BorderSide(color: Colors.black, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87
              )),
        ],
      ),
    );
  }
}