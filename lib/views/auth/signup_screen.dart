import 'package:eventtoria/views/auth/login_screen.dart';
import 'package:eventtoria/views/admin/dashboard_admin.dart';
import 'package:eventtoria/views/planner/dashboard_planner.dart';
import 'package:eventtoria/views/vendor/dashboard_vendor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  // Controllers for all input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _role;
  final primaryColor = const Color(0xFF7F06F9);
  final backgroundDark = const Color(0xFF161022);
  final cardDark = const Color(0xFF1f1a30);
  final List<String> roles = ['Planner', 'Vendor', 'Admin'];

  bool _loading = false;

  // Show animated role selector
  void _showRoleSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: roles.asMap().entries.map((entry) {
              int index = entry.key;
              String role = entry.value;
              return AnimatedRoleTile(
                role: role,
                delay: Duration(milliseconds: 100 * index),
                onTap: () {
                  setState(() => _role = role);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_role == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a role")));
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Sign Up Successful!")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Sign Up Failed")));
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Eventtoria",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Create your account",
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _customTextField("Name", nameController, "Enter name"),
                  const SizedBox(height: 12),
                  _customTextField(
                    "Email",
                    emailController,
                    "Enter email",
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _customTextField(
                    "Phone",
                    phoneController,
                    "Enter phone",
                    keyboard: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _customTextField(
                    "Password",
                    passwordController,
                    "Enter password",
                    obscure: true,
                  ),
                  const SizedBox(height: 12),
                  _customTextField(
                    "Confirm Password",
                    confirmPasswordController,
                    "Password does not match",
                    obscure: true,
                    validator: (val) {
                      if (val!.isEmpty) return "Enter password again";
                      if (val != passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Role Selector
                  GestureDetector(
                    onTap: _showRoleSelector,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cardDark,
                        borderRadius: BorderRadius.circular(16),
                        border: _role == null
                            ? Border.all(color: Colors.grey)
                            : Border.all(color: primaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _role ?? "Select Role",
                            style: TextStyle(
                              color: _role == null ? Colors.grey : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
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

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField(
    String hint,
    TextEditingController controller,
    String errorText, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: cardDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: validator ?? (val) => val!.isEmpty ? errorText : null,
    );
  }
}

// Animated Role Tile
class AnimatedRoleTile extends StatefulWidget {
  final String role;
  final Duration delay;
  final VoidCallback onTap;

  const AnimatedRoleTile({
    super.key,
    required this.role,
    required this.delay,
    required this.onTap,
  });

  @override
  State<AnimatedRoleTile> createState() => _AnimatedRoleTileState();
}

class _AnimatedRoleTileState extends State<AnimatedRoleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ListTile(
          title: Text(
            widget.role,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
