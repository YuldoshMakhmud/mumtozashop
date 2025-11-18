import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/views/widgets/cart_item.dart';

import '../../../providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart", style: TextStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.isProgressing) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (value.cartItemsList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Your cart is empty.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "you haven’t added any product to your cart yet.",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            } else {
              if (value.productsList.isNotEmpty) {
                return ListView.builder(
                  itemCount: value.cartItemsList.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final base64String = value.productsList[index].imageProduct;
                    final bytes = base64Decode(base64String);

                    return CartItem(
                      imageBytes: bytes,
                      nameProduct: value.productsList[index].nameProduct,
                      new_price_Product:
                          value.productsList[index].new_price_Product,
                      old_price_Product:
                          value.productsList[index].old_price_Product,
                      maxQuantity: value.productsList[index].maxQuantityProduct,
                      chosenQuantity: value.cartItemsList[index].quantity,
                      productID: value.productsList[index].idProduct,
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "your cart is empty.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
            }
          }
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.cartItemsList.isEmpty) {
            return const SizedBox();
          } else {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        "Total: ${value.totalCost}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/checkout");
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Checkout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
