import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/home_screen.dart';
import 'package:app_maxall2/screens/auth/register_screen.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool rememberMe = false;

  Future<void> _login() async {
    setState(() => isLoading = true);

    final response = await AuthService.loginUser(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (response["status"] == "success") {
      final userId = int.tryParse(response["user"]["id"].toString()) ?? 0;
      await UserSession.saveUserId(userId);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildTopDesign(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(local.login, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                Text(local.welcomeBack, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 30),
                _buildTextField(local.email, Icons.email, emailController),
                const SizedBox(height: 20),
                _buildPasswordField(local),
                const SizedBox(height: 10),
                _buildRememberMe(local),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : _buildLoginButton(local),
                const SizedBox(height: 15),
                _buildRegisterText(context, local),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDesign() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPasswordField(AppLocalizations local) {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: local.password,
        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildRememberMe(AppLocalizations local) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() => rememberMe = value!);
          },
        ),
        Text(local.rememberMe, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildLoginButton(AppLocalizations local) {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(local.login,
          style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildRegisterText(BuildContext context, AppLocalizations local) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      ),
      child: Text.rich(
        TextSpan(
          text: "${local.dontHaveAccount} ",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: local.createAccount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
