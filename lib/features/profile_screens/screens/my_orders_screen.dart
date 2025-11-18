import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../models/response/ongoing_order_response_model.dart';
import '../widgets/model/order_model.dart';
import '../widgets/order_list.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _profileController.fetchOngoingOrders();
  }

  final completedOrders = [
    OrderModel(
      shopName: "Pizza Hut",
      image: "assets/pizza.png",
      orderId: "162290",
      amount: 29.80,
      itemsCount: 2,
      isPaid: true,
    ),
  ];

  List<OrderModel> mapOngoingOrders(OngoingOrderResponseModel data) {
    return data.orders.map((order) {
      // Take the first item as representative for image and shopName
      final firstItem = order.items.isNotEmpty ? order.items[0].item : null;

      return OrderModel(
        shopName: firstItem?.name ?? 'Unknown Shop',
        image: firstItem?.image.isNotEmpty == true
            ? firstItem!.image
            : 'https://via.placeholder.com/75',
        orderId: order.id,
        // Sum of all items for total amount
        amount: order.items.fold<double>(
            0, (sum, orderItem) => sum + orderItem.item.price * orderItem.quantity),
        // Total quantity of all items
        itemsCount: order.items.fold<int>(0, (sum, orderItem) => sum + orderItem.quantity),
        isPaid: order.status.toLowerCase() == 'paid',
      );
    }).toList();
  }



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF7F3615),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3.0,
              color: Color(0xFF7F3615),
            ),
            insets: EdgeInsets.symmetric(horizontal: 120),
          ),
          tabs: const [
            Tab(text: "Ongoing"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Use Obx to reactively listen to ongoing orders
          Obx(() {
    final ongoingData = _profileController.ongoingOrder.value;

    if (ongoingData == null || ongoingData.orders.isEmpty) {
    return const Center(child: Text("No ongoing orders"));
    }

    final orders = mapOngoingOrders(ongoingData);
    return OrdersList(orders: orders);
    }),


    OrdersList(orders: completedOrders),
        ],
      ),
    );
  }
}
