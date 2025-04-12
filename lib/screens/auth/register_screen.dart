// screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:app_maxall2/services/api_auth.dart';
import 'package:app_maxall2/screens/auth/login_screen.dart';

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
  bool agreeToTerms = false; // ✅ الموافقة على الشروط

  Future<void> _register() async {
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يجب الموافقة على الشروط والأحكام")),
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
      backgroundColor: Colors.white, // 🔹 خلفية بيضاء للتصميم النظيف
      body: Stack(
        children: [
          _buildTopDesign(), // 🔹 الجزء العلوي من التصميم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "إنشاء حساب",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "أهلاً وسهلاً! قم بإنشاء حساب للمتابعة.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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

  /// 🔹 *تصميم الجزء العلوي (الأمواج)*
  Widget _buildTopDesign() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF8A2BE2)], // تدرج Maxall
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

  /// 🔹 *تصميم حقل إدخال البيانات*
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

  /// 🔹 *تصميم حقل كلمة المرور مع إظهار/إخفاء*
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

  /// 🔹 *تصميم خيار الموافقة على الشروط*
  Widget _buildAgreeToTerms() {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          onChanged: (value) {
            setState(() {
              agreeToTerms = value!;
            });
          },
        ),
        const Text("أوافق على الشروط والأحكام"),
      ],
    );
  }

  /// 🔹 *تصميم زر إنشاء الحساب*
  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text("تسجيل",
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  /// 🔹 *تصميم تسجيل الدخول عبر وسائل التواصل الاجتماعي*
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

  /// 🔹 *تصميم أيقونة تسجيل الدخول عبر السوشيال ميديا*
  Widget _buildSocialIcon(String assetPath) {
    return InkWell(
      onTap: () {}, // يمكن استبداله بوظيفة تسجيل الدخول الفعلي
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 22,
        child: Image.asset(assetPath, width: 24),
      ),
    );
  }

  /// 🔹 *تصميم زر الانتقال إلى تسجيل الدخول*
  Widget _buildLoginText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen()), // ✅ الانتقال إلى شاشة تسجيل الدخول
        );
      },
      child: const Text.rich(
        TextSpan(
          text: "لديك حساب بالفعل؟ ",
          style: TextStyle(fontSize: 16, color: Colors.black87),
          children: [
            TextSpan(
              text: "تسجيل الدخول",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
