import 'package:bazaar_to_go/controllers/register_shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class RegisterShopPage extends StatefulWidget {
  final String username;
  RegisterShopPage({super.key, required this.username});

  @override
  State<RegisterShopPage> createState() => _RegisterShopPageState();
}

class _RegisterShopPageState extends State<RegisterShopPage> {
  final RegisterShopController controller = Get.put(RegisterShopController());
  final Color kDarkBlueColor = const Color(0xFF363AC2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlueColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Image.asset(
            "assets/images/cart_logo.png",
            colorBlendMode: BlendMode.colorDodge,
          ),
        ),
        title: const Text("Register Store",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.localShops.length,
                  itemBuilder: (context, index) {
                    return LocalShop(
                      index: index,
                      onDelete: () {
                        controller.removeLocalShop(index);
                      },
                      controller: controller,
                    );
                  },
                );
              }),
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.onlineShops.length,
                  itemBuilder: (context, index) {
                    return OnlineShop(
                      index: index,
                      onDelete: () {
                        controller.removeOnlineShop(index);
                      },
                      controller: controller,
                    );
                  },
                );
              }),
              ElevatedButton(
                onPressed: () {
                  controller.addOnlineShop(
                      ""); // You can modify this to take user input
                  Get.snackbar("Success", "Online store added");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkBlueColor,
                  fixedSize: Size(300, 50),
                ),
                child: Text(
                  'Add Online Store',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.addLocalShop();
                  Get.snackbar("Success", "Local store added");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkBlueColor,
                  fixedSize: Size(300, 50),
                ),
                child: Text(
                  'Add Local Store',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String jsonData = controller.toJson();
                  controller.onStoreUpload(widget.username);
                  Get.snackbar("Submitted", "Form data submitted");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkBlueColor,
                  fixedSize: Size(300, 50),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocalShop extends StatelessWidget {
  const LocalShop({
    super.key,
    required this.index,
    required this.onDelete,
    required this.controller,
  });

  final int index;
  final VoidCallback onDelete;
  final RegisterShopController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Local Store",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          FormBuilderTextField(
            name: 'local_store_${index}_name',
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(labelText: "Store Name"),
            onChanged: (value) {
              controller.localShops[index]['name'] = value ?? "";
            },
          ),
          FormBuilderTextField(
            name: 'local_store_${index}_gstin',
            validator: FormBuilderValidators.equalLength(15),
            decoration: const InputDecoration(labelText: "GSTIN"),
            onChanged: (value) {
              controller.localShops[index]['gstin'] = value ?? "";
            },
          ),
          const SizedBox(height: 10),
          const Text("Address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          FormBuilderTextField(
            name: 'local_store_${index}_pincode',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.equalLength(6),
            ]),
            decoration: const InputDecoration(labelText: "Pincode"),
            onChanged: (value) {
              controller.localShops[index]['pincode'] = value ?? "";
            },
          ),
          FormBuilderTextField(
            name: 'local_store_${index}_locality',
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(labelText: "Locality/City"),
            onChanged: (value) {
              controller.localShops[index]['street'] = value ?? "";
            },
          ),
          FormBuilderTextField(
            name: 'local_store_${index}_district',
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(labelText: "District"),
            onChanged: (value) {
              controller.localShops[index]['city'] = value ?? "";
            },
          ),
          FormBuilderTextField(
            name: 'local_store_${index}_state',
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(labelText: "State"),
            onChanged: (value) {
              controller.localShops[index]['state'] = value ?? "";
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class OnlineShop extends StatelessWidget {
  const OnlineShop({
    super.key,
    required this.index,
    required this.onDelete,
    required this.controller,
  });

  final int index;
  final VoidCallback onDelete;
  final RegisterShopController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Online Store",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          FormBuilderTextField(
            name: 'online_store_${index}_shopify',
            initialValue: "Shopify",
            readOnly: true,
            decoration: const InputDecoration(labelText: "Shopify"),
          ),
          FormBuilderTextField(
            name: 'online_store_${index}_api_key',
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(labelText: "API Key"),
            onChanged: (value) {
              controller.onlineShops[index]['api_key'] = value ?? "";
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
