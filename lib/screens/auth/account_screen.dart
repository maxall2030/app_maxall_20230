import 'dart:convert';
import 'package:app_maxall2/main.dart';
import 'package:app_maxall2/utils/language_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_maxall2/constants/colors.dart';
import 'package:app_maxall2/components/bottom_nav_bar.dart';
import 'package:app_maxall2/screens/address_screen.dart';
import 'package:app_maxall2/screens/auth/profile_screen.dart';
import 'package:app_maxall2/screens/qr_code_screen.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/model/profile.dart';
import 'package:app_maxall2/model/banners_data.dart';
import 'package:app_maxall2/providers/ThemeProvider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Profile? userProfile;
  bool isLoading = true;

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

  ImageProvider _getProfileImageProvider(String? base64String) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        final normalized = _normalizeBase64(base64String);
        return MemoryImage(base64Decode(normalized));
      }
    } catch (_) {}
    return const AssetImage("assets/User.png");
  }

  String _normalizeBase64(String str) {
    int mod = str.length % 4;
    if (mod > 0) str += '=' * (4 - mod);
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()),
                      ),
                      child: _buildHeader(local),
                    ),
                    _buildPromoBanner(local),
                    _buildAdvertisement(),
                    const SizedBox(height: 8),
                    _buildAccountOptions(local),
                    _buildSettings(local, themeProvider),
                    _buildSignOutButton(local),
                    _buildSocialLinks(),
                    _buildFooter(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations local) {
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
        Container(height: 150, color: AppColors.primary.withOpacity(0.3)),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      _getProfileImageProvider(userProfile?.profileImage),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userProfile?.name ?? local.profile,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(userProfile?.email ?? "",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code, color: Colors.deepPurple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const QRCodeScreen(userData: '1234')),
                    );
                  },
                )
              ],
            ),
          ),
        )
      ],
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

  Widget _buildPromoBanner(AppLocalizations local) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.play_circle_fill, color: Colors.red),
            const SizedBox(width: 5),
            Text(local.promoTryFree,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          Text(local.promoDelivery,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAccountOptions(AppLocalizations local) {
    return _buildListSection(local.account, [
      _buildListItem(local.profile, Icons.person, const ProfileScreen()),
      _buildListItem(local.addresses, Icons.location_on, const AddressScreen()),
    ]);
  }

  Widget _buildSettings(AppLocalizations local, ThemeProvider themeProvider) {
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return _buildListSection(local.settings, [
      ListTile(
        leading: Icon(Icons.brightness_6, color: AppColors.primary),
        title: Text(local.darkMode),
        trailing: Switch(
          value: isDark,
          onChanged: themeProvider.toggleTheme,
          activeColor: AppColors.primary,
        ),
      ),
      ListTile(
        leading: Icon(Icons.language, color: AppColors.primary),
        title: Text(local.language),
        trailing: DropdownButton<String>(
          value: Localizations.localeOf(context).languageCode,
          items: const [
            DropdownMenuItem(value: 'ar', child: Text("العربية")),
            DropdownMenuItem(value: 'en', child: Text("English")),
          ],
          onChanged: (String? newLang) async {
            if (newLang != null) {
              await LanguageSession.saveLanguage(newLang);
              MyApp.setLocale(context, Locale(newLang));
            }
          },
        ),
      ),
    ]);
  }

  Widget _buildListItem(String title, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
    );
  }

  Widget _buildListSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          Column(children: items),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(AppLocalizations local) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          await UserSession.clearUserId();
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed('/login');
        },
        icon: const Icon(Icons.power_settings_new),
        label: Text(local.logout),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.facebook, color: Colors.grey, size: 30),
            SizedBox(width: 15),
            Icon(Icons.alternate_email, color: Colors.grey, size: 30),
            SizedBox(width: 15),
            Icon(Icons.public, color: Colors.grey, size: 30),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text("\u00a9 2025 maxall.com. جميع الحقوق محفوظة.",
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    );
  }
}
