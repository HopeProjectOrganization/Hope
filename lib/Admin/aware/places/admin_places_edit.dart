import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart'; // استيراد Firebase Storage
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  String? _imageUrl; // لتخزين رابط الصورة بعد الرفع
  File? imageFile;

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
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void saveHospital() async {
    if (_formKey.currentState!.validate() && imageFile != null) {
      final uploadedUrl = await _uploadImageToFirebase(imageFile!);
      if (uploadedUrl != null) {
        _imageUrl = uploadedUrl;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image")),
        );
        return;
      }

      final hospitalData = {
        "hospitalName": nameController.text,
        "hospitalNumber": phoneController.text,
        "hospitalAddress": addressController.text,
        "hospitalLocation": "https://maps.app.goo.gl/xyz",
        "hospitalWebsite": mapLinkController.text,
        "Logo": _imageUrl
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
          const SnackBar(content: Text("تم حفظ المستشفى بنجاح")),
        );
        Navigator.pop(context, true); // ارجع ومعاك قيمة true
      } else {
        print('فشل الإرسال: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل حفظ المستشفى")),
        );
      }

      print(hospitalData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hospital info submitted successfully!")),
      );
      Navigator.pop(context, true); // ترجع مع قيمة true
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields and pick an image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Hospital",
            style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Hospital Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mapLinkController,
                decoration:
                    const InputDecoration(labelText: 'Google Maps Link'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // عرض صورة أو زر اختيار صورة (زي الموجود في News Editor)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image, color: Colors.deepPurple),
                        label: const Text('Pick Image from Gallery',
                            style: TextStyle(color: Colors.deepPurple)),
                      ),
                      const SizedBox(height: 10),
                      if (imageFile != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(imageFile!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        )
                      else
                        SizedBox(
                          height: 180,
                          child: Center(
                            child: Text('No image selected',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                title: 'Add Hospital',
                onClick: saveHospital,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
