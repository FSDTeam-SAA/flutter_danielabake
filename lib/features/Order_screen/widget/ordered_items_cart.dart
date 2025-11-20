import 'package:flutter/material.dart';
import '../models/response/get_order_by_id_response model.dart';

class OrderedItemCard extends StatelessWidget {
  final OrderItem orderItem;
  final String address;
  final String status;

  const OrderedItemCard({
    super.key,
    required this.orderItem,
    required this.address,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final item = orderItem.item;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0x2EFFB972),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 10),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  "description",
                  style: const TextStyle(fontSize: 13, color: Color(0xFF7F3615)),
                ),

                // Text(
                //   "Price: \$${item.price}",
                //   style: const TextStyle(
                //       fontSize: 13,
                //       color: Color(0xFF7F3615),
                //       fontWeight: FontWeight.w600),
                // ),

                const SizedBox(height: 5),

                Text(
                  "$address",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7F3615)),
                ),
                SizedBox(height: 10,),
                Text(
                  "$status",
                  style: const TextStyle(
                      fontSize: 12, color: Colors.green, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
