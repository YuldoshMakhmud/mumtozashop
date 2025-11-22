import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mumtozashop/views/bottonNav/navPages/orders/update_order.dart';
import '../../../../models/order_model.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderModel;
    final dateTimeFormat = DateFormat("dd MMM yyyy, hh:mm a");

    Widget sectionCardUI(
      IconData icon,
      Color iconColor,
      String title,
      List<String> detailsList, {
      Widget? child,
    }) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 8),
            if (child != null)
              child
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: detailsList
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Order Details").tr(), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionCardUI(
              Icons.location_on,
              Colors.pinkAccent,
              "Delivery Information".tr(),
              [
                "Order ID: ${args.id_order}",
                "Ordered on: ${dateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(args.created_at))}",
                "Customer: ${args.name}",
                "Phone: ${args.phone}",
                "Address: ${args.address}",
              ],
            ),

            SizedBox(height: 12),

            sectionCardUI(
              Icons.shopping_bag,
              Colors.orange,
              "Ordered Items".tr(),
              [],
              child: Column(
                children: args.productsList.map((e) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(e.image),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${e.name}\n${e.single_price} UZS × ${e.quantity}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          "${e.total_price} UZS",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 12),

            sectionCardUI(
              Icons.payments,
              Colors.pinkAccent,
              "Payment Overview".tr(),
              [
                "Discount: ${args.discount} UZS",
                "Total: ${args.total} UZS",
                "Status: ${args.status.replaceAll("_", " ")}",
              ],
            ),

            SizedBox(height: 17),

            if (args.status == "PAID" || args.status == "ON_THE_WAY")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    "Update My Order",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ).tr(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => UpdateOrder(orderData: args),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
