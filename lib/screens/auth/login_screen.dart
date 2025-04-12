// screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/home_screen.dart';
import 'package:app_maxall2/screens/auth/register_screen.dart';
import 'package:app_maxall2/utils/user_session.dart';

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

      // ✅ إذا اختار المستخدم "تذكرني"، احفظ معرفه
      if (rememberMe) {
        await UserSession.saveUserId(userId);
      }

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildTopDesign(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "تسجيل الدخول",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "مرحبًا بعودتك! يرجى تسجيل الدخول للمتابعة.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF8A2BE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
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
        prefixIcon: Icon(icon, color: Colors.deepPurple),
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
        prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
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
          onChanged: (value) {
            setState(() {
              rememberMe = value!;
            });
          },
        ),
        const Text("تذكرني"),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
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
        backgroundColor: Colors.grey[200],
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
      child: const Text.rich(
        TextSpan(
          text: "ليس لديك حساب؟ ",
          style: TextStyle(fontSize: 16),
          children: [
            TextSpan(
              text: "إنشاء حساب",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
