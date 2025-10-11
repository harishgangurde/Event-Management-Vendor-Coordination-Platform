import 'package:eventtoria/views/planner/dashboard_planner.dart';
import 'package:eventtoria/views/vendor/vendor_dashboard.dart';
import 'package:eventtoria/views/auth/login_screen.dart';
import 'package:eventtoria/widgets/role_selector.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _role;
  final List<String> roles = ['Planner', 'Vendor']; // Admin removed
  bool _loading = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final Color primaryColor = const Color(0xFF7F06F9);
  final Color backgroundDark = const Color(0xFF161022);
  final Color fieldDark = const Color(0xFF241A36);

  late AnimationController _formController;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _formFade = CurvedAnimation(parent: _formController, curve: Curves.easeIn);
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _formController.forward();
  }

  @override
  void dispose() {
    _formController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_role == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a role")));
        return;
      }

      setState(() => _loading = true);

      try {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'role': _role,
          'uid': userCred.user!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Navigate directly to dashboard
        Widget destination =
            _role == 'Planner' ? const DashboardPlanner() : const VendorDashboard();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => destination,
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sign Up Successful!")));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? "Sign Up Failed")));
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  void _navigateToLogin() {
    _formController.reverse().then((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  Widget _customTextField(
    String hint,
    TextEditingController controller,
    String errorText, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    bool isConfirmPassword = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscure
            ? (isConfirmPassword ? _obscureConfirmPassword : _obscurePassword)
            : false,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: fieldDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          suffixIcon: obscure
              ? IconButton(
                  icon: Icon(
                    isConfirmPassword
                        ? (_obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility)
                        : (_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isConfirmPassword) {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      } else {
                        _obscurePassword = !_obscurePassword;
                      }
                    });
                  },
                )
              : null,
        ),
        validator: validator ?? (val) => val!.isEmpty ? errorText : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _navigateToLogin,
        ),
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _formFade,
          child: SlideTransition(
            position: _formSlide,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Eventtoria",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _customTextField("Name", nameController, "Enter name"),
                      _customTextField(
                        "Email",
                        emailController,
                        "Enter email",
                        keyboard: TextInputType.emailAddress,
                      ),
                      _customTextField(
                        "Phone",
                        phoneController,
                        "Enter phone",
                        keyboard: TextInputType.phone,
                      ),
                      _customTextField(
                        "Password",
                        passwordController,
                        "Enter password",
                        obscure: true,
                      ),
                      _customTextField(
                        "Confirm Password",
                        confirmPasswordController,
                        "Password does not match",
                        obscure: true,
                        isConfirmPassword: true,
                        validator: (val) {
                          if (val!.isEmpty) return "Enter password again";
                          if (val != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      RoleSelector(
                        selectedRole: _role,
                        roles: roles, // Only Planner & Vendor
                        onRoleSelected: (role) => setState(() => _role = role),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
