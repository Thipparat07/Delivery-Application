import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/home_page.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:flutter_delivery_1/profileU.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({super.key});

  @override
  _CheckStatusState createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  int _selectedIndex = 2;
  final box = GetStorage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => HomePage()); // หน้าแรก
        break;
      case 1:
        Get.to(() => Profileu()); // หน้าโปรไฟล์
        break;
      case 2:
        Get.to(() => CheckStatus()); // หน้าสถานะการจัดส่ง
        break;
      case 3:
        _logout();
        // box.remove('userId'); // ลบ userId
        // box.remove('Name'); // ลบ userId
        // box.remove('userType'); // ลบ userId
        // Get.to(() => const Login()); // หน้าสถานะการจัดส่ง
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = 'Phuri Ngomsaraku';
    final String riderName = 'ชื่อไรเดอร์';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'asset/images/cover.jpg',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 5,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                  top: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'สวัสดี',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'ตรวจสอบสถานะการจัดส่ง',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0A2A5A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF7FB2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 90,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('asset/images/cover.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Text(
                              'ชื่อสินค้า',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'รายละเอียด:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: AssetImage('asset/images/cover.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                riderName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 123,
                      height: 29,
                      child: ElevatedButton(
                        onPressed: () {
                          // Get.to(() => const MapRealtime());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'ตรวจสอบสถานะ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30), // เพิ่มระยะห่าง
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF214FC6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'สถานะการจัดส่ง',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _showLogoutDialog(context); // เรียกใช้ฟังก์ชันแสดงป็อปอัป
              },
            ),
            label: 'ออกจากระบบ',
          ),
        ],
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ยืนยันการออกจากระบบ'),
        content: Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: <Widget>[
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () {
              Navigator.of(context).pop(); // ปิดป็อปอัปโดยไม่ทำอะไร
            },
          ),
          TextButton(
            child: Text('ตกลง'),
            onPressed: () {
              // ทำการออกจากระบบที่นี่
              Navigator.of(context).pop(); // ปิดป็อปอัป
              _logout(); // เรียกฟังก์ชันออกจากระบบ
            },
          ),
        ],
      );
    },
  );
}

void _logout() {
  // ฟังก์ชันออกจากระบบ
  // ลบข้อมูลหรือเคลียร์ session, แล้วเปลี่ยนไปยังหน้า login
  GetStorage().erase(); // ลบข้อมูลจาก GetStorage
  Get.offAll(() => Login());
}
