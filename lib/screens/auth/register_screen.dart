import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/auth/login_screen.dart';
import 'package:app_maxall2/constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;
  bool agreeToTerms = false;

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _register() async {
    final local = AppLocalizations.of(context)!;

    if (!emailRegex.hasMatch(emailController.text.trim())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(local.invalidEmail)));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(local.passwordMismatch)));
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(local.acceptTermsError)));
      return;
    }

    setState(() => isLoading = true);
    final response = await AuthService.registerUser(
      nameController.text,
      emailController.text,
      passwordController.text,
    );
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response["message"])));

    if (response["status"] == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                local.signUp,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(local.createAccount, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 30),
              _buildTextField(local.name, Icons.person, nameController),
              const SizedBox(height: 16),
              _buildTextField(local.email, Icons.email, emailController),
              const SizedBox(height: 16),
              _buildPasswordField(local.password),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(local.confirmPassword),
              const SizedBox(height: 10),
              _buildAgreement(local),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildRegisterButton(local),
              const SizedBox(height: 20),
              _buildLoginLink(local),
            ],
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

  Widget _buildPasswordField(String label) {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
        suffixIcon: IconButton(
          icon:
              Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              setState(() => isPasswordVisible = !isPasswordVisible),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildConfirmPasswordField(String label) {
    return TextField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildAgreement(AppLocalizations local) {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          onChanged: (value) {
            setState(() {
              agreeToTerms = value!;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Text(
            local.termsAndConditions,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
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
      child: Text(
        local.signUp,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildLoginLink(AppLocalizations local) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        ),
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
