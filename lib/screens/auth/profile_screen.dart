import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_maxall2/constants/colors.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/model/profile.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? userProfile;
  bool isLoading = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = await UserSession.getUserId();
    final profile = await AuthService.getUserProfile(userId);
    setState(() {
      userProfile = profile;
      isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    if (userProfile == null) return;
    final result = await AuthService.updateUserProfile(userProfile!);
    final local = AppLocalizations.of(context)!;

    if (result["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.profileUpdated)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${local.error}: ${result["message"]}")),
      );
    }
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = File(pickedFile.path);
        userProfile?.profileImage = base64Encode(bytes);
      });
      _updateProfile();
    }
  }

  void _showImageOptions() {
    final local = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(local.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(local.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(local.viewImage),
              onTap: () {
                Navigator.pop(context);
                _showFullImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(local.deleteImage),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage() {
    final local = AppLocalizations.of(context)!;

    if (userProfile?.profileImage == null ||
        userProfile!.profileImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.noImageAvailable)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: Image.memory(
            base64Decode(base64Normalize(userProfile!.profileImage)),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteImage() {
    final local = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(local.confirmDeleteTitle),
        content: Text(local.confirmDeleteBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(local.cancel)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProfileImage();
            },
            child: Text(local.confirm),
          ),
        ],
      ),
    );
  }

  void _deleteProfileImage() {
    setState(() {
      userProfile?.profileImage = "";
      _selectedImage = null;
    });
    _updateProfile();
  }

  void _editField(String title, String key, String value) {
    final local = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${local.edit} $title"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(local.cancel)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                switch (key) {
                  case "name":
                    userProfile?.name = controller.text;
                    break;
                  case "phone":
                    userProfile?.phone = controller.text;
                    break;
                  case "address":
                    userProfile?.address = controller.text;
                    break;
                  case "nationality":
                    userProfile?.nationality = controller.text;
                    break;
                }
              });
              Navigator.pop(context);
              _updateProfile();
            },
            child: Text(local.save),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider() {
    try {
      if (_selectedImage != null) {
        return FileImage(_selectedImage!);
      } else if (userProfile?.profileImage != null &&
          userProfile!.profileImage.isNotEmpty) {
        final normalized = base64Normalize(userProfile!.profileImage);
        return MemoryImage(base64Decode(normalized));
      }
    } catch (e) {
      debugPrint("⚠️ فشل في تحميل الصورة: $e");
    }
    return const AssetImage('assets/User.png');
  }

  String base64Normalize(String str) {
    int pad = str.length % 4;
    if (pad > 0) str += '=' * (4 - pad);
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.profile),
        backgroundColor: AppColors.primary,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _getImageProvider(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: InkWell(
                          onTap: _showImageOptions,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 18, color: Colors.deepPurple),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildField(local.name, userProfile?.name ?? "", 'name'),
                _buildField(local.email, userProfile?.email ?? "", null),
                _buildField(local.phone, userProfile?.phone ?? "", 'phone'),
                _buildField(local.nationality,
                    userProfile?.nationality ?? "", 'nationality'),
                _buildField(local.address, userProfile?.address ?? "", 'address'),
              ],
            ),
    );
  }

  Widget _buildField(String title, String value, String? key) {
    final local = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value.isEmpty ? local.notAvailable : value),
        trailing: key != null
            ? IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _editField(title, key, value),
              )
            : null,
      ),
    );
  }
}
