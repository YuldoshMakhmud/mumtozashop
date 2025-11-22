import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mumtozashop/viewModel/coupon_view_model.dart';

import '../../models/coupon_model.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  CouponViewModel couponViewModel = CouponViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discount Coupons".tr(),
          style: TextStyle(fontSize: 22, color: Colors.pinkAccent),
        ),
      ),
      body: StreamBuilder(
        stream: couponViewModel.fetchCoupons(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasData) {
            List<CouponModel> discountsList = CouponModel.fromJsonList(
              dataSnapshot.data!.docs,
            );

            if (discountsList.isEmpty) {
              return SizedBox();
            } else {
              return ListView.builder(
                itemCount: discountsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 6,
                      child: ListTile(
                        leading: Icon(
                          Icons.discount_outlined,
                          color: Colors.pinkAccent,
                        ),
                        title: Text(discountsList[index].codeCoupon),
                        subtitle: Text(discountsList[index].descCoupon),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return CircularProgressIndicator(color: Colors.pinkAccent);
          }
        },
      ),
    );
  }
}
