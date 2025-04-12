// screens/auth/account_screen.dart
import 'package:flutter/material.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/screens/address_screen.dart';
import 'package:app_maxall2/screens/auth/profile_screen.dart';
import 'package:app_maxall2/screens/qr_code_screen.dart';
import 'package:app_maxall2/viewers/widgets/widget_account.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_maxall2/model/banners_data.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/model/profile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = "جاري التحميل...";
  String userEmail = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final userId = await UserSession.getUserId();
    final response = await AuthService.getUserProfile(userId);

    if (response["status"] == "success") {
      final profile = Profile.fromJson(response["data"]);
      setState(() {
        userName = profile.firstName;
        userEmail = profile.email;
        isLoading = false;
      });
    } else {
      setState(() {
        userName = "مستخدم غير معروف";
        userEmail = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      backgroundColor: const Color.fromARGB(255, 229, 225, 234),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 10,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cover.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 150,
          color: const Color.fromARGB(255, 116, 23, 216).withOpacity(0.3),
        ),
        Positioned(
          bottom: 10,
          left: 5,
          right: 5,
          top: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
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
                  backgroundImage: const AssetImage("images/userimage.jpg"),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.black54),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 73, 28, 236), Colors.white],
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
          autoPlayInterval: const Duration(seconds: 3),
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
      _buildListItem("Addresses", Icons.location_on, context, AddressScreen()),
      _buildListItem("Payment", Icons.credit_card, context, null),
      _buildListItem("Warranty Claims", Icons.build, context, null),
      _buildListItem(
          "QR Code", Icons.qr_code, context, QRCodeScreen(userData: '1234')),
    ]);
  }

  Widget _buildSettings() {
    return _buildListSection("Settings", [
      _buildListItem("Country", Icons.public, null, null),
      _buildListItem("Language", Icons.flag, null, null),
      _buildListItem("Security", Icons.security, null, null),
      _buildListItem("Notifications", Icons.notifications, null, null),
    ]);
  }

  Widget _buildListItem(
      String title, IconData icon, BuildContext? context, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 79, 25, 240)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        if (context != null && screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
    );
  }

  Widget _buildListSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        await UserSession.clearUserId(); // حذف البيانات من SharedPreferences
        if (!mounted) return;
        Navigator.of(context)
            .pushReplacementNamed('/login'); // أو LoginScreen()
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("تسجيل الخروج",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Icon(Icons.power_settings_new, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      children: [
        const Text("Sell with us",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.facebook, size: 30, color: Colors.black54),
            SizedBox(width: 15),
            Icon(Icons.facebook, size: 30, color: Colors.black54),
            SizedBox(width: 15),
            Icon(Icons.facebook, size: 30, color: Colors.black54),
            SizedBox(width: 15),
            Icon(Icons.linked_camera, size: 30, color: Colors.black54),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Text("© 2025 maxall.com. All rights reserved.",
          style: TextStyle(fontSize: 12, color: Colors.black54)),
    );
  }
}
