import 'package:flutter/material.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/auth/login_screen.dart';
import 'package:app_maxall2/constants/colors.dart'; // ✅ استيراد ملف الألوان

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool agreeToTerms = false;

  Future<void> _register() async {
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يجب الموافقة على الشروط والأحكام")),
      );
      return;
    }

    setState(() => isLoading = true);
    final response = await AuthService.registerUser(
      nameController.text,
      emailController.text,
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
                  "إنشاء حساب",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "أهلاً وسهلاً! قم بإنشاء حساب للمتابعة.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
                _buildTextField("الاسم", Icons.person, nameController),
                const SizedBox(height: 20),
                _buildTextField(
                    "البريد الإلكتروني", Icons.email, emailController),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 10),
                _buildAgreeToTerms(),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : _buildRegisterButton(),
                const SizedBox(height: 15),
                _buildSocialLogin(),
                const SizedBox(height: 20),
                _buildLoginText(context),
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
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
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

  Widget _buildAgreeToTerms() {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() {
              agreeToTerms = value!;
            });
          },
        ),
        Text("أوافق على الشروط والأحكام",
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text("تسجيل",
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon("assets/facebook.png"),
        const SizedBox(width: 15),
        _buildSocialIcon("assets/twitter.png"),
        const SizedBox(width: 15),
        _buildSocialIcon("assets/google.png"),
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

  Widget _buildLoginText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Text.rich(
        TextSpan(
          text: "لديك حساب بالفعل؟ ",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: "تسجيل الدخول",
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
