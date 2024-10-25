import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:flutter_delivery_1/model/home_rider.dart';
import 'package:get/get.dart'; 

class Profiler extends StatefulWidget {
  const Profiler({super.key});

  @override
  _ProfilerState createState() => _ProfilerState();
}

class _ProfilerState extends State<Profiler> {
  int _selectedIndex = 0; // ใช้เพื่อเก็บค่าของเมนูที่เลือก

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เปลี่ยนค่าเมนูที่เลือก
    });
    switch (index) {
      case 0:
        Get.to(() => const HomeRider());
        break;
      case 1:
        Get.to(() => const Profiler());
        break;
      case 2:
        _logout();
        break;
    }
  }

  // ฟังก์ชันสำหรับออกจากระบบ
  void _logout() {
    // ลบข้อมูลที่เก็บไว้ (หากมี)
    // box.remove('userId'); // ลบ userId
    // box.remove('Name'); // ลบ Name
    // box.remove('userType'); // ลบ userType
    Get.to(() => const Login()); // นำไปที่หน้า Login
  }

  @override
  Widget build(BuildContext context) {
    final String userName = "John Doe"; 
    final String phoneNumber = "123-456-7890"; 
    final String email = "john.doe@example.com"; 
    final String vehicleRegistration = "ABC-1234"; 

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // จัดตำแหน่งไปด้านบน
          children: [
            Container(
              width: 113,
              height: 113,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey[200], 
                image: const DecorationImage(
                  image: AssetImage('asset/images/ProfileU.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16), 
            _buildInfoContainer(userName),
            const SizedBox(height: 16), 
            _buildInfoContainer(phoneNumber),
            const SizedBox(height: 16), 
            _buildInfoContainer(email),
            const SizedBox(height: 16), 
            _buildInfoContainer(vehicleRegistration), 
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  Widget _buildInfoContainer(String info) {
    return Container(
      width: double.infinity, // กำหนดให้กว้างสุด
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), 
        borderRadius: BorderRadius.circular(8), 
      ),
      child: Text(
        info,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black, 
        ), 
        textAlign: TextAlign.left, 
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF214FC6),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
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
    );
  }
}
