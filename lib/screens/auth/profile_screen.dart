// screens/auth/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/model/profile.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? userProfile;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchProfile();
  }

  Future<void> _loadUserIdAndFetchProfile() async {
    final userId = await UserSession.getUserId();
    await _fetchUserProfile(userId);
  }

  Future<void> _fetchUserProfile(int userId) async {
    try {
      final response = await AuthService.getUserProfile(userId);

      if (response.containsKey("error")) {
        setState(() {
          errorMessage = response["error"];
          isLoading = false;
        });
      } else if (response.containsKey("data")) {
        setState(() {
          userProfile = Profile.fromJson(response["data"]);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "⚠ خطأ غير متوقع أثناء جلب البيانات!";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "⚠ خطأ أثناء جلب البيانات!";
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (userProfile == null) return;

    if (userProfile!.firstName.isEmpty ||
        userProfile!.lastName.isEmpty ||
        userProfile!.phone.isEmpty ||
        userProfile!.nationality.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ جميع الحقول مطلوبة!")),
      );
      return;
    }

    try {
      final response = await AuthService.updateUserProfile(userProfile!);

      if (response["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم تحديث البيانات بنجاح!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠ خطأ: ${response["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⚠ فشل في تحديث البيانات! حاول مرة أخرى.")),
      );
    }
  }

  void _showEditDialog(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تعديل $field"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "أدخل $field الجديد",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              _saveEditedField(field, controller.text);
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _saveEditedField(String field, String newValue) {
    setState(() {
      if (userProfile == null) return;

      switch (field) {
        case "First Name":
          userProfile!.firstName = newValue;
          break;
        case "Last Name":
          userProfile!.lastName = newValue;
          break;
        case "Phone":
          userProfile!.phone = newValue;
          break;
        case "Nationality":
          userProfile!.nationality = newValue;
          break;
        case "Address":
          userProfile!.address = newValue;
          break;
        case "Gender":
          userProfile!.gender = newValue;
          break;
      }
    });
  }

  Widget _buildProfileCard(String title, String? value,
      {bool editable = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? "غير متوفر"),
        trailing: editable
            ? IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _showEditDialog(title, value ?? ""),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      backgroundColor: const Color(0xFFF4F4F4),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text("معلومات الحساب",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                    const SizedBox(height: 10),
                    _buildProfileCard("Email", userProfile?.email),
                    _buildProfileCard("First Name", userProfile?.firstName,
                        editable: true),
                    _buildProfileCard("Last Name", userProfile?.lastName,
                        editable: true),
                    _buildProfileCard("Phone", userProfile?.phone,
                        editable: true),
                    _buildProfileCard("Nationality", userProfile?.nationality,
                        editable: true),
                    _buildProfileCard("Gender", userProfile?.gender,
                        editable: true),
                    _buildProfileCard("Birthdate", userProfile?.birthdate),
                    _buildProfileCard("Address", userProfile?.address,
                        editable: true),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _updateUserProfile,
                      icon: const Icon(Icons.save),
                      label: const Text("حفظ التغييرات"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
    );
  }
}
