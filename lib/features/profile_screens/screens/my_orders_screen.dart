import 'package:flutter/material.dart';
import '../../../core/common/widgets/app_scaffold.dart';
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

  // Sample data
  final ongoingOrders = [
    OrderModel(
      shopName: "Pizza Hut",
      image: "assets/pizza.png",
      orderId: "162432",
      amount: 35.25,
      itemsCount: 3,
      isPaid: true,
    ),
    OrderModel(
      shopName: "Pizza Hut",
      image: "assets/pizza.png",
      orderId: "162433",
      amount: 35.25,
      itemsCount: 3,
      isPaid: false,
    ),
  ];

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(
              width: 3.0,
              color: Color(0xFF7F3615),
            ),
            // Set horizontal padding to control indicator width
            insets: const EdgeInsets.symmetric(horizontal: 120),
            // adjust width here
          ),
          tabs: const [
            Tab(text: "Ongoing",),
            Tab(text: "Completed"),
          ],
        )
        ,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersList(orders: ongoingOrders),
          OrdersList(orders: completedOrders),
        ],
      ),
    );
  }
}
