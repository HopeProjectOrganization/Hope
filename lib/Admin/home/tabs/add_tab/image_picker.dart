import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  void showImageSourceActionSheet(
      BuildContext context, Function(File) onImagePicked) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  File? image = await pickImage(ImageSource.gallery);
                  if (image != null) {
                    onImagePicked(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  File? image = await pickImage(ImageSource.camera);
                  if (image != null) {
                    onImagePicked(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
