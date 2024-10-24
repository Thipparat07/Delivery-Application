import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ReceiverController extends GetxController {
  var receivers = <Map<String, dynamic>>[].obs; // Use a Map to represent the receiver data
  var isLoading = false.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Create a debounce worker
    ever(searchText, (_) => _performSearch());
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
      final int userId = GetStorage().read('userId');
      final userID = userId;
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/receivers?phoneNumber=${searchText.value}&userID=$userID'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        receivers.value = List<Map<String, dynamic>>.from(data);
        log('Receivers found: ${receivers.length}');
      } else {
        log('Error: ${response.statusCode}');
        receivers.clear();
      }
    } catch (error) {
      log('Error searching receiver: $error');
      receivers.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

class SearchReceiverPage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final List<String> selectedIds; // Store selected IDs
  final receiverController = Get.put(ReceiverController());

  SearchReceiverPage({Key? key})
      : selectedIds = (Get.arguments is List) // Ensure it's a List
          ? List<String>.from(Get.arguments.map((id) => id.toString())) // Convert each ID to String
          : [], // Fallback to an empty list if not
        super(key: key) {
    // Log the selected IDs for debugging
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
                        title: Text(receiver['Name']),
                        subtitle: Text(receiver['PhoneNumber']),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.toNamed('/order-confirmation', arguments: {
                            'receiver': receiver,
                            'selectedIds': selectedIds,
                          });
                        },
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