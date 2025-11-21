import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/viewModel/common_view_model.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  CommonViewModel commonViewModel = CommonViewModel();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(color: Colors.pinkAccent),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image
            Image.memory(
              base64Decode(args.imageProduct),
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  /// Product Name
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 22,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          args.nameProduct,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14),

                  /// Price + Discount
                  Row(
                    children: [
                      Text(
                        "${args.old_price_Product} UZS",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${args.new_price_Product} UZS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                      Text(
                        "${commonViewModel.getDiscountPercentage(args.old_price_Product, args.new_price_Product)}%",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14),

                  /// Stock Status
                  Row(
                    children: [
                      Icon(
                        args.maxQuantityProduct == 0
                            ? Icons.error_outline
                            : Icons.inventory_2_outlined,
                        color: args.maxQuantityProduct == 0
                            ? Colors.red
                            : Colors.green,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        args.maxQuantityProduct == 0
                            ? "Currently out of stock"
                            : "Only ${args.maxQuantityProduct} left — order soon!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: args.maxQuantityProduct == 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  /// Product Description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            args.descriptionProduct,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: args.maxQuantityProduct != 0
          ? Row(
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).addItemDataToCart(
                        CartModel(productID: args.idProduct, quantity: 1),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Item Added to your cart.",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xFFDD5D79),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: const Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).addItemDataToCart(
                        CartModel(productID: args.idProduct, quantity: 1),
                      );

                      Navigator.pushNamed(context, "/checkout");
                    },
                    icon: const Icon(Icons.flash_on_outlined),
                    label: const Text("Buy Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.pinkAccent,
                      shape: const RoundedRectangleBorder(),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
