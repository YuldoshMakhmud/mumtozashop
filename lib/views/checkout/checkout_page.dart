import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mumtozashop/viewModel/cart_view_model.dart';
import 'package:mumtozashop/viewModel/order_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final String _telegramBotToken =
      "7638672112:AAGig6lcWULWUsns9zMBO8okByQ575oVaQ0";
  final String _chatId = "6373668101";

  TextEditingController couponTextEditingController = TextEditingController();
  int discountValue = 0;
  String discountString = "";
  File? _receiptFile;

  final OrderViewModel orderViewModel = OrderViewModel();
  final CartViewModel cartViewModel = CartViewModel();

  final ImagePicker _picker = ImagePicker();

  pickReceipt() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _receiptFile = File(pickedFile.path);
      });
    }
  }

  sendTelegramMessage(String message) async {
    final url = Uri.parse(
      "[https://api.telegram.org/bot$_telegramBotToken/sendMessage?chat_id=$_chatId&text=$message](https://api.telegram.org/bot$_telegramBotToken/sendMessage?chat_id=$_chatId&text=$message)",
    );
    await http.get(url);
  }

  calculateDiscount(int discountPercentage, int totalCost) {
    discountValue = (discountPercentage * totalCost) ~/ 100;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDD5D79),
        title: Row(
          children: const [
            Icon(Icons.shopping_bag_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Checkout",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
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
                    // DELIVERY DETAILS CARD
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${userData.nameOfUser}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("Email: ${userData.emailOfUser}"),
                            SizedBox(height: 4),
                            Text("Phone: ${userData.phoneNumberOfUser}"),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // BANK ACCOUNT CARD
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bank Account",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Account Number: 1234 5678 9012 3456"),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // UPLOAD RECEIPT BUTTON
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: pickReceipt,
                          icon: Icon(Icons.upload_file),
                          label: Text("Upload Check/Receipt"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(width: 12),
                        _receiptFile != null
                            ? Text(
                                "File selected",
                                style: TextStyle(color: Colors.green),
                              )
                            : Text("No file selected"),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Total Payable: ${cartData.totalCost - discountValue} UZS",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          height: 60,
          child: ElevatedButton.icon(
            onPressed: () async {
              final userData = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              final cartData = Provider.of<CartProvider>(
                context,
                listen: false,
              );

              if (_receiptFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please upload check/receipt.")),
                );
                return;
              }

              User? currentUser = FirebaseAuth.instance.currentUser;
              List productsList = cartData.productsList.asMap().entries.map((
                entry,
              ) {
                int i = entry.key;
                var prod = entry.value;
                return {
                  "id": prod.idProduct,
                  "name": prod.nameProduct,
                  "image": prod.imageProduct,
                  "single_price": prod.new_price_Product,
                  "total_price":
                      prod.new_price_Product *
                      cartData.cartItemsList[i].quantity,
                  "quantity": cartData.cartItemsList[i].quantity,
                };
              }).toList();

              Map<String, dynamic> orderData = {
                "user_id": currentUser!.uid,
                "created_at": DateTime.now().millisecondsSinceEpoch,
                "name": userData.nameOfUser,
                "email": userData.emailOfUser,
                "address": userData.addressOfUser,
                "phone": userData.phoneNumberOfUser,
                "discount": discountValue,
                "total": cartData.totalCost - discountValue,
                "productsList": productsList,
                "status": "WAITING_FOR_PAYMENT",
              };

              // Save order
              await orderViewModel.saveNewOrderInfo(data: orderData);
              await cartViewModel.clearCart();

              // Send Telegram message
              await sendTelegramMessage(
                "New order from ${userData.nameOfUser}, total: ${cartData.totalCost - discountValue} UZS",
              );

              // Navigate to OrdersPage
              Navigator.pushReplacementNamed(context, "/orders");

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Order placed successfully. Wait for payment confirmation.",
                  ),
                ),
              );
            },
            icon: Icon(Icons.lock_outline),
            label: Text("Place Order"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
