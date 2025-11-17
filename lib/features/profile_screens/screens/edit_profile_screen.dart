import 'dart:io';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_cached_image.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/extensions/input_decoration_extensions.dart';
import '../controller/pick_image_controller.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _phonenumberTEController =
  TextEditingController();

  final ProfileController _profileController = Get.find<ProfileController>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phomeNumberFocusNode = FocusNode();

  File? _selectedImage;

  String? imageUrl;

  final PickImageController _pickImageController = PickImageController();

  void _pickImage() async {
    final pickedFile = await _pickImageController.pickImage(context);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  @override
  void initState() {
    setInitial();
    super.initState();
  }

  setInitial(){
    final user = _profileController.userInfo.value;
    if(user != null){
      _nameTEController.text = user.fullName;
      _phonenumberTEController.text = user.phone;
      imageUrl = user.avatarUrl;
    }
  }

  _submit() {
    _profileController.updatePersonalInfo(
      _nameTEController.text,
      _phonenumberTEController.text,
      _selectedImage,   // <-- allow null!
    );
  }



  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              // ─── Profile picture + edit ───
              Center(
                child: Stack(
                  children: [
                    AppCachedImage(
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(60),
                      icon: Icons.person,
                      iconColor: Colors.black,
                      imageFile: _selectedImage,
                      imageUrl: imageUrl,
                      onTap:  _pickImage, // show picked image
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4E9AFF), Color(0xFF0066FF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ─── Full Name ───
              const Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameTEController,
                focusNode: _nameFocusNode,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: context.primaryInputDecoration().copyWith(
                  hintText: "Full Name",
                ),
              ),
              const SizedBox(height: 16),
              // ─── Phone Number ───
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phonenumberTEController,
                focusNode: _phomeNumberFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: context.primaryInputDecoration().copyWith(
                  hintText: "Phone Number",
                ),
              ),
              const SizedBox(height: 274),
              PrimaryButton(text: 'Save', onApiPressed: ()=> _submit()),
            ],
          ),
        ),
      ),
    );
  }
}
