import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Added
import 'sign_up_page.dart';
import 'questions.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  String password = '';

  Future<String?> _readSavedUserData() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/signup_data.json');

    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  Future<void> _login() async {
    final String emailInput = emailController.text;
    final String passwordInput = passwordController.text;

    final String? jsonString = await _readSavedUserData();

    if (jsonString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user data found. Please sign up first.")),
      );
      return;
    }

    final Map<String, dynamic> user = jsonDecode(jsonString);

    if (user['email'] == emailInput && user['password'] == passwordInput) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height / 3,
              color: const Color(0xFFE0953C),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Log In",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Enter email';
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    buildPasswordField(
                      label: 'Password',
                      obscureText: _obscurePassword,
                      toggleVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      onChanged: (value) => password = value,
                      validator: (value) => value!.length < 6 ? 'Min 6 characters' : null,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE0953C),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 32, top: 16, left: 16, right: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Or"),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _socialButton('Sign in with Apple', 'assets/apple_logo.png'),
                          const SizedBox(height: 15),
                          _socialButton('Sign in with Google', 'assets/google_logo.png'),
                          const SizedBox(height: 15),
                          _socialButton('Sign in with Facebook', 'assets/facebook_logo.png'),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Create new account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignUpPage())
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(String text, String imagePath) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: Colors.black26),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
              child: Image.asset(
                imagePath,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(fontSize: 13, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String label,
    required bool obscureText,
    required void Function() toggleVisibility,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
    required controller
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
