// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../controller/order_controller.dart';
// import '../models/response/getorder_by_id_response model.dart';
//
// class OrderedItemCard extends StatefulWidget {
//   final OrderItem orderItem;
//
//   const OrderedItemCard({super.key, required this.orderItem});
//
//   @override
//   State<OrderedItemCard> createState() => _OrderedItemCardState();
// }
//
// class _OrderedItemCardState extends State<OrderedItemCard> {
//   final orderController = Get.find<OrderController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final item = widget.orderItem.item;
//
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       decoration: BoxDecoration(
//         color: const Color(0x2EFFB972),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // TOP CONTENT
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // IMAGE
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   item.image,
//                   width: 100,
//                   height: 100,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//
//               // NAME + SUBTITLE
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.name,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 14),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       item.,
//                       style: const TextStyle(
//                           fontSize: 13, color: Color(0xFF7F3615)),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // TOTAL PRICE
//               Text(
//                 "\$${(price * quantity).toStringAsFixed(2)}",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w600, fontSize: 16),
//               ),
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
// }
