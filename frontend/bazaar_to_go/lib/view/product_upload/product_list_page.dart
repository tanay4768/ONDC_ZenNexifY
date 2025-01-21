import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Attribute Model (for product attributes and specifications)
class Attribute {
  String name;
  String value;

  Attribute({required this.name, required this.value});
}

// Product Model
class Product {
  String productId;
  String title;
  double rating;
  double price;
  String description;
  String category;
  List<Attribute> attributes;
  List<Attribute> specifications;
  List<String> images;

  Product({
    required this.productId,
    required this.title,
    required this.rating,
    required this.price,
    required this.description,
    required this.category,
    required this.attributes,
    required this.specifications,
    required this.images,
  });
}

// Controller for Product Management
class ProductController extends GetxController {
  var products = <Product>[].obs;

  void addProduct(Product product) {
    products.add(product);
  }

  void updateProduct(Product updatedProduct) {
    var index =
        products.indexWhere((p) => p.productId == updatedProduct.productId);
    if (index != -1) {
      products[index] = updatedProduct;
    }
  }
}

// Main Product List Page
class ProductListPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final ImagePicker imagePicker = ImagePicker();

  Future<void> _addProduct(BuildContext context) async {
    String? selectedCategory = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select a Category'),
        children: ['Electronics', 'Clothing', 'Grocery'].map((category) {
          return SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, category);
            },
            child: Text(category),
          );
        }).toList(),
      ),
    );

    if (selectedCategory != null) {
      final TextEditingController titleController = TextEditingController();
      final TextEditingController ratingController = TextEditingController();
      final TextEditingController priceController = TextEditingController();
      final TextEditingController descriptionController =
          TextEditingController();
      final List<Attribute> attributes = [];
      final List<Attribute> specifications = [];

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enter Product Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: ratingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                Text('Enter Attributes (name and value):'),
                // Button to add attributes
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Enter Attribute'),
                        content: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Attribute Name',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (name) {
                                if (name.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Enter Attribute Value'),
                                      content: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Attribute Value',
                                          border: OutlineInputBorder(),
                                        ),
                                        onSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            attributes.add(Attribute(
                                                name: name, value: value));
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text('Add Attribute'),
                ),
                SizedBox(height: 16),
                Text('Enter Specifications (name and value):'),
                // Button to add specifications
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Enter Specification'),
                        content: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Specification Name',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (name) {
                                if (name.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Enter Specification Value'),
                                      content: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Specification Value',
                                          border: OutlineInputBorder(),
                                        ),
                                        onSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            specifications.add(Attribute(
                                                name: name, value: value));
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text('Add Specification'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final image =
                    await imagePicker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  final productId = 'P${productController.products.length + 1}';
                  final title = titleController.text;
                  final rating = double.tryParse(ratingController.text) ?? 0.0;
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final description = descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : selectedCategory;

                  final product = Product(
                    productId: productId,
                    title: title,
                    rating: rating,
                    price: price,
                    description: description,
                    category: selectedCategory,
                    attributes: attributes,
                    specifications: specifications,
                    images: [image.path],
                  );

                  productController.addProduct(product);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Product List', style: TextStyle(fontSize: 20))),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return Center(
              child: Text('No products added yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)));
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailPage(product: product));
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            product.images.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.file(
                                      File(product.images.first),
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    height: 150,
                                    child: Center(
                                        child: Text('No Image',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '₹${product.price}',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Category: ${product.category}',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Product ID: ${product.productId}',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProduct(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}

// Product Detail Page with Editing
class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late TextEditingController titleController;
  late TextEditingController ratingController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late List<Attribute> attributes;
  late List<Attribute> specifications;
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    ratingController =
        TextEditingController(text: widget.product.rating.toString());
    priceController =
        TextEditingController(text: widget.product.price.toString());
    descriptionController =
        TextEditingController(text: widget.product.description);
    attributes = List.from(widget.product.attributes);
    specifications = List.from(widget.product.specifications);
    imagePicker = ImagePicker();
  }

  Future<void> _updateProduct() async {
    final updatedProduct = Product(
      productId: widget.product.productId,
      title: titleController.text,
      rating: double.tryParse(ratingController.text) ?? 0.0,
      price: double.tryParse(priceController.text) ?? 0.0,
      description: descriptionController.text,
      category: widget.product.category,
      attributes: attributes,
      specifications: specifications,
      images: widget.product.images,
    );

    final productController = Get.find<ProductController>();
    productController.updateProduct(updatedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Rating', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Price', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Text('Attributes:'),
              for (var attribute in attributes)
                ListTile(
                  title: Text(attribute.name),
                  subtitle: Text(attribute.value),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        attributes.remove(attribute);
                      });
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Enter Attribute'),
                      content: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Attribute Name',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (name) {
                              if (name.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Enter Attribute Value'),
                                    content: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Attribute Value',
                                        border: OutlineInputBorder(),
                                      ),
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            attributes.add(Attribute(
                                                name: name, value: value));
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text('Add Attribute'),
              ),
              SizedBox(height: 16),
              Text('Specifications:'),
              for (var specification in specifications)
                ListTile(
                  title: Text(specification.name),
                  subtitle: Text(specification.value),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        specifications.remove(specification);
                      });
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Enter Specification'),
                      content: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Specification Name',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (name) {
                              if (name.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Enter Specification Value'),
                                    content: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Specification Value',
                                        border: OutlineInputBorder(),
                                      ),
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            specifications.add(Attribute(
                                                name: name, value: value));
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text('Add Specification'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
