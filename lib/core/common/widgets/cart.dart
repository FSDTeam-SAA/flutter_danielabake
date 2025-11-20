import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/core/utils/app_svg.dart';
import 'package:danielabake/features/Order_screen/screens/order_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF0B6DFF)),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(onTap: () {Get.to(() => OrderScreens());},child: AppSvg(asset: Images.cart)),
        )
    );
  }
}
