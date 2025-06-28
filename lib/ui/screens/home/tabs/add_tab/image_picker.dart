import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  void showImageSourceActionSheet(BuildContext context,
      Function(File) onImagePicked,) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: isDark ? Colors.white : Colors.black),
                title: Text(appLocalizations.pickFromGallery),
                onTap: () async {
                  Navigator.pop(context);
                  File? image = await pickImage(ImageSource.gallery);
                  if (image != null) {
                    onImagePicked(image);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: isDark ? Colors.white : Colors.black),
                title: Text(appLocalizations.takePhoto),
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
