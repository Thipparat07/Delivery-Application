import 'dart:developer';
import 'dart:io'; // For File usage
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_delivery_1/config/config.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:flutter_delivery_1/map_page.dart';
import 'package:get/get.dart'; // Import Get
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:geocoding/geocoding.dart'; // Import Geocoding
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON access
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import MediaType from http_parser

class Registeru extends StatefulWidget {
  final double? latitude; // Change to double?
  final double? longitude; // Change to double?

  const Registeru({Key? key, this.latitude, this.longitude}) : super(key: key);

  @override
  _RegisteruState createState() => _RegisteruState();
}

class _RegisteruState extends State<Registeru> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _manualAddressController = TextEditingController();

  String _address = 'กำลังดึงที่อยู่...';
  bool _isLoading = false;
  String? _email;
  String? _name;
  String? _password;
  String? _phoneNumber;
  Uint8List? _imageBytes;
  String url = '';
  String? _manualAddress;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
    _convertLatLngToAddress();


    _addressController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    TextEditingController();
    _manualAddressController = TextEditingController();

    @override
    void dispose() {
      _addressController.dispose();
      _nameController.dispose();
      _emailController.dispose();
      _phoneController.dispose();
      _passwordController.dispose();
      _confirmPasswordController.dispose();
      _manualAddressController.dispose();
      super.dispose();
    }

//     @override
// void initState() {
//   super.initState();
//   // ตั้งค่าเริ่มต้นให้กับ TextEditingController
//   _nameController.text = _name!; // หรือค่าที่เคยเก็บไว้
//   _emailController.text = _email!; // หรือค่าที่เคยเก็บไว้
//   _phoneController.text = _phoneNumber!; // หรือค่าที่เคยเก็บไว้
//   _passwordController.text = _password!; // ไม่ควรแสดงรหัสผ่าน
//   _confirmPasswordController.text = _passwordController; // ไม่ควรแสดงรหัสผ่าน
//   _manualAddressController.text = _manualAddress; // หรือค่าที่เคยเก็บไว้
// }

    // Add listeners to update state variables when text changes

    // _nameController.addListener(() {
    //   log(_nameController.text);
    //   setState(() => _name = _nameController.text);
    // });
    // _emailController.addListener(() {
    //   setState(() => _email = _emailController.text);
    // });
    // _phoneController.addListener(() {
    //   setState(() => _phoneNumber = _phoneController.text);
    // });
    // _passwordController.addListener(() {
    //   setState(() => _password = _passwordController.text);
    // });
    // _manualAddressController.addListener(() {
    //   setState(() => _manualAddress = _manualAddressController.text);
    // });
    _loadUserData;
  }

  Future<Map<String, String>> get _loadUserData async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('name') ?? '',
    'email': prefs.getString('email') ?? '',
    'phoneNumber': prefs.getString('phoneNumber') ?? '',
    'manualAddress': prefs.getString('manualAddress') ?? '',
  };
}

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Pick image from gallery

    if (pickedFile != null) {
      final imageBytes =
          await pickedFile.readAsBytes(); // Read the file as bytes
      setState(() {
        _image = File(pickedFile.path); // Store the file for display
        _imageBytes = imageBytes; // Store the image bytes for sending to API
      });
    }
  }

  //แปลงที่อยู่เป็นAddress
  Future<void> _convertLatLngToAddress() async {
    if (widget.latitude != null && widget.longitude != null) {
      try {
        // ดึงที่อยู่จากละติจูดและลองจิจูด
        List<Placemark> placemarks =
            await placemarkFromCoordinates(widget.latitude!, widget.longitude!);
        Placemark place = placemarks[0];

        // สร้างสตริงที่อยู่
        String fetchedAddress =
            '${place.street}, ${place.locality}, ${place.country}';

        // อัปเดตที่อยู่ในคอนโทรลเลอร์
        setState(() {
          _address = fetchedAddress; // อัปเดตสถานะภายใน
          _addressController.text = fetchedAddress; // อัปเดตคอนโทรลเลอร์
        });
      } catch (e) {
        setState(() {
          _address = 'ไม่สามารถดึงที่อยู่ได้';
          _addressController.text =
              'ไม่สามารถดึงที่อยู่ได้'; // อัปเดตคอนโทรลเลอร์เมื่อเกิดข้อผิดพลาด
        });
      }
    } else {
      setState(() {
        _address = '';
        _addressController.text = ''; // อัปเดตคอนโทรลเลอร์
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // GPS not enabled
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null; // Permission denied
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // Get current position
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _address =
              '${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}'; // Update address
        });
      }
    } catch (e) {
      log('Error retrieving address: $e');
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // แสดงสถานะการโหลด
      });

      // เตรียมคำขอ
      final uri = Uri.parse('$url/register/users'); // อัปเดตเป็น URL API ของคุณ
      final request = http.MultipartRequest('POST', uri);

      // เพิ่มฟิลด์ข้อความ
      request.fields['Name'] = _name ?? ''; // สมมติว่าคุณมีตัวแปร _name
      request.fields['email'] = _email ?? ''; // อีเมล
      request.fields['address'] =
          _manualAddress ?? ''; // ที่อยู่ (ที่กรอกด้วยตนเองหรือที่ดึงมา)
      request.fields['gpsLocation'] =
          '${widget.latitude},${widget.longitude}'; // ตำแหน่ง GPS เป็นสตริง

      request.fields['password'] = _password ?? ''; // รหัสผ่าน
      request.fields['phoneNumber'] = _phoneNumber ?? ''; // หมายเลขโทรศัพท์

      // เพิ่มไฟล์ภาพถ้าถูกเลือก
      if (_imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'profilePicture', // คีย์สำหรับไฟล์ภาพ
          _imageBytes!, // ไบต์ของภาพ
          filename: _image!.path.split('/').last, // ชื่อไฟล์เดิม
          contentType:
              MediaType('image', 'jpeg'), // ตั้งค่าประเภทเนื้อหาสำหรับภาพ
        ));
      }

      try {
        final response = await request.send(); // ส่งคำขอ

        // จัดการกับการตอบกลับ
        if (response.statusCode == 201) {
          // ตรวจสอบว่าการลงทะเบียนสำเร็จหรือไม่
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("ลงทะเบียนสำเร็จ")),
          );
          Get.to(() => Login());
        } else {
          final responseData =
              await response.stream.bytesToString(); // รับข้อมูลการตอบกลับ
          log(responseData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("เกิดข้อผิดพลาด: $responseData")),
          );
        }
      } catch (e) {
        // จัดการข้อยกเว้น
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์")),
        );
      } finally {
        setState(() {
          _isLoading = false; // ซ่อนสถานะการโหลด
        });
      }
    }
  }

  // Update TextFormField widgets in build method
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อ';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty || !GetUtils.isEmail(value)) {
          return 'กรุณากรอกอีเมลที่ถูกต้อง';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: const OutlineInputBorder(),
        counterText: '',
      ),
      keyboardType: TextInputType.phone,
      maxLength: 10,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกหมายเลขโทรศัพท์';
        }
        if (value.length != 10) {
          return 'หมายเลขโทรศัพท์ต้องมี 10 หลัก';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
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
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isConfirmPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรหัสผ่านอีกครั้ง';
        } else if (value != _passwordController.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }

  Widget _buildManualAddressField() {
    return TextFormField(
      controller: _manualAddressController,
      decoration: const InputDecoration(
        labelText: 'Address',
        border: OutlineInputBorder(),
      ),
      maxLength: 100,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกที่อยู่';
        }
        if (value.contains(' ')) {
          return 'ห้ามมีช่องว่าง';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }



@override
Widget build(BuildContext context) {
  return FutureBuilder<Map<String, String>>(
    future: _loadUserData,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // แสดง loading indicator ขณะที่รอข้อมูล
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        _nameController.text = snapshot.data?['name'] ?? '';
        _emailController.text = snapshot.data?['email'] ?? '';
        _phoneController.text = snapshot.data?['phoneNumber'] ?? '';
        _manualAddressController.text = snapshot.data?['address'] ?? '';
        return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'asset/images/icon_back.png',
            width: 25,
            height: 29.32,
          ),
          onPressed: () => Get.back(),
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
                  onTap: _pickImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Image.asset(
                                'asset/images/photo_icon.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                    ),
                  ),
                ),
                if (_image == null)
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
                key: _formKey,
                child: ListView(
                  children: [
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 16),
                    _buildManualAddressField(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          Position? currentPosition =
                              await _getCurrentLocation();

                          Navigator.of(context).pop();

                          if (currentPosition != null) {
                            final LatLng? selectedPosition = await Get.to(
                              () => MapPage(
                                latitude: currentPosition.latitude,
                                longitude: currentPosition.longitude,
                              ),
                            );

                            if (selectedPosition != null) {
                              await _getAddressFromLatLng(selectedPosition);
                              log('Address: $_address');
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("ไม่สามารถดึงตำแหน่งปัจจุบันได้"),
                              ),
                            );
                          }
                        },
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
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'GPS Coordinates',
                              style: TextStyle(
                                color: Colors.white,
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
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Pick up location',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      readOnly: true,
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
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C1C8D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
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
    },
  );
}}

