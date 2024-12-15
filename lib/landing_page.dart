import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Center(
              
              
                child: Center(
                 
                    
                    child: Center(
                      child: Image.asset(
                        'assets/Logo.png', 
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  
                ),
              
            ),
            const SizedBox(height: 50),
            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9575),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'SIGN UP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // Login Button
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF9575), width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}