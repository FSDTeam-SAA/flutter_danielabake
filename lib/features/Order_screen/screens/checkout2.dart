import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/utils/app_svg.dart';

class Checkout2Screen extends StatefulWidget {
  const Checkout2Screen({super.key});

  @override
  State<Checkout2Screen> createState() => _Checkout2ScreenState();
}

class _Checkout2ScreenState extends State<Checkout2Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    orderController.fetchCart();
  }

  _submit(){
    // if (!_formKey.currentState!.validate()) return;
    orderController.placeOrder(addressController.text, phoneController.text);
  }


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0x2EFFB972), // full width to bottom
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important to avoid full-screen height
            children: [
              Obx(
              ()=> Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    Text("\$${orderController.cart.value!.total.toStringAsFixed(2)}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              PrimaryButton(text: 'Place Order', onApiPressed: () => _submit()),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // The main container with address, phone, delivery
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0x2EFFB972),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTile(
                      imagePath: Images.address,
                      title: "Home",
                      child: TextFormField(
                        controller: addressController,
                        validator: Validators.name,
                        decoration: const InputDecoration(
                          hintText: "Enter address",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    _divider(),
                    _buildTile(
                      imagePath: Images.phone,
                      title: "Phone",
                      child: TextFormField(
                        validator: Validators.phone,
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: "+88 00-1111-2222",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    _divider(),
                    _buildTile(
                      imagePath: Images.delivery,
                      title: "Estimated Delivery Time",
                      child: const Text(
                        "2hr",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(color: Color(0xFFAD653F), thickness: 1),
    );
  }

  Widget _buildTile({
    required String imagePath,
    String? suffixImagePath,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(decoration: BoxDecoration(
          color: Color(0xFFFFEFD5),
            borderRadius: BorderRadius.circular(44)
      ),child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppSvg(asset: imagePath, width: 22,height: 22,),
      )),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                child,
              ],
            ),
          ),

          if (suffixImagePath != null)
            Image.asset(suffixImagePath, width: 22, height: 22),
        ],
      ),
    );
  }
}
