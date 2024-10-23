import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapRealtime extends StatefulWidget {
  const MapRealtime({super.key});

  @override
  _MapRealtimeState createState() => _MapRealtimeState();
}

class _MapRealtimeState extends State<MapRealtime> {
  late GoogleMapController mapController;
  late LatLng selectedPosition =
      const LatLng(13.736717, 100.523186); // Default LatLng (Bangkok)
  String selectedAddress = '';
  int currentStatus = 1; // ใช้ติดตามสถานะการจัดส่งปัจจุบัน

  @override
  void initState() {
    super.initState();
    _updateAddress(selectedPosition); // ดึงข้อมูลที่อยู่เริ่มต้น
  }

  // ดึงข้อมูลที่อยู่จากพิกัด
  void _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          selectedAddress =
              '${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
        });
      }
    } catch (e) {
      log('Error retrieving address: $e');
    }
  }

  // อัปเดตตำแหน่งเมื่อมีการคลิกบนแผนที่
  void _onMapTapped(LatLng position) {
    setState(() {
      selectedPosition = position;
    });
    _updateAddress(position);
  }

  void _showStatusPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // เพิ่ม SingleChildScrollView
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 320,
            decoration: const BoxDecoration(
              color: Color(0xFF214FC6),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'สถานะสินค้าที่กำลังถูกส่ง',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // ปรับขนาดฟอนต์ให้เล็กลง
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStep('1', 'รอไรเดอร์รับสินค้า', currentStatus >= 1),
                    _buildStep('2', 'ไรเดอร์รับของ', currentStatus >= 2),
                    _buildStep('3', 'รับสินค้าและกำลังเดินทาง', currentStatus >= 3),
                    _buildStep('4', 'จัดส่งสินค้าแล้ว', currentStatus >= 4),
                  ],
                ),
                const SizedBox(height: 70.0),
                // const Divider(color: Colors.white70),
                // const SizedBox(height: 30.0),
                const Text(
                  'ข้อมูลไรเดอร์',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, // ปรับขนาดฟอนต์ให้เล็กลง
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.grey, size: 30),
                    ),
                    const SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ชื่อ: สมชาย ขับส่ง',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12), 
                        ),
                        Text(
                          'หมายเลขโทรศัพท์: 0471578934',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12),
                        ),
                        Text(
                          'ทะเบียนรถ: รธร 1289',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12), 
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ฟังก์ชันสร้างสเต็ปสำหรับการแสดงสถานะ
  Widget _buildStep(String step, String title, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? Colors.white : Colors.transparent,
          child: Text(
            step,
            style: TextStyle(
              color: isActive ? Color(0xFF214FC6) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10, 
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 10, 
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Realtime'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปยังหน้าก่อนหน้าเมื่อกด
          },
        ),
      ),
      body: Column(
        children: [
          // วิดเจ็ตแผนที่ขยายเต็ม
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedPosition,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: selectedPosition,
                ),
              },
              onTap: _onMapTapped, // ทำงานเมื่อกดบนแผนที่
            ),
          ),
          // ปุ่มแสดงสถานะในป็อปอัป
          Center(
            child: ElevatedButton(
              onPressed: _showStatusPopup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 75.0),
                backgroundColor: const Color(0xFF0C1C8D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'แสดงสถานะการจัดส่ง',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
