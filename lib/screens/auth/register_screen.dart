import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/auth/login_screen.dart';
import 'package:app_maxall2/constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool agreeToTerms = false;

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _register() async {
    final local = AppLocalizations.of(context)!;
    final email = emailController.text.trim();

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.invalidEmail)),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.passwordMismatch)),
      );
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.acceptTermsError)),
      );
      return;
    }

    setState(() => isLoading = true);
    final response = await AuthService.registerUser(
      nameController.text,
      email,
      passwordController.text,
    );
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["message"])),
    );

    if (response["status"] == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildTopBackground(theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              padding: const EdgeInsets.only(top: 200, bottom: 20),
              children: [
                Text(local.signUp,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Text(local.createAccount, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 30),
                _buildTextField(local.name, Icons.person, nameController),
                const SizedBox(height: 20),
                _buildTextField(local.email, Icons.email, emailController),
                const SizedBox(height: 20),
                _buildPasswordField(local),
                const SizedBox(height: 20),
                _buildConfirmPasswordField(local),
                const SizedBox(height: 10),
                _buildAgreeToTerms(theme, local),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildRegisterButton(local),
                const SizedBox(height: 30),
                _buildLoginText(context, local),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBackground(ThemeData theme) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 40, left: 30, child: _buildCircle(60)),
            Positioned(top: 20, right: 50, child: _buildCircle(40)),
            Positioned(top: 100, left: 80, child: _buildCircle(25)),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
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
            color: Colors.grey,
          ),
          onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations local) {
    return TextField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: local.confirmPassword,
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildAgreeToTerms(ThemeData theme, AppLocalizations local) {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          activeColor: AppColors.primary,
          onChanged: (value) => setState(() => agreeToTerms = value!),
        ),
        Expanded(
          child: Text(local.termsAndConditions,
              style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AppLocalizations local) {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(local.signUp,
          style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  Widget _buildLoginText(BuildContext context, AppLocalizations local) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        },
        child: Text.rich(
          TextSpan(
            text: "${local.alreadyHaveAccount} ",
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: local.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
