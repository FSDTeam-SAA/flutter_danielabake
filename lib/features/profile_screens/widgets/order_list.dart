import 'package:flutter/material.dart';

import 'model/order_model.dart';
import 'order_tile.dart';

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: orders.length,
      itemBuilder: (_, index) => OrderTile(order: orders[index]),
    );
  }
}
