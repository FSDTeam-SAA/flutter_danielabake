import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/common/widgets/app_logo.dart';
import 'package:danielabake/core/common/widgets/appbar_text.dart';
import 'package:danielabake/core/common/widgets/text_with_view_all_button.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/core/utils/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/theme/gap.dart';

import '../../../core/common/widgets/cart.dart';
import '../widgets/grid_layout.dart';
import '../widgets/popular_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarText(text: 'Place an order'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                AppBarSearch(),
                const SizedBox(width: 16),
                const Cart(),
              ],
            ),
          )
        ],
      ),

      body: SingleChildScrollView( // 👈 FIX: Make content scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.h20,
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: Image.asset(Images.discount, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              TextWithViewAllButton(text: 'Select by Category', onTap: () {}),
              const SizedBox(height: 24),
              TextWithViewAllButton(text: 'Popular Item', onTap: () {}),

              // 👇 Your GridLayout should fit inside scroll view
              GridLayout(
                mainAxisExtent: 260,
                itemCount: 6,
                itemBuilder: (_, index) {
                  return FoodCard(
                    imagePath: Images.cookie1,
                    title: 'Chocolate Croissant',
                    price: '3.50',
                    onAdd: () {
                      print('Added to cart');
                    },
                    onFavorite: () {
                      print('Toggled favorite');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
