import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/registerU.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapPage({super.key, required this.latitude, required this.longitude});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController; // Google Map controller
  late LatLng selectedPosition; // Selected position
  String selectedAddress = ''; // Selected address

  @override
  void initState() {
    super.initState();
    selectedPosition = LatLng(widget.latitude, widget.longitude);
    _updateAddress(selectedPosition); // Fetch initial address
  }

  void _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          selectedAddress =
              '${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}'; // Update address
        });
      }
    } catch (e) {
      log('Error retrieving address: $e');
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      selectedPosition = position; // Update selected position
    });
    _updateAddress(position); // Convert coordinates to address
    log('Selected position: $position'); // Log the selected position
  }

 void _showAddressPopup() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 240,
        decoration: const BoxDecoration(
          color: Color(0xFF214FC6),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: const Text(
                  'ตรวจสอบที่อยู่จัดส่งคุณอีกครั้ง',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  selectedAddress.isNotEmpty
                      ? selectedAddress
                      : 'Tap on the map to select an address',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  log('Selected address: $selectedAddress');
                  Get.to(() => Registeru(address: selectedAddress)); // นำทางไปยัง Registeru และส่งที่อยู่
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 75.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'ยืนยันที่อยู่จัดส่ง',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถานที่รับสินค้า'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: selectedPosition,
                ),
              },
              onTap: _onMapTapped,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent),
            ),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ที่อยู่จัดส่ง',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  selectedAddress.isNotEmpty
                      ? selectedAddress
                      : 'Tap on the map to select an address',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _showAddressPopup, // Show popup on button press
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 75.0),
                      backgroundColor: Color(0xFF0C1C8D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'แสดงที่อยู่จัดส่ง',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
