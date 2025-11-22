import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mumtozashop/viewModel/product_view_model.dart';

import '../../models/product_model.dart';
import '../../viewModel/common_view_model.dart';

class ShowProductsPage extends StatefulWidget {
  const ShowProductsPage({super.key});

  @override
  State<ShowProductsPage> createState() => _ShowProductsPageState();
}

class _ShowProductsPageState extends State<ShowProductsPage> {
  ProductViewModel productViewModel = ProductViewModel();
  CommonViewModel commonViewModel = CommonViewModel();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(args["name"], style: TextStyle(color: Colors.pinkAccent)),
      ),
      body: StreamBuilder(
        stream: productViewModel.fetchProducts(args["name"]),
        builder: (context, snapshot) {
          // Add error handling
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            List<ProductModel> productsList = ProductModel.fromJsonList(
              snapshot.data!.docs,
            );

            if (productsList.isEmpty) {
              return Center(child: Text("No products found.").tr());
            }

            return GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio:
                    0.7, // Increased from 0.65 to give more height
              ),
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                final product = productsList[index];
                final imageBytes = base64Decode(product.imageProduct);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/product_details",
                      arguments: product,
                    );
                  },
                  child: Card(
                    color: Colors.grey.shade50,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Expanded(
                            flex: 3, // Give more space to image
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8),

                          // Product Name
                          Text(
                            product.nameProduct,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),

                          // Price Row - Fixed with Flexible widgets
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "${product.formattedOldPrice} UZS",
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  "${product.formattedNewPrice} UZS",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4),

                          // Discount Percentage
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                                size: 14,
                              ),
                              SizedBox(width: 2),
                              Text(
                                "${commonViewModel.getDiscountPercentage(product.old_price_Product, product.new_price_Product)}%",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
