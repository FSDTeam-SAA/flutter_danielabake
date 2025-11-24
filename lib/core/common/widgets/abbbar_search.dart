import 'package:danielabake/core/constants/assets_const.dart' hide Icons;
import 'package:danielabake/core/utils/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final RxBool isExpanded;

  const AppBarSearch({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 36;
    const double collapsedWidth = 36;
    const double expandedWidth = 200;

    return Obx(() {
      return GestureDetector(
        onTap: () {
          if (!isExpanded.value) {
            isExpanded.value = true;
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: height,
          width: isExpanded.value ? expandedWidth : collapsedWidth,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7F3615)),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              if (!isExpanded.value)
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: const AppSvg(asset: Images.search),
                ), // Show only when collapsed
              if (isExpanded.value) ...[
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Search items...",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      autofocus: true,
                      onChanged: onChanged,
                    ),
                  ),
                ),
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: onClear,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.close, size: 18),
                    ),
                  ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
