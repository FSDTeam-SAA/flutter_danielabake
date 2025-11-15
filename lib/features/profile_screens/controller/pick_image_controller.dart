import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PickImageController {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery or camera
  Future<File?> pickImage(BuildContext context) async {
    File? selectedFile;

    // Show bottom sheet to choose source
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (image != null) selectedFile = File(image.path);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) selectedFile = File(image.path);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );

    return selectedFile;
  }
}
