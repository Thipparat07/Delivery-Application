import 'package:flutter/material.dart';
import 'package:get/get.dart'; // นำเข้า Get
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // สำหรับการใช้งาน File

class Registeru extends StatefulWidget {
  const Registeru({super.key});

  @override
  _RegisteruState createState() => _RegisteruState();
}

class _RegisteruState extends State<Registeru> {
  File? _image; // ตัวแปรเก็บรูปภาพที่เลือก
  final _formKey = GlobalKey<FormState>(); // กุญแจสำหรับฟอร์ม
  bool _isPasswordVisible = false; // สถานะของการแสดงรหัสผ่าน
  bool _isConfirmPasswordVisible = false; // สถานะของการแสดงยืนยันรหัสผ่าน

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // เลือกรูปจากแกลเลอรี่

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // เก็บ path ของภาพที่เลือก
      });
    }
  }

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
            Get.back(); // ใช้ Get เพื่อกลับไปยังหน้าก่อนหน้า
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'asset/images/logo.png',
                  width: 81,
                  height: 71,
                ),
                Transform.translate(
                  offset: const Offset(0, -15),
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
        toolbarHeight: 92,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:
                      _pickImage, // เมื่อกดที่ไอคอนจะเรียกฟังก์ชัน _pickImage
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // ขอบมน
                    child: Container(
                      width: 100, // กำหนดขนาดตามต้องการ
                      height: 100,
                      color: Colors.grey[200], // สีพื้นหลังถ้าไม่มีรูป
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Image.asset(
                                'asset/images/photo_icon.png', // ไอคอนที่จะแสดงถ้าไม่ได้เลือกรูป
                                width: 40,
                                height: 40,
                              ),
                            ),
                    ),
                  ),
                ),
                if (_image == null) // แสดงข้อความเฉพาะเมื่อยังไม่มีรูปที่เลือก
                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: const Text(
                      'Add Profile Photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Form(
                key: _formKey, // กำหนดกุญแจให้กับฟอร์ม
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
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C1C8D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
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
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกยืนยันรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // ทำสิ่งที่ต้องการเมื่อฟอร์มถูกต้อง
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C1C8D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
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
