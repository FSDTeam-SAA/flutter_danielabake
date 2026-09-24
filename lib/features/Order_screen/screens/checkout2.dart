import 'dart:ui';
import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/constants/assets_const.dart' hide Icons;
import '../../../core/utils/app_svg.dart';

class Checkout2Screen extends StatefulWidget {
  const Checkout2Screen({super.key});

  @override
  State<Checkout2Screen> createState() => _Checkout2ScreenState();
}

class _Checkout2ScreenState extends State<Checkout2Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController billingController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final ScrollController _billingScrollController = ScrollController();
  final orderController = Get.find<OrderController>();
  final profileController = Get.find<ProfileController>();
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String selectedPickupOption = "No";

  @override
  void initState() {
    super.initState();
    orderController.fetchCart();
    if (profileController.userInfo.value != null) {
      phoneController.text = profileController.userInfo.value!.phone;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      Get.snackbar('Error', 'Please select a delivery date');
      return;
    }
    if (selectedStartTime == null || selectedEndTime == null) {
      Get.snackbar('Error', 'Please select a delivery time window');
      return;
    }

    final scheduledFor = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedStartTime!.hour,
      selectedStartTime!.minute,
    );

    final scheduledTo = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );

    // Validation: delivery time cannot be less than 30 mins from now if today
    final now = DateTime.now();
    if (scheduledFor.isBefore(now.add(const Duration(minutes: 30)))) {
      Get.snackbar(
        'Invalid Time',
        'Delivery time must be at least 30 minutes from now.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    orderController.placeOrder(
      addressController.text,
      phoneController.text,
      scheduledFor,
      scheduledTo,
      selectedPickupOption == "Yes",
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final isAfter11AM = now.hour >= 11;
    final tomorrow = now.add(const Duration(days: 1));
    final firstSelectableDate = now.add(Duration(days: isAfter11AM ? 2 : 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: null,
      helpText: "Passed cut off time for tomorrow after 11:00 AM",
      firstDate: firstSelectableDate,
      lastDate: now.add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime day) {
        // Disable Today
        if (day.year == now.year &&
            day.month == now.month &&
            day.day == now.day) {
          return false;
        }
        // Disable Saturday (6) and Sunday (7)
        if (day.weekday == DateTime.saturday ||
            day.weekday == DateTime.sunday) {
          return false;
        }
        // Disable Tomorrow if after 11 AM
        if (isAfter11AM) {
          if (day.year == tomorrow.year &&
              day.month == tomorrow.month &&
              day.day == tomorrow.day) {
            return false;
          }
        }
        return true;
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
              headerHelpStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFAD653F),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child!, // This is the DatePickerDialog
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // 1. Pick Start Time
    final TimeOfDay? startPicked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "Select Start Time",
    );

    if (startPicked == null) return;

    // 2. Loop for End Time until valid or cancelled
    TimeOfDay? endPicked;
    bool isValidWindow = false;

    while (!isValidWindow) {
      endPicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: (startPicked.hour + (startPicked.minute + 45) ~/ 60) % 24,
          minute: (startPicked.minute + 45) % 60,
        ),
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: "Select End Time",
      );

      // User cancelled
      if (endPicked == null) return;

      // Validate: End time must be at least 30 minutes after Start time
      final double startInMinutes =
          startPicked.hour * 60 + startPicked.minute.toDouble();
      final double endInMinutes =
          endPicked.hour * 60 + endPicked.minute.toDouble();

      if (endInMinutes < startInMinutes + 30) {
        Get.snackbar(
          'Invalid Window',
          'Delivery window must be at least 30 minutes long. Please select again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Loop continues - will show picker again
      } else {
        isValidWindow = true;
      }
    }

    // Valid selection made
    final startText = startPicked.format(context);
    final endText = endPicked!.format(context);

    setState(() {
      selectedStartTime = startPicked;
      selectedEndTime = endPicked;
      timeController.text = "$startText - $endText";
    });
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
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 15,
            right: 15,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // important to avoid full-screen height
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "\$${orderController.cart.value!.total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              PrimaryButton(
                text: 'Place Order',
                key: Key("checkout"),
                onApiPressed: () => _submit(),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // The main container with address, phone, delivery
                Container(
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
                        title: "Picking up order",
                        child: DropdownButtonFormField<String>(
                          value: selectedPickupOption,
                          items: ["Yes", "No"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedPickupOption = newValue!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          icon: Icon(Icons.keyboard_arrow_down, size: 20),
                          dropdownColor: const Color(0xFFFFF9F2),
                        ),
                      ),
                      _divider(),

                      selectedPickupOption == "Yes"
                          ? ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 1.5,
                                sigmaY: 1.5,
                              ),
                              child: Opacity(
                                opacity: 0.5,
                                child: _buildTile(
                                  imagePath: Images.address,
                                  title: "Delivery Location",
                                  child: TextFormField(
                                    controller: addressController,
                                    enabled: false,
                                    validator: null,
                                    decoration: const InputDecoration(
                                      hintText: "Enter address and city",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : _buildTile(
                              imagePath: Images.address,
                              title: "Delivery Location",
                              child: TextFormField(
                                controller: addressController,
                                enabled: true,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Address and city required';
                                    }
                                    return null;
                                  },
                                decoration: const InputDecoration(
                                  hintText: "Enter address and city",
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
                        imagePath: Images.calendar,
                        title: "Delivery Date",
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: TextFormField(
                            enabled: false,
                            controller: dateController,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Select delivery date",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),

                      _divider(),
                      _buildTile(
                        imagePath: Images.delivery,
                        title: "Estimated delivery time",
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          child: TextFormField(
                            enabled: false,
                            controller: timeController,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Minimum 30 minute window",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


              SizedBox(height: 50,),

                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('Billing Information', style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0x2EFFB972),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Scrollbar(
                        controller: _billingScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: TextFormField(
                          controller: billingController,
                          scrollController: _billingScrollController,
                          maxLines: null, // allows unlimited lines
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          scrollPhysics: const BouncingScrollPhysics(),
                          decoration: const InputDecoration(
                            hintText: "Enter your notes",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
          ),
        ),
      ),)
    );
  }

  @override
  void dispose() {
    _billingScrollController.dispose();
    super.dispose();
  }


  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(color: Color(0xFFAD653F), thickness: 1),
    );
  }

  Widget _buildTile({
    String? imagePath,
    String? suffixImagePath,
    required String title,
    required Widget child,
    double verticalPadding = 6.0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: verticalPadding),
      child: Row(
        children: [
          if (imagePath != null) ...[
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFEFD5),
                borderRadius: BorderRadius.circular(44),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppSvg(asset: imagePath, width: 22, height: 22),
              ),
            ),
            const SizedBox(width: 10),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
