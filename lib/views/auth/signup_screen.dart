import 'package:eventtoria/views/admin/dashboard_admin.dart';
import 'package:eventtoria/views/planner/dashboard_planner.dart';
import 'package:eventtoria/views/vendor/dashboard_vendor.dart';
import 'package:eventtoria/widgets/role_selector.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _role;
  final List<String> roles = ['Planner', 'Vendor', 'Admin'];
  bool _loading = false;

  final Color primaryColor = const Color(0xFF7F06F9);
  final Color backgroundDark = const Color(0xFF161022);
  final Color cardDark = const Color(0xFF1f1a30);

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

        // Navigate directly to dashboard
        if (_role == 'Planner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PlannerDashboard()),
          );
        } else if (_role == 'Vendor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VendorDashboard()),
          );
        } else if (_role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Sign Up Successful!")));
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
                children: [
                  const Text(
                    "Eventtoria",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  RoleSelector(
                    selectedRole: _role,
                    roles: roles,
                    onRoleSelected: (role) => setState(() => _role = role),
                  ),
                  const SizedBox(height: 24),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
