import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/Product.dart';
import 'package:flutter_delivery_1/config/config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _productDescription = '';
  File? _image; // สำหรับรูปที่เลือกหรือถ่าย

  final ImagePicker _picker = ImagePicker();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  bool _isLoading = false; // Loading state

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/add/products'), // Change to your API URL
      );

      request.fields['name'] = _productName;
      request.fields['description'] = _productDescription;

      // Add image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image', // API expects this field name
        _image!.path,
        contentType: MediaType('image', 'jpeg'), // Adjust based on file type
      ));

      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          final responseData = await response.stream.toBytes();
          final responseString =
              utf8.decode(responseData); // Convert received data to string

          log('เพิ่มสินค้าเรียบร้อยแล้ว: $responseString');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เพิ่มสินค้าเรียบร้อยแล้ว')),
            );
            Get.back(result: true); // ส่งผลลัพธ์กลับไปหน้า ProductListPage
        } else {
          log('เกิดข้อผิดพลาดในการเพิ่มสินค้า: ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาดในการเพิ่มสินค้า')),
          );
        }
      } catch (e) {
        log('ข้อผิดพลาดในการเชื่อมต่อ: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ข้อผิดพลาดในการเชื่อมต่อ')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } else {
      if (_image == null) {
        log('กรุณาเลือกรูปภาพ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณาเลือกรูปภาพ')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'เลือกวิธีการอัปโหลดรูปภาพ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Color(0xFF7FB2FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                  child: Text(
                    'ถ่ายรูป',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                  child: Text(
                    'เลือกรูปภาพจากแกลเลอรี',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มข้อมูลสินค้า',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF0A2A5A),
        leading: IconButton(
          icon: Image.asset(
            'asset/images/icon_back.png',
            width: 25,
            height: 29.32,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 65),
              GestureDetector(
                onTap: _showImageSourceDialog, // เรียกฟังก์ชันเมื่อกดที่กล่อง
                child: Container(
                  width: 106,
                  height: 102,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 106,
                            height: 102,
                          )
                        : Center(
                            child: Text('เพิ่มรูปภาพ'),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 60), // ปรับระยะห่างระหว่างช่องแสดงรูปภาพและปุ่ม
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ชื่อสินค้า',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อสินค้า';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'รายละเอียดสินค้า',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรายละเอียดสินค้า';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productDescription = value;
                  });
                },
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double
                    .infinity, // ปรับให้ปุ่มมีความกว้างเท่ากับขนาดของหน้าจอ
                child: ElevatedButton(
                  onPressed: _addProduct,
                  child: Text('เพิ่มสินค้า'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Color(0xFF0A2A5A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
