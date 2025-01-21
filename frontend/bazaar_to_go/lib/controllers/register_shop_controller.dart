import 'dart:convert';

import 'package:bazaar_to_go/repository/api_service.dart';
import 'package:bazaar_to_go/repository/endpoint.dart';
import 'package:bazaar_to_go/view/Dashboard/dashboardview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterShopController extends GetxController {
  final RxList<Widget> fields = <Widget>[].obs;
  var localShops = <Map<String, String>>[].obs;
  var onlineShops = <Map<String, String>>[].obs;

  void onStoreUpload(String username) async {
    final data = localShops[0];
    try {
      final response = await ApiService.post(
        Endpoint.postStore
            .getUrl(), // Define the correct endpoint for store upload
        {
          "storename": data['name'],
          "username":
              username, // Assuming userId is passed as a parameter or stored
          "location": {
            "street": data['street'],
            "city": data['city'],
            "state": data['state'],
            "zip": int.tryParse(data['pincode'] ?? '0') ?? 0,
            "country": "India",
          },
          "contact": 1111111111,
        } as Map<String, dynamic>,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Get.snackbar(
        //   'Success',
        //   'Store upload successful!',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        print("Successful");
        // Optionally, navigate to another screen if needed
        Get.offAll(Dashboardview(
          username: username,
        ));
      } else {
        print("Store Upload Failed: ${response.statusCode}, ${response.body}");
        // Get.snackbar(
        //   'Error',
        //   'Store upload failed: ${response.body}',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
        print("Failed");
      }
    } catch (error) {
      printError(info: error.toString());

      Get.snackbar(
        'Error',
        'Store upload failed. Please try again. \n$error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void addLocalShop() {
    localShops.add({
      'name': "",
      'gstin': "22AAAAA0000A1Z5",
      'pincode': "",
      'street': "",
      'city': "",
      'state': "",
    });
  }

  void removeLocalShop(int index) {
    localShops.removeAt(index);
  }

  void addOnlineShop(String apiKey) {
    onlineShops.add({
      'shopify': "Shopify",
      'api_key': apiKey,
    });
  }

  void removeOnlineShop(int index) {
    onlineShops.removeAt(index);
  }

  Map<String, dynamic> getFormData() {
    return localShops[0];
  }

  String toJson() {
    return jsonEncode(getFormData());
  }
}
