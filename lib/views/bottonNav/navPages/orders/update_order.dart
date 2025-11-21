import 'package:flutter/material.dart';
import 'package:mumtozashop/models/order_model.dart';
import 'package:mumtozashop/viewModel/order_view_model.dart';
import 'package:mumtozashop/views/widgets/confirm_action_dialog.dart';

class UpdateOrder extends StatefulWidget {
  final OrderModel orderData;
  const UpdateOrder({super.key, required this.orderData});

  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  OrderViewModel orderViewModel = OrderViewModel();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.settings, color: Colors.blue),
          SizedBox(width: 8),
          Text("Order Options"),
        ],
      ),
      content: const Text("Choose what you want to do with this order."),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.cancel, color: Colors.white),
          label: const Text("Cancel Order"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);

            showDialog(
              context: context,
              builder: (context) => ConfirmActionDialog(
                dialogBodyText:
                    "Once canceled, this order cannot be changed. To receive these items, you’ll need to place a new order.",
                onYesCallback: () async {
                  await orderViewModel.updateOrderStatus(
                    docId: widget.orderData.id_order,
                    orderData: {"status": "CANCELLED"},
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order Cancelled Successfully."),
                    ),
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                onNoCallback: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ],
    );
  }
}
