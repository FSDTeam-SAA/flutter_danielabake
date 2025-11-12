import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProfileCard(
          name: 'Mr. Raja',
          imagePath: 'assets/images/profile.png',
          orders: '45',
          favorites: '12',
          onEdit: () {
            print('Edit clicked');
          },
        ),
      ),
    );
  }
}
