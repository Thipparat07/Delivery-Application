import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/confirm_map.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // ใช้เพื่อเก็บค่าของเมนูที่เลือก
  final box = GetStorage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เปลี่ยนค่าเมนูที่เลือก
    });

    // นำทางไปยังหน้าอื่นตามดัชนีที่เลือก
    switch (index) {
      case 0:
        Get.to(() => ()); // หน้าแรก
        break;
      case 1:
        Get.to(() => ()); // หน้าโปรไฟล์
        break;
      case 2:
        Get.to(() => ()); // หน้าสถานะการจัดส่ง
        break;
      case 3:
        final box = GetStorage();
        box.remove('userId'); // ลบ userId
        box.remove('Name'); // ลบ userId
        box.remove('userType'); // ลบ userId
        Get.to(() => const Login()); // หน้าสถานะการจัดส่ง
        break;
    }
  }

  Widget _bottomNavItem(IconData icon, String label, int index) {
    return Expanded(
      // ใช้ Expanded เพื่อให้แบ่งพื้นที่เท่า ๆ กัน
      child: FittedBox(
        fit: BoxFit.scaleDown, // บีบเนื้อหาด้านในให้เหมาะสมกับพื้นที่
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                icon,
                color: Colors.white,
                size: 24, // ขนาดไอคอนปกติ
              ),
              onPressed: () => _onItemTapped(index),
              padding: const EdgeInsets.all(0), // ลด padding ของปุ่ม
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12, // ขนาดข้อความปกติ
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String Name = 'ภูริ';
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'asset/images/cover.jpg',
                width: double.infinity, // ปรับขนาดภาพให้เต็มความกว้าง
                height: 280,
                fit: BoxFit.cover, // ปรับภาพให้เต็มพื้นที่
              ),
              Positioned(
                top: 15, // ระยะจากด้านบนของหน้าจอ
                right: 10, // ระยะจากขอบขวาของหน้าจอ
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // จัดเรียงเนื้อหาทางด้านขวา
                  children: [
                    Image.asset(
                      'asset/images/logo.png',
                      width: 91,
                      height: 81,
                    ),
                    const Text(
                      'Delivery Application',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2A5A),
                        fontFamily: 'Aleo',
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30, // ระยะจากด้านบนของหน้าจอ
                left: 10, // ระยะจากขอบซ้ายของหน้าจอ
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // จัดเรียงเนื้อหาทางด้านซ้าย
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // จัดให้อยู่ทางซ้าย
                      children: [
                        const Text(
                          'สวัสดี',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          Name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Center(
                child: Container(
                  width: 350, // ปรับความกว้างของปุ่มตามที่ต้องการ
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() =>
                          ConfirmMap(latitude: 13.7563, longitude: 100.5018));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF214FC6),
                      minimumSize: const Size(200, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ตำแหน่งปัจจุบัน',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25), // เว้นระยะห่างระหว่างปุ่ม
              ElevatedButton.icon(
                onPressed: () {
                  // ฟังก์ชันเมื่อกดปุ่ม "สั่งซื้อสินค้า"
                },
                icon: const Icon(Icons.add_box, color: Colors.white),
                label: const Text(
                  'สั่งซื้อสินค้า',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF214FC6),
                  minimumSize: const Size(200, 75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF214FC6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _selectedIndex, // เก็บสถานะเมนูที่ถูกเลือก
        onTap: _onItemTapped, // เรียกใช้ฟังก์ชันเมื่อเลือกเมนู
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'สถานะการจัดส่ง',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'ออกจากระบบ',
          ),
        ],
      ),
    );
  }
}
