import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/viewModel/checkout_view_model.dart';

import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController couponTextEditingController = TextEditingController();

  int discountValue = 0;
  String discountString = "";

  CheckoutViewModel checkoutViewModel = CheckoutViewModel();

  calculateDiscount(int discountPercentage, int totalCost) {
    discountValue = (discountPercentage * totalCost) ~/ 100;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 22),
            SizedBox(width: 8),
            Text("Checkout", style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
            builder: (context, cartData, child) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION - Delivery Details
                    Row(
                      children: const [
                        Icon(Icons.local_shipping_outlined, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "Delivery Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.nameOfUser,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(userData.emailOfUser),
                                Text(userData.addressOfUser),
                                Text(userData.phoneNumberOfUser),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/edit_profile");
                            },
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // SECTION - Coupons/Discount
                    Row(
                      children: const [
                        Icon(Icons.discount_outlined, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "Have a coupon?",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: couponTextEditingController,
                            decoration: InputDecoration(
                              labelText: "Coupon Code",
                              hintText: "Enter code for discount",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            QuerySnapshot querySnapshot =
                                await checkoutViewModel
                                    .checkDiscountCodeValidity(
                                      discountCode: couponTextEditingController
                                          .text
                                          .toUpperCase(),
                                    );

                            if (querySnapshot.docs.isNotEmpty) {
                              QueryDocumentSnapshot doc =
                                  querySnapshot.docs.first;
                              int percent = doc.get('discount');
                              discountString =
                                  "Discount applied: $percent% off your total.";
                              calculateDiscount(percent, cartData.totalCost);
                            } else {
                              discountString = "Invalid or expired coupon.";
                            }
                            setState(() {});
                          },
                          child: const Text("Apply"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (discountString.isNotEmpty) Text(discountString),
                    const SizedBox(height: 40),

                    const Divider(),

                    // SECTION - Order Summary
                    Row(
                      children: const [
                        Icon(Icons.receipt_long_outlined, size: 20),
                        SizedBox(width: 6),
                        Text("Order Summary"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Items: ${cartData.totalQuantity}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Subtotal: 💲 ${cartData.totalCost}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Extra Discount: - 💲 $discountValue",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const Divider(),
                    Text(
                      "Total Payable: 💲 ${cartData.totalCost - discountValue}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
