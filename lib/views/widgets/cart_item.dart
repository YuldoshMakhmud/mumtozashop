import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/viewModel/common_view_model.dart';

import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';

class CartItem extends StatefulWidget {
  final Uint8List imageBytes;
  final String nameProduct;
  final String productID;
  final int new_price_Product;
  final int old_price_Product;
  final int maxQuantity;
  final int chosenQuantity;

  const CartItem({
    super.key,
    required this.imageBytes,
    required this.nameProduct,
    required this.productID,
    required this.new_price_Product,
    required this.old_price_Product,
    required this.maxQuantity,
    required this.chosenQuantity,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantityCount = 1;
  CommonViewModel commonViewModel = CommonViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    quantityCount = widget.chosenQuantity;
  }

  incrementQuantity(int maxQuantity) {
    if (quantityCount >= maxQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum Quantity. Limit Reached.")),
      );
      return;
    } else {
      Provider.of<CartProvider>(context, listen: false).addItemDataToCart(
        CartModel(productID: widget.productID, quantity: quantityCount),
      );
      setState(() {
        quantityCount++;
      });
    }
  }

  decrementQuantity() {
    if (quantityCount > 1) {
      Provider.of<CartProvider>(
        context,
        listen: false,
      ).decreaseQuantityCount(widget.productID);

      setState(() {
        quantityCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.all(11),
        margin: EdgeInsets.all(11),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 81,
                  width: 81,
                  child: Image.memory(widget.imageBytes, fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nameProduct,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          SizedBox(width: 2),
                          Text(
                            "${widget.old_price_Product} UZS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${widget.new_price_Product} UZS",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                            size: 18,
                          ),
                          Text(
                            "${commonViewModel.getDiscountPercentage(widget.old_price_Product, widget.new_price_Product)}%",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).deleteItemFromCart(widget.productID);
                  },
                  icon: Icon(Icons.delete, color: Colors.red.shade400),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Quantity:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pinkAccent,
                  ),
                  child: IconButton(
                    onPressed: () {
                      incrementQuantity(widget.maxQuantity);
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "$quantityCount",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pinkAccent,
                  ),
                  child: IconButton(
                    onPressed: () {
                      decrementQuantity();
                    },
                    icon: Icon(Icons.remove),
                  ),
                ),
                Spacer(),
                Text("Total:"),
                SizedBox(width: 8),
                Text(
                  "${widget.new_price_Product * quantityCount} uzs",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
