import 'package:bazaar_to_go/repository/api_service.dart';
import 'package:bazaar_to_go/repository/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopViewmodel {
  void _fetchStoreDetails(String username) async {
  try {
    final response = await ApiService.post(
      Endpoint.getStore.getUrl(), // Use the correct endpoint for fetching store details
      {
        "username": username, // Provide username in the JSON body
      },
    );

    if (response.statusCode == 200) {
      final storeDetails = response.body;

      Get.snackbar(
        'Success',
        'Store details fetched successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      print("Store Details: $storeDetails");

    } else {
      print("Failed to fetch store details: ${response.statusCode}, ${response.body}");
      Get.snackbar(
        'Error',
        'Failed to fetch store details: ${response.body}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (error) {
    printError(info: error.toString());

    Get.snackbar(
      'Error',
      'Failed to fetch store details. Please try again. \n$error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
}