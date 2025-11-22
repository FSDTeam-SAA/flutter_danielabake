import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final controller = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    controller.fetchOngoingOrders(); // fetch when screen opens
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      backgroundColor: const Color(0xffFFF8E8), // same soft background

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFFF8E8),
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          // Custom indicator with color and size
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: Color(0xFF7F3615)), // thickness & color
            insets: EdgeInsets.symmetric(horizontal: -35), // smaller horizontal inset = longer line
          ),
          labelColor: Color(0xFF7F3615),
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),// selected tab text color
          unselectedLabelColor: Colors.grey, // unselected tab text color
          tabs: const [
            Tab(text: "Ongoing"),
            Tab(text: "Completed"),
          ],
        ),
      ),


      body: TabBarView(
        controller: tabController,
        children: [
          /// First Tab - ONGOING
          _ongoingList(),

          /// Second Tab - COMPLETED (empty for now)
          _completList()
        ],
      ),
    );
  }

  ///ONGOING LIST (FROM API)
  Widget _ongoingList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.ongoingOrder.value;

      if (data == null || data.orders.isEmpty) {
        return const Center(child: Text("No Orders Found"));
      }

      final orders = data.orders;

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Order ID & Payment Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order Id: #${order.id.substring(order.id.length - 6)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: order.status == "Paid"
                            ? Colors.green
                            : order.status == "Pending"
                            ? Colors.grey
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Items list
                Column(
                  children: order.items.map((orderItem) {
                    final item = orderItem.item;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(orderItem.quantity.toString())
                              ],
                            ),
                          ),
                          Text("\$${item.price.toStringAsFixed(2)}"),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: const Divider(height: 20, thickness: 1, color: Color(0xFFAD653F),),
                ),

                /// Total amount & items count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:  \$${order.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Text("(${order.items.length} items)"),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }


  Widget _completList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.completedOrder.value;

      if (data == null || data.orders.isEmpty) {
        return const Center(child: Text("No Orders Found"));
      }

      final orders = data.orders;

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Order ID & Payment Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order Id: #${order.id.substring(order.id.length - 6)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: order.status == "Paid"
                            ? Colors.green
                            : order.status == "Pending"
                            ? Colors.grey
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Items list
                Column(
                  children: order.items.map((orderItem) {
                    final item = orderItem.item;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(orderItem.quantity.toString())
                              ],
                            ),
                          ),
                          Text("\$${item.price.toStringAsFixed(2)}"),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: const Divider(height: 20, thickness: 1, color: Color(0xFFAD653F),),
                ),

                /// Total amount & items count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:  \$${order.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Text("(${order.items.length} items)"),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
  }




