import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/confirm_map.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:flutter_delivery_1/model/profileR.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeRider extends StatefulWidget {
  const HomeRider({super.key});

  @override
  _HomeRiderState createState() => _HomeRiderState();
}

class _HomeRiderState extends State<HomeRider> {
  int _selectedIndex = 0; // ใช้เพื่อเก็บค่าของเมนูที่เลือก
  final box = GetStorage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เปลี่ยนค่าเมนูที่เลือก
    });

    // นำทางไปยังหน้าอื่นตามดัชนีที่เลือก
    switch (index) {
      case 0:
        // ถ้าคุณมีหน้าแรกสำหรับ Rider ให้เปลี่ยนไปที่หน้านั้น
        break;
      case 1:
        Get.to(() => const Profiler());
        break;
      case 2:
        // ถ้าคุณต้องการออกจากระบบ
        box.remove('userId'); // ลบ userId
        box.remove('Name'); // ลบ Name
        box.remove('userType'); // ลบ userType
        Get.to(() => const Login()); // นำไปที่หน้า Login
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = 'Rider ใหม่!';
    String senderName = 'ชื่อผู้ส่ง: John Doe'; // ชื่อผู้ส่ง
    String address = 'ที่อยู่: 123 ถนนตัวอย่าง, กรุงเทพฯ'; // ที่อยู่ของผู้ส่ง
    String phoneNumber =
        'หมายเลขโทรศัพท์: 012-3456789'; // หมายเลขโทรศัพท์ของผู้ส่ง

    String receiverName = 'ชื่อผู้รับ: Jane Doe'; // ชื่อผู้รับ
    String receiverAddress =
        'ที่อยู่: 456 ถนนตัวอย่าง, กรุงเทพฯ'; // ที่อยู่ของผู้รับ
    String receiverPhoneNumber =
        'หมายเลขโทรศัพท์: 098-7654321'; // หมายเลขโทรศัพท์ของผู้รับ

    // กำหนดระยะห่างระหว่างหมายเลขโทรศัพท์กับชื่อผู้รับ
    double spacingBetweenPhoneAndReceiverName = 40.0;

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
                top: 15,
                right: 10,
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
                top: 30,
                left: 10,
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
                          name, // ชื่อผู้ใช้งาน
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
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 10,
              bottom: 20,
            ),
            child: Align(
              alignment:
                  Alignment.centerLeft, // จัดตำแหน่งข้อความให้อยู่ด้านซ้าย
              child: Text(
                'Hello Rider',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            width: 356,
            height:
                242, // ปรับความสูงของ Container เพื่อให้พอสำหรับข้อมูลทั้งหมด
            decoration: BoxDecoration(
              color: const Color(0xFF0A2A5A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // จัดตำแหน่งให้อยู่ด้านบนซ้าย
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ข้อความ "ออเดอร์ ID"
                      Text(
                        'ออเดอร์ ID:',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // ปุ่ม "รอรับงาน"
                      GestureDetector(
                        onTap: () {
                          //  Get.to(DetailsPage());
                        },
                        child: Container(
                          width: 91,
                          height: 23,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEED92C),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(
                              'รอรับงาน',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    senderName, // แสดงชื่อผู้ส่ง
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    address, // แสดงที่อยู่ของผู้ส่ง
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    phoneNumber, // แสดงหมายเลขโทรศัพท์ของผู้ส่ง
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                      height:
                          spacingBetweenPhoneAndReceiverName), // กำหนดระยะห่างที่ต้องการ
                  Text(
                    receiverName, // แสดงชื่อผู้รับ
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    receiverAddress, // แสดงที่อยู่ของผู้รับ
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          receiverPhoneNumber, // แสดงหมายเลขโทรศัพท์ของผู้รับ
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white, // สีข้อความ
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //  Get.to(DetailsPage());
                        },
                        child: Container(
                          width: 95,
                          height: 23,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7FB2FF),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          alignment:
                              Alignment.center, // ใช้ alignment เพื่อจัดตำแหน่ง
                          child: const Text(
                            'รายละเอียดงาน',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
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
