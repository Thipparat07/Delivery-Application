import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/SearchReceiver.dart';
import 'package:flutter_delivery_1/addProduct.dart';
import 'package:flutter_delivery_1/config/config.dart';
import 'package:flutter_delivery_1/model/ProductsDataGetResponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// คอนโทรลเลอร์สำหรับจัดการรายการสินค้า
class ProductController extends GetxController {
  var products =
      <ProductsDataGetResponse>[].obs; // รายการสินค้าที่เป็น Observable
  var isLoading = true.obs; // สถานะการโหลดที่เป็น Observable
  var selectedProducts =
      <ProductsDataGetResponse>[].obs; // รายการสินค้าที่เลือกเป็น Observable
  String url = '';

  @override
  void onInit() {
    super.onInit();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
    fetchProducts(); // ดึงข้อมูลสินค้าตอนที่คอนโทรลเลอร์ถูกสร้างขึ้น
  }

  // ฟังก์ชันสำหรับดึงข้อมูลสินค้าจาก API
  Future<void> fetchProducts() async {
    try {
      log(url);
      final response = await http.get(Uri.parse(
          'https://api-delivery-application.vercel.app/api/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        products.value = data
            .map((productJson) => ProductsDataGetResponse.fromJson(productJson))
            .toList();
      } else if (response.statusCode >= 500) {
        Get.snackbar(
            'Server Error', 'ไม่สามารถดึงข้อมูลได้ โปรดลองใหม่อีกครั้ง');
      } else if (response.statusCode >= 400) {
        Get.snackbar('Error', 'ไม่สามารถดึงข้อมูลสินค้าได้ กรุณาตรวจสอบข้อมูล');
      }
    } catch (error) {
      print('เกิดข้อผิดพลาด: $error');
      Get.snackbar('Error', 'เกิดข้อผิดพลาดบางอย่าง');
    } finally {
      isLoading.value = false; // หยุดโหลดเมื่อดึงข้อมูลเสร็จสิ้น
    }
  }

  // ฟังก์ชันสลับสถานะการเลือกสินค้าตัวหนึ่ง
  void toggleSelection(ProductsDataGetResponse product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    // แจ้งให้ UI อัพเดตเมื่อสถานะการเลือกเปลี่ยนแปลง
    selectedProducts.refresh();
  }

  // ฟังก์ชันตรวจสอบว่าสินค้าตัวนี้ถูกเลือกหรือไม่
  bool isSelected(ProductsDataGetResponse product) {
    return selectedProducts.contains(product);
  }
}

// UI สำหรับแสดงรายการสินค้า
class ProductListPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสินค้า'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
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
          ),
          ElevatedButton(
            // กดปุ่มเพื่อเพิ่มสินค้า
            onPressed: () {
              Get.to(() => AddProductPage());
            },
            child: Text('เพิ่มสินค้า'),
          ),
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];
            final isSelected = productController
                .isSelected(product); // ตรวจสอบว่าสินค้าถูกเลือกหรือไม่

            return Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // ภาพสินค้า
                    buildProductImage(product.imageUrl),
                    SizedBox(width: 8), // เพิ่มระยะห่างระหว่างรูปกับข้อความ

                    // รายละเอียดสินค้า
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name),
                          Text(product.description),
                        ],
                      ),
                    ),

                    // กล่องเช็คสำหรับการเลือก
                    Obx(() => Checkbox(
                          value: productController.isSelected(
                              product), // ตั้งค่าสถานะกล่องเช็คตามการเลือกสินค้า
                          onChanged: (value) {
                            productController.toggleSelection(
                                product); // สลับสถานะการเลือกสินค้า
                          },
                        )),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildProductImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // เพิ่ม log เพื่อดู error
        print('Error loading image: $error');
        return Container(
          width: 50,
          height: 50,
          color: Colors.grey[200],
          child: Icon(
            Icons.broken_image,
            color: Colors.grey[400],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 50,
          height: 50,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }
}

// UI สำหรับแสดงรายละเอียดสินค้า
class ProductDetailPage extends StatelessWidget {
  final ProductsDataGetResponse product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(product.name),
        ),
        body: Container(
          height: 200, // หรือขนาดที่ต้องการ
          child: Image.network(
            product.imageUrl,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading detail image: $error');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 50),
                    SizedBox(height: 8),
                    Text('ไม่สามารถโหลดรูปภาพได้'),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ));
  }
}
