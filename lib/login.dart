import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                'asset/images/logo.png', // ใส่โลโก้ของคุณใน path นี้
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
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ช่องกรอกรหัสผ่าน
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่ม Sign In
            ElevatedButton(
              onPressed: () {
                // กำหนดการทำงานเมื่อกดปุ่ม Sign In
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1C8D), // สีพื้นหลังของปุ่ม
                foregroundColor: Colors.white, // สีตัวหนังสือของปุ่ม
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text('Sign In'),
            ),

            const SizedBox(height: 40),

            // ตัวหนังสือ "Or sign in with"
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

            // ปุ่ม Google และ Facebook
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
                    // นำทางไปยังหน้าสมัคร
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

