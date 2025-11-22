import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mumtozashop/viewModel/order_view_model.dart';

import '../../../../models/order_model.dart';
import '../../../../models/order_product_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderViewModel orderViewModel = OrderViewModel();
  final DateFormat dateFormat = DateFormat("dd MMM yyyy, hh:mm a");

  int totalQuantityCalculator(List<OrderProductModel> productsList) {
    return productsList.fold(0, (sum, product) => sum + product.quantity);
  }

  Widget orderStatusBadge(String orderStatus) {
    Color backgroundColor;
    Color statusTextColor;

    switch (orderStatus) {
      case "PAID":
        backgroundColor = Colors.cyan;
        statusTextColor = Colors.white;
        break;
      case "ON_THE_WAY":
        backgroundColor = Colors.orangeAccent;
        statusTextColor = Colors.black;
        break;
      case "DELIVERED":
        backgroundColor = Colors.green;
        statusTextColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.redAccent;
        statusTextColor = Colors.white;
    }

    return Chip(
      label: Text(orderStatus.replaceAll("_", " ")),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(color: statusTextColor),
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(fontSize: 22, color: Colors.pinkAccent),
        ).tr(),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: orderViewModel.fetchOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasData) {
            List<OrderModel> orders = OrderModel.fromJsonList(
              dataSnapshot.data!.docs,
            );

            if (orders.isEmpty) {
              return Center(
                child: Text(
                  "You haven't placed any order yet.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ).tr(),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/order_details",
                      arguments: order,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.receipt_long,
                              color: Colors.pinkAccent,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${totalQuantityCalculator(order.productsList)} items:${order.total} UZS",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateFormat.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      order.created_at,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          orderStatusBadge(order.status),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
