import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminAddHospitalScreen extends StatefulWidget {
  final Map<String, dynamic>? hospitalData;
  static const routeName = '/adminEdit';

  const AdminAddHospitalScreen({super.key, this.hospitalData});

  @override
  State<AdminAddHospitalScreen> createState() => _AdminAddHospitalScreenState();
}

class _AdminAddHospitalScreenState extends State<AdminAddHospitalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mapLinkController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? _imageUrl;
  File? imageFile;
  late AppLocalizations localizations;
  late ThemeProvider themeProvider;

  bool get isEdit => widget.hospitalData != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      nameController.text = widget.hospitalData!['hospitalName'] ?? '';
      websiteController.text = widget.hospitalData!['hospitalWebsite'] ?? '';
      phoneController.text = widget.hospitalData!['hospitalNumber'] ?? '';
      mapLinkController.text = widget.hospitalData!['hospitalLocation'] ?? '';
      addressController.text = widget.hospitalData!['hospitalAddress'] ?? '';
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref =
          FirebaseStorage.instance.ref().child('hospital_images/$fileName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void saveHospital() async {
    if (_formKey.currentState!.validate()) {
      if (!isEdit && imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.pleasePickImage)),
        );
        return;
      }

      if (imageFile != null) {
        final uploadedUrl = await _uploadImageToFirebase(imageFile!);
        if (uploadedUrl != null) {
          _imageUrl = uploadedUrl;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.imageUploadFailed)),
          );
          return;
        }
      }

      final hospitalData = {
        "hospitalName": nameController.text,
        "hospitalNumber": phoneController.text,
        "hospitalAddress": addressController.text,
        "hospitalLocation": mapLinkController.text,
        "hospitalWebsite": websiteController.text,
        "logo": _imageUrl ?? widget.hospitalData?['logo'] ?? ''
      };

      final url = isEdit
          ? Uri.parse('http://${MyApp.IP}/Places/${widget.hospitalData!['id']}')
          : Uri.parse('http://${MyApp.IP}/Places/addPlace');

      final response = await (isEdit
          ? http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(hospitalData),
            )
          : http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(hospitalData),
            ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit
                ? localizations.hospitalUpdated
                : localizations.hospitalAdded),
          ),
        );
        Navigator.pop(context, true);
      } else {
        print('فشل: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.hospitalSaveFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;
    themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? localizations.editHospital : localizations.addHospital,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.Teal,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(localizations.hospitalName, nameController),
              buildTextField(localizations.website, websiteController),
              buildTextField(localizations.phoneNumber, phoneController,
                  inputType: TextInputType.phone),
              buildTextField(localizations.googleMapsLink, mapLinkController),
              buildTextField(localizations.address, addressController),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image, color: Colors.deepPurple),
                label: Text(
                  localizations.pickImageFromGallery,
                  style: const TextStyle(color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageFile != null
                    ? Image.file(imageFile!,
                        height: 200, width: double.infinity, fit: BoxFit.cover)
                    : (isEdit &&
                            (widget.hospitalData?['logo']?.isNotEmpty ?? false))
                        ? Image.network(widget.hospitalData!['logo'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover)
                        : Container(
                            height: 200,
                            color: themeProvider.isDark()
                                ? AppColors.dark.withOpacity(0.1)
                                : Colors.grey.shade200,
                            child: Center(
                              child: Text(localizations.noImageSelected,
                                  style: const TextStyle(color: Colors.grey)),
                            ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                title: isEdit
                    ? localizations.saveChanges
                    : localizations.addHospital,
                onClick: saveHospital,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.trim().isEmpty
            ? localizations.required
            : null,
      ),
    );
  }
}
