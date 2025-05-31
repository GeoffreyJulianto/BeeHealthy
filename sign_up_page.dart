import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'login_page.dart';

void main() => runApp(const MaterialApp(home: SignUpPage(), debugShowCheckedModeBanner: false));

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Gender
  String gender = 'Male';

  // Date of Birth
  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = 2000;

  // Password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String password = '';
  String confirmPassword = '';

  // Save data to JSON file
  Future<void> saveToJson(Map<String, dynamic> data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/signup_data.json');
    await file.writeAsString(jsonEncode(data), flush: true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User registered and data saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
            "Sign Up",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black
            )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) => value!.isEmpty ? 'Enter a username' : null,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.male),
                  label: const Text("Male"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gender == 'Male' ? Colors.blue.shade200 : Colors.grey.shade200,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => setState(() => gender = 'Male'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.female),
                  label: const Text("Female"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gender == 'Female' ? Colors.pink.shade200 : Colors.grey.shade200,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => setState(() => gender = 'Female'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Date of Birth"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dobDropdown(1, 31, selectedDay, (v) => setState(() => selectedDay = v!)),
                _dobDropdown(1, 12, selectedMonth, (v) => setState(() => selectedMonth = v!)),
                _dobDropdown(1980, 2024, selectedYear, (v) => setState(() => selectedYear = v!)),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value!.isEmpty) return 'Enter phone number';
                if (!RegExp(r'^\d{10,15}$').hasMatch(value)) return 'Invalid number';
                return null;
              },
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),

            //Password
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
            const SizedBox(height: 12),
            buildPasswordField(
              label: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              toggleVisibility: () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              },
              onChanged: (value) => password = value,
              validator: (value) {
                if (value != passwordController.text) return 'Passwords do not match';
                return null;
              },
              controller: confirmPasswordController,
            ),
            const SizedBox(height: 16),

            //Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(229,155,60, 1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final userData = {
                      'username': usernameController.text,
                      'gender': gender,
                      'dob': '${selectedDay.toString().padLeft(2, '0')}/'
                          '${selectedMonth.toString().padLeft(2, '0')}/'
                          '$selectedYear',
                      'phone': phoneController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                    };
                    saveToJson(userData);
                  }
                },
                child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),
            const SizedBox(height: 12),

            //Sign In Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage())
                    );
                  }, // TODO: Navigate to Sign In page
                  child: const Text("Sign In", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),

          ]),
        ),
      ),
    );
  }

  Widget _dobDropdown(int min, int max, int selected, ValueChanged<int?> onChanged) {
    return DropdownButton<int>(
      value: selected,
      items: [for (int i = min; i <= max; i++) DropdownMenuItem(value: i, child: Text(i.toString().padLeft(2, '0')))],
      onChanged: onChanged,
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
    validator: validator
    );
  }
}
