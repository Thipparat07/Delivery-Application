import 'package:flutter/material.dart';

class Registeru extends StatelessWidget {
  const Registeru({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'asset/images/icon_back.png',
            width: 25,
            height: 29.32,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // title: const Text('ชื่อหน้าจอ'),
        // backgroundColor: Colors.blue,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // จัดตำแหน่งให้ตรงกลางแนวตั้ง
              children: <Widget>[
                Image.asset(
                  'asset/images/logo.png',
                  width: 81, // ขนาดโลโก้ที่ต้องการ
                  height: 71, // ขนาดโลโก้ที่ต้องการ
                ),
                Transform.translate(
                  offset: const Offset(0, -15), // ปรับตำแหน่งข้อความตามต้องการ
                  child: const Text(
                    'Delivery Application',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0C1C8D),
                      fontFamily: 'Aleo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        toolbarHeight: 92, // ปรับขนาดความสูงของ AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // เพิ่มไอคอนและข้อความที่นี่
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset(
                    'asset/images/photo_icon.png', // เปลี่ยนเป็น path ของไอคอนที่ต้องการ
                    width: 40,
                    height: 40,
                  ),
                  onPressed: () {
                    // ฟังก์ชันที่ใช้สำหรับเพิ่มข้อมูล
                  },
                ),
                Transform.translate(
                  offset: const Offset(0, -13), // ปรับตำแหน่งข้อความให้เหมาะสม
                  child: const Text(
                    'Add Profile Photo', // ข้อความที่ต้องการแสดง
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // เว้นระยะห่างระหว่างไอคอนและฟอร์ม
            Expanded(
              child: Form(
                // key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกชื่อ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกที่อยู่';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double
                          .infinity, // ให้ปุ่มกว้างเต็มความกว้างของ parent
                      child: ElevatedButton(
                        onPressed: () {
                          // ฟังก์ชันที่ใช้สำหรับเปลี่ยนหน้า
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF0C1C8D), // สีพื้นหลังของปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // กำหนดความโค้งของมุม
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 16), // เพิ่ม padding สำหรับปุ่ม
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'asset/images/Gps.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'GPS Coordinates',
                              style: TextStyle(
                                color: Colors.grey, // สีตัวอักษรของปุ่ม
                                fontSize: 16, // ขนาดตัวอักษร
                                fontWeight: FontWeight.bold, // หนักของตัวอักษร
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเบอร์โทรศัพท์';
                        }
                        // ตรวจสอบความยาวของเบอร์โทรศัพท์
                        if (value.length < 10) {
                          return 'เบอร์โทรศัพท์ต้องมีอย่างน้อย 10 หลัก';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        // ใช้ Regular Expression สำหรับตรวจสอบรูปแบบอีเมล
                        final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณายืนยันรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState?.validate() ?? false) {
                        //   // ฟังก์ชันการสมัครสมาชิกเมื่อข้อมูลถูกต้อง
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')),
                        //   );
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF0C1C8D), // สีพื้นหลังของปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // กำหนดความโค้งของมุม
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // เพิ่ม padding สำหรับปุ่ม
                        textStyle: const TextStyle(
                          fontSize: 20, // ขนาดฟอนต์
                          fontWeight: FontWeight.bold, // หนักของตัวอักษร
                          color: Colors.grey, // สีตัวอักษร
                        ),
                      ),
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
