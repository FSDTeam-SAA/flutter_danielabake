import 'package:flutter/material.dart';
import '../../../core/constants/assets_const.dart';
import 'model/order_model.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x2EB9722E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // shadow color
                  spreadRadius: 1, // how much shadow spreads
                  blurRadius: 5, // blur effect
                  offset: Offset(0, 3), // x, y offset
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                order.image,
                height: 75,
                width: 75,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.shopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      "\$${order.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      height: 25, // make it long
                      width: 2,   // thickness of the line
                      decoration: BoxDecoration(
                        color: Color(0xFFCACCDA),
                        borderRadius: BorderRadius.circular(2), // optional: rounded edges
                        border: Border.all(width: 1, color: Color(0xFFCACCDA)),
                      ),
                    ),

                    const SizedBox(width: 14),
                    Text(
                      "${order.itemsCount} Items",
                      style: const TextStyle(color: Color(0xFF6B6E82,), fontSize: 14, fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "#${order.orderId}",
                style: const TextStyle(color: Color(0xFF6B6E82,)),
              ),
              const SizedBox(height: 6),
              Text(
                order.isPaid ? "Paid" : "Not Paid",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: order.isPaid ? Color(0xFF02772F) : Color(0xFFDB422D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
