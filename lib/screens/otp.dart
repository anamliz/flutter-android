import 'package:flutter/material.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController _otpController = TextEditingController();
  
  void _login() {
    // Implement authentication logic here
    String otp = _otpController.text;
    
    // Example: Print OTP
    print('otp: $otp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ),
      
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: OTP(),
  ));
}
