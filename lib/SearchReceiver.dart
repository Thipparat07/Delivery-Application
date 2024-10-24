import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/config/config.dart';
import 'package:flutter_delivery_1/model/SearchphoneDataGetResponse.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ReceiverController extends GetxController {
  var receivers = <SearchphoneDataGetResponse>[]
      .obs; // ใช้ List<SearchphoneDataGetResponse>
  var isLoading = false.obs;
  var searchText = ''.obs;
  String url = '';

  @override
  void onInit() async {
    super.onInit();
    try {
      final config = await Configuration.getConfig();
      url = config['apiEndpoint'];
      log('API Endpoint: $url'); // บันทึก endpoint สำหรับการตรวจสอบ
      // Create a debounce worker
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
      final box = GetStorage();
      final int userId = box.read('userId'); // Read userId from GetStorage
      final uri = Uri.parse('$url/api/receivers')
          .replace(queryParameters: {
        'phoneNumber': searchText.value,
        'userID': userId.toString(),
      });

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        log('Decoded data: $decodedData');

        if (decodedData is List) {
          // Check if the decoded data is a list
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
    log('Selected IDs: $selectedIds');
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
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(receiver
                            .name), // เข้าถึงชื่อผ่านฟิลด์ name ของ User
                        subtitle: Text(receiver
                            .phoneNumber), // เข้าถึงเบอร์โทรผ่านฟิลด์ phoneNumber ของ User
                        trailing: const Icon(Icons.arrow_forward_ios),
                        // onTap: () {
                        //   Get.toNamed('/order-confirmation', arguments: {
                        //     'receiver': receiver,
                        //     'selectedIds': selectedIds,
                        //   });
                        // },
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
