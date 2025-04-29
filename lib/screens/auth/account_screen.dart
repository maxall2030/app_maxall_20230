import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_maxall2/constants/colors.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/screens/address_screen.dart';
import 'package:app_maxall2/screens/auth/profile_screen.dart';
import 'package:app_maxall2/screens/qr_code_screen.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/model/banners_data.dart';
import 'package:app_maxall2/providers/ThemeProvider.dart';
import 'package:app_maxall2/viewers/widgets/widget_account.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = "جاري التحميل...";
  String userEmail = "";
  String? userProfileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final userId = await UserSession.getUserId();
    final profile = await AuthService.getUserProfile(userId);

    if (profile != null) {
      setState(() {
        userName = profile.name;
        userEmail = profile.email;
        userProfileImage = profile.profileImage;
        isLoading = false;
      });
    } else {
      setState(() {
        userName = "مستخدم غير معروف";
        userEmail = "";
        userProfileImage = null;
        isLoading = false;
      });
    }
  }

  ImageProvider getProfileImage() {
    try {
      if (userProfileImage != null && userProfileImage!.isNotEmpty) {
        final normalizedBase64 = base64Normalize(userProfileImage!);
        final bytes = base64Decode(normalizedBase64);
        return MemoryImage(bytes);
      } else {
        return const AssetImage('assets/User.png');
      }
    } catch (e) {
      print('⚠️ خطأ أثناء فك تشفير الصورة: $e');
      return const AssetImage('assets/User.png');
    }
  }

  String base64Normalize(String base64String) {
    int remainder = base64String.length % 4;
    if (remainder != 0) {
      base64String += '=' * (4 - remainder);
    }
    return base64String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                },
                child: _buildProfileHeader(),
              ),
              _buildPromoBanner(),
              const AccountSummaryWidget(),
              _buildAdvertisement(),
              _buildAccountOptions(context),
              _buildSettings(),
              _buildSignOutButton(),
              _buildSocialLinks(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final ImageProvider imageProvider =
        (userProfileImage != null && userProfileImage!.isNotEmpty)
            ? MemoryImage(base64Decode(base64Normalize(userProfileImage!)))
            : const AssetImage('assets/User.png');

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cover.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 150,
          color: AppColors.primary.withOpacity(0.3),
        ),
        Positioned(
          bottom: 10,
          left: 5,
          right: 5,
          top: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: getProfileImage(),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code,
                      size: 26, color: Colors.deepPurple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const QRCodeScreen(userData: '1234')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            Theme.of(context).scaffoldBackgroundColor
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              Icon(Icons.play_circle_fill, color: Colors.red),
              SizedBox(width: 5),
              Text("Try Free",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Text("Unlimited free delivery",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdvertisement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
        items: bannerImages.map((banner) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(banner.image),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccountOptions(BuildContext context) {
    return _buildListSection("My account", [
      _buildListItem("Account", Icons.person, context, const ProfileScreen()),
      _buildListItem(
          "Addresses", Icons.location_on, context, const AddressScreen()),
    ]);
  }

  Widget _buildSettings() {
    return _buildListSection("Settings", [
      _buildThemeToggle(),
      _buildListItem("Security", Icons.security, null, null),
      _buildListItem("Notifications", Icons.notifications, null, null),
    ]);
  }

  Widget _buildThemeToggle() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return ListTile(
      leading: Icon(Icons.brightness_6, color: AppColors.primary),
      title: Text("الوضع الليلي",
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      trailing: Switch(
        value: isDark,
        onChanged: (value) => themeProvider.toggleTheme(value),
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildListItem(
      String title, IconData icon, BuildContext? context, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(this.context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        if (context != null && screen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        }
      },
    );
  }

  Widget _buildListSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
          const Divider(),
          Column(children: items),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return GestureDetector(
      onTap: () async {
        await UserSession.clearUserId();
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/login');
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("تسجيل الخروج",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(width: 5),
              const Icon(Icons.power_settings_new, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.public, size: 30, color: Colors.grey),
            SizedBox(width: 15),
            Icon(Icons.camera_alt, size: 30, color: Colors.grey),
            SizedBox(width: 15),
            Icon(Icons.alternate_email, size: 30, color: Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text("© 2025 maxall.com. All rights reserved.",
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    );
  }
}
