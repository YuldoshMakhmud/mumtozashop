import 'package:flutter/material.dart';
import 'package:mumtozashop/viewModel/coupon_view_model.dart';

import '../../../../models/coupon_model.dart';

class CouponContainer extends StatefulWidget {
  const CouponContainer({super.key});

  @override
  State<CouponContainer> createState() => _CouponContainerState();
}

class _CouponContainerState extends State<CouponContainer> {
  CouponViewModel couponViewModel = CouponViewModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: couponViewModel.fetchCoupons(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.hasData) {
          List<CouponModel> couponsList = CouponModel.fromJsonList(
            dataSnapshot.data!.docs,
          );

          if (couponsList.isEmpty) return const SizedBox();

          final coupon = couponsList[0];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/coupons");
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent,
                    const Color.fromARGB(255, 227, 176, 193),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade50.withValues(alpha: 128),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer, color: Color(0xFFFFF5E1), size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.codeCoupon,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFFF5E1),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          coupon.descCoupon,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFF5E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator(color: Colors.pinkAccent);
        }
      },
    );
  }
}
