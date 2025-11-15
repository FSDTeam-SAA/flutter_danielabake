import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
