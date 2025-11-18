import 'package:flutter/material.dart';

import 'model/order_model.dart';
import 'order_tile.dart';

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderTile(order: orders[index]);
      },
    );
  }
}
