import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/registerU.dart';
import 'package:get/get.dart'; // นำเข้า Get

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Center(
              child: Image.asset(
                'asset/images/logo.png',
                width: 149,
                height: 155,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: const Text(
                'Delivery Application',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0C1C8D),
                    fontFamily: 'Aleo'),
              ),
            ),
            const SizedBox(height: 30),
            
            // ช่องกรอกอีเมล
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // ช่องกรอกรหัสผ่าน
            TextFormField(
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่ม Sign In
            ElevatedButton(
              onPressed: () {
                // การทำงานเมื่อกดปุ่ม Sign In
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1C8D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 40),

            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Or sign in with'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // เข้าสู่ระบบด้วย Google
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Image.asset(
                      'asset/images/google.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // เข้าสู่ระบบด้วย Facebook
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Image.asset(
                      'asset/images/facebook.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),

            // ลิงก์ไปยังหน้าสมัครสมาชิก
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Get.to(const Registeru()); // นำทางไปยังหน้าสมัครสมาชิก
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF0C1C8D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}