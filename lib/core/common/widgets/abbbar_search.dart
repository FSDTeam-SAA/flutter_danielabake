import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/core/utils/app_svg.dart';
import 'package:flutter/cupertino.dart';

class AppBarSearch extends StatelessWidget {
  const AppBarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF7F3615)),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AppSvg(asset: Images.search),
      )
    );
  }
}
