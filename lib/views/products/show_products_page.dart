import 'dart:convert';

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
        title: Text(
          //cars = Cars
          //"${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)}",
          args["name"],
        ),
      ),
      body: StreamBuilder(
        stream: productViewModel.fetchProducts(args["name"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> productsList = ProductModel.fromJsonList(
              snapshot.data!.docs,
            );

            if (productsList.isEmpty) {
              return Center(child: Text("No productsList found."));
            } else {
              return GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.65,
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
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              product.nameProduct,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "💲${product.old_price_Product}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "💲${product.new_price_Product}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Text(
                                  "${commonViewModel.getDiscountPercentage(product.old_price_Product, product.new_price_Product)}%",
                                  style: TextStyle(
                                    fontSize: 15,
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
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
