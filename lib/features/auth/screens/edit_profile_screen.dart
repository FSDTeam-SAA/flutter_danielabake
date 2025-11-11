import 'package:danielabake/core/common/widgets/app_cached_image.dart';
import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/core/extensions/input_decoration_extensions.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _authCtrl = Get.find<AuthController>();

  // Mock data – replace with real user
  String? profileImageUrl;
  String currentName = "Mr Raja";

  @override
  void initState() {
    super.initState();
    _nameController.text = currentName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await _authCtrl.updateProfile(name: _nameController.text.trim());
    Get.back();
    Get.snackbar(
      "Success",
      "Profile updated successfully!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => profileImageUrl = picked.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3E0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFF8C42),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ────── SCROLLABLE CONTENT ──────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ).copyWith(bottom: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Gap(h: 30),

                    // ─── Profile picture + edit ───
                    Stack(
                      children: [
                        AppCachedImage(
                          imageUrl: profileImageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(60),
                          icon: Icons.person,
                          iconColor: AppColors.primaryBlack,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF007AFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Gap(h: 40),

                    // ─── Full Name ───
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryBlack,
                      ),
                      decoration: context.primaryInputDecoration().copyWith(
                        hintText: "Full Name",
                      ),
                      validator: Validators.name,
                      onFieldSubmitted: (_) => _saveProfile(),
                    ),

                    const Gap(h: 30),
                  ],
                ),
              ),
            ),
          ),

          // ────── FIXED SAVE BUTTON ──────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: PrimaryButton(onApiPressed: _saveProfile, text: "Save"),
          ),
        ],
      ),
    );
  }
}
