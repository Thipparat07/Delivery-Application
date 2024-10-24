import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/SearchReceiver.dart';
import 'package:flutter_delivery_1/config/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_delivery_1/model/ProductsDataGetResponse.dart';
import 'package:flutter_delivery_1/login.dart';


// คอนโทรลเลอร์สำหรับจัดการรายการสินค้า
class ProductController extends GetxController {
var products = <ProductsDataGetResponse>[].obs; // รายการสินค้าที่เป็น Observable
  var isLoading = true.obs; // สถานะการโหลดที่เป็น Observable
  var selectedProducts = <ProductsDataGetResponse>[].obs; // รายการสินค้าที่เลือกเป็น Observable
  String url = '';

  @override
  void onInit() async { // เปลี่ยนเป็น async
    super.onInit();
    try {
      final config = await Configuration.getConfig();
      url = config['apiEndpoint'];
      log('API Endpoint: $url'); // บันทึก endpoint สำหรับการตรวจสอบ
      fetchProducts(); // ดึงข้อมูลสินค้าหลังจากตั้งค่า URL เสร็จ
    } catch (e) {
      log('Error loading configuration: $e');
      Get.snackbar('Error', 'ไม่สามารถโหลดการกำหนดค่าได้');
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลสินค้าจาก API
  Future<void> fetchProducts() async {
    isLoading.value = true; // เริ่มการโหลด
    try {
      log('Fetching products from: $url/api/products');
      final response = await http
          .get(Uri.parse('$url/api/products'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        products.value = data
            .map((productJson) => ProductsDataGetResponse.fromJson(productJson))
            .toList();
      } else if (response.statusCode >= 500) {
        Get.snackbar('Server Error', 'ไม่สามารถดึงข้อมูลได้ โปรดลองใหม่อีกครั้ง');
      } else if (response.statusCode >= 400) {
        Get.snackbar('Error', 'ไม่สามารถดึงข้อมูลสินค้าได้ กรุณาตรวจสอบข้อมูล');
      }
    } catch (error) {
      log('เกิดข้อผิดพลาด: $error');
      Get.snackbar('Error', 'เกิดข้อผิดพลาดบางอย่าง');
    } finally {
      isLoading.value = false; // หยุดการโหลด
    }
  }

  // ฟังก์ชันสลับสถานะการเลือกสินค้าตัวหนึ่ง
  void toggleSelection(ProductsDataGetResponse product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    selectedProducts
        .refresh(); // แจ้งให้ UI อัพเดตเมื่อสถานะการเลือกเปลี่ยนแปลง
  }

  // ฟังก์ชันตรวจสอบว่าสินค้าตัวนี้ถูกเลือกหรือไม่
  bool isSelected(ProductsDataGetResponse product) {
    return selectedProducts.contains(product);
  }
}

// UI สำหรับแสดงรายการสินค้า
class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController productController = Get.put(ProductController());
  int _selectedIndex = 0; // ดัชนีที่เลือกในแถบเมนู

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.to(() => ());
        break;
      case 1:
        Get.to(() => ());
        break;
      case 2:
        Get.to(() => ());
        break;
      case 3:
        Get.to(() => Login());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
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
                      const Text(
                        'Phuri Ngomsaraku', // ชื่อผู้ใช้
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      log('เพิ่มสินค้าที่ต้องจัดส่ง');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: Size(0, 35),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'เพิ่มสินค้าที่ต้องจัดส่ง',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      // final selected = productController.selectedProducts;
                      // log('สินค้าที่เลือก: ${selected.map((p) => p.name).join(', ')}');
                      // log('ID สินค้าที่เลือก: ${selected.map((p) => p.productsId).join(', ')}');
                      // Get.snackbar('ยืนยันการจัดส่ง',
                      //     'สินค้าที่เลือกถูกยืนยันเรียบร้อยแล้ว');
                                    final selected = productController.selectedProducts;
              if (selected.isNotEmpty) {
                // Send only the IDs to SearchReceiverPage
                final selectedIds =
                    selected.map((product) => product.productsId).toList();
                Get.to(() => SearchReceiverPage(), arguments: selectedIds);
              } else {
                Get.snackbar('Error', 'กรุณาเลือกสินค้าก่อน');
              }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: Size(0, 35),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'ยืนยันการจัดส่ง',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รายการสินค้า',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Obx(() {
                          return Row(
                            children: [
                              Checkbox(
                                value:
                                    productController.selectedProducts.length ==
                                        productController.products.length,
                                onChanged: (value) {
                                  if (value == true) {
                                    productController.selectedProducts
                                        .assignAll(productController.products);
                                  } else {
                                    productController.selectedProducts.clear();
                                  }
                                },
                              ),
                              const Text(
                                'เลือกทั้งหมด',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productController.products.length,
                      itemBuilder: (context, index) {
                        final product = productController.products[index];
                        return Card(
                          color: const Color(0xFF7FB2FF),
                          elevation: 4,
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value:
                                        productController.isSelected(product),
                                    onChanged: (value) {
                                      productController
                                          .toggleSelection(product);
                                    },
                                  ),
                                ),
                                buildProductImage(product.imageUrl),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'ชื่อสินค้า:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'รายละเอียด:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              product.description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF214FC6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  // ฟังก์ชันสร้าง Widget สำหรับแสดงภาพสินค้า
  Widget buildProductImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}