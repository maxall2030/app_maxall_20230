import 'package:flutter/material.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/home_screen.dart';
import 'package:app_maxall2/screens/auth/register_screen.dart';
import 'package:app_maxall2/utils/user_session.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ استيراد ملف الألوان

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "تسجيل الدخول",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  "مرحبًا بعودتك! يرجى تسجيل الدخول للمتابعة.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
                _buildTextField(
                    "البريد الإلكتروني", Icons.email, emailController),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 10),
                _buildRememberMe(),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : _buildLoginButton(),
                const SizedBox(height: 15),
                _buildSocialLogin(),
                const SizedBox(height: 20),
                _buildRegisterText(context),
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

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: "كلمة المرور",
        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() {
              rememberMe = value!;
            });
          },
        ),
        Text("تذكرني", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text("تسجيل الدخول",
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon("assets/Facebook.png"),
        const SizedBox(width: 15),
        _buildSocialIcon("assets/x.png"),
        const SizedBox(width: 15),
        _buildSocialIcon("assets/Google.png"),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return InkWell(
      onTap: () {},
      child: CircleAvatar(
        backgroundColor: Theme.of(context).cardColor,
        radius: 22,
        child: Image.asset(assetPath, width: 24),
      ),
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: Text.rich(
        TextSpan(
          text: "ليس لديك حساب؟ ",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: "إنشاء حساب",
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
