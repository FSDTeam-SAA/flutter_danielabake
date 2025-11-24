import 'package:danielabake/core/common/widgets/abbbar_search.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:flutter/material.dart' hide Icons;

class Profile extends StatelessWidget {
  final String name;
  final String imagePath;

  const Profile({
    super.key,
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: Colors.black12),
      // ),
      //padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // top row
          Container(
            //decoration: BoxDecoration(color: Color(0x2EFFB972),borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircleAvatar(
                              backgroundImage: imagePath.isNotEmpty
                                  ? NetworkImage(imagePath)
                                  : const AssetImage(Images.profile1) as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Divider(color: Color(0xFFAD653F),thickness: 1.5,),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
