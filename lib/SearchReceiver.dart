import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/config/config.dart';
import 'package:flutter_delivery_1/home_page.dart';
import 'package:flutter_delivery_1/model/SearchphoneDataGetResponse.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ReceiverController extends GetxController {
  var receivers = <SearchphoneDataGetResponse>[].obs;
  var isLoading = false.obs;
  var searchText = ''.obs;
  String url = '';

  // เพิ่ม Field Sender_ID ที่อ่านจาก GetStorage
  final int senderId = GetStorage().read('userId');

  @override
  void onInit() async {
    super.onInit();
    try {
      final config = await Configuration.getConfig();
      url = config['apiEndpoint'];
      log('API Endpoint: $url');

      // สร้าง debounce worker
      ever(searchText, (_) => _performSearch());
    } catch (e) {
      log('Error loading configuration: $e');
      Get.snackbar('Error', 'ไม่สามารถโหลดการกำหนดค่าได้');
    }
  }

  void updateSearch(String value) {
    searchText.value = value;
  }

  Future<void> _performSearch() async {
    if (searchText.value.isEmpty) {
      receivers.clear();
      return;
    }

    isLoading.value = true;
    try {
      final uri = Uri.parse('$url/api/receivers').replace(queryParameters: {
        'phoneNumber': searchText.value,
        'userID': senderId.toString(), // ใช้ Sender_ID จาก Field
      });

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        log('Decoded data: $decodedData');

        if (decodedData is List) {
          receivers.value = decodedData
              .map((user) => SearchphoneDataGetResponse.fromJson(user))
              .toList();
          log('Receivers found: ${receivers.length}');
        } else {
          log('No valid user data found');
          receivers.clear();
        }
      }
    } catch (error) {
      log('Error searching receiver: $error');
      Get.snackbar('Error', 'An error occurred while searching for receivers.');
      receivers.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

class SearchReceiverPage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final List<String> selectedIds;
  final receiverController = Get.put(ReceiverController());

  SearchReceiverPage({Key? key})
      : selectedIds = (Get.arguments is List)
            ? List<String>.from(Get.arguments.map((id) => id.toString()))
            : [],
        super(key: key) {
    log('ProductsID: $selectedIds');
  }
  Future<void> sendOrderData(int recipientId, List<String> productsId) async {
    // ตรวจสอบว่ามีสินค้าใน productsId หรือไม่
    if (productsId.isEmpty) {
      log('No products selected.');
      Get.snackbar('Error', 'No products selected');
      return;
    }

    // Log ข้อมูลที่สำคัญ
    log('Sender_ID: ${receiverController.senderId}, Recipient_ID: $recipientId, Products: $productsId');

    // ใช้ url จาก receiverController
    final uri = Uri.parse('${receiverController.url}/createOrder');

    // สร้างข้อมูล Body ที่จะส่งไปกับ API request
    final body = jsonEncode({
      'Sender_ID':
          receiverController.senderId, // ใช้ Sender_ID จาก receiverController
      'Recipient_ID': recipientId, // รับค่า Recipient_ID จาก receiver.userId
      'products': productsId, // ส่งรายการ productsId ที่เลือก
    });

    try {
      // เรียกใช้ API ด้วย method POST
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        log('Order created successfully: ${response.body}');
        Get.snackbar('Success', 'Order created successfully');
        Get.to(() => HomePage()); // หน้าสถานะการจัดส่ง
      } else {
        log('Failed to create order: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to create order');
      }
    } catch (error) {
      log('Error creating order: $error');
      Get.snackbar('Error', 'An error occurred while creating the order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาผู้รับ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'หมายเลขโทรศัพท์',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                hintText: 'พิมพ์เพื่อค้นหา',
              ),
              onChanged: (value) {
                receiverController.updateSearch(value);
              },
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (receiverController.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (receiverController.receivers.isEmpty &&
                  !receiverController.isLoading.value &&
                  _phoneController.text.isNotEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('ไม่พบข้อมูลผู้รับ',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: receiverController.receivers.length,
                  itemBuilder: (context, index) {
                    final receiver = receiverController.receivers[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: receiver.profilePicture != null &&
                                  receiver.profilePicture.isNotEmpty
                              ? NetworkImage(receiver
                                  .profilePicture) // Load image from URL
                              : AssetImage('asset/images/default_profile.png')
                                  as ImageProvider, // Placeholder image
                        ),
                        title:
                            Text(receiver.name), // Access name field from User
                        subtitle: Text(receiver
                            .phoneNumber), // Access phoneNumber from User
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            // Log the receiver's id when the icon is pressed
                            log('Recipient_ID: ${receiver.userId}');

                            // เรียกใช้ sendOrderData และส่ง Sender_ID, Recipient_ID, และ productsId
                            sendOrderData(receiver.userId, selectedIds);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
