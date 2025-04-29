import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_maxall2/constants/colors.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/model/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<ProfileScreen> {
  Profile? userProfile;
  bool isLoading = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userId = await UserSession.getUserId();
    final profile = await AuthService.getUserProfile(userId);
    setState(() {
      userProfile = profile;
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        userProfile?.profileImage = base64Encode(bytes);
        _selectedImage = File(pickedFile.path);
      });
      _updateUserProfile();
    }
  }

  Future<void> _deleteImage() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد حذف الصورة"),
        content: const Text("هل أنت متأكد أنك تريد حذف الصورة الشخصية؟"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("إلغاء")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("حذف")),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        userProfile?.profileImage = "";
        _selectedImage = null;
      });
      _updateUserProfile();
    }
  }

  Future<void> _updateUserProfile() async {
    if (userProfile == null) return;
    await AuthService.updateUserProfile(userProfile!);
  }

  void _editField(String fieldName, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تعديل $fieldName"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              _saveEditedField(fieldName, controller.text);
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _saveEditedField(String field, String value) {
    setState(() {
      switch (field) {
        case 'الاسم':
          userProfile?.name = value;
          break;
        case 'رقم الجوال':
          userProfile?.phone = value;
          break;
        case 'الجنسية':
          userProfile?.nationality = value;
          break;
        case 'العنوان':
          userProfile?.address = value;
          break;
      }
    });
    _updateUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الملف الشخصي"),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _deleteImage,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (userProfile?.profileImage.isNotEmpty ?? false)
                                  ? MemoryImage(
                                      base64Decode(base64Normalize(
                                          userProfile!.profileImage)),
                                    )
                                  : const AssetImage('assets/User.png')
                                      as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.edit, color: Colors.deepPurple),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField("الاسم", userProfile?.name ?? ""),
                  _buildEditableField(
                      "البريد الإلكتروني", userProfile?.email ?? "",
                      editable: false),
                  _buildEditableField("رقم الجوال", userProfile?.phone ?? ""),
                  _buildEditableField(
                      "الجنسية", userProfile?.nationality ?? ""),
                  _buildEditableField("العنوان", userProfile?.address ?? ""),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableField(String label, String value,
      {bool editable = true}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value.isEmpty ? "غير متوفر" : value),
        trailing: editable
            ? IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _editField(label, value),
              )
            : null,
      ),
    );
  }

  String base64Normalize(String input) {
    int remainder = input.length % 4;
    if (remainder != 0) {
      input += '=' * (4 - remainder);
    }
    return input;
  }
}
