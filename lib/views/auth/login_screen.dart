import 'package:eventtoria/views/admin/dashboard_admin.dart';
import 'package:eventtoria/views/planner/dashboard_planner.dart';
import 'package:eventtoria/views/vendor/dashboard_vendor.dart';
import 'package:eventtoria/views/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'forgot_pass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Select Role';
  final List<String> roles = ['Planner', 'Vendor', 'Admin'];

  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || selectedRole == 'Select Role') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email, password, and select role"),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid);

      DocumentSnapshot userDoc = await userRef.get();

      // Auto-create Firestore document if missing
      if (!userDoc.exists) {
        await userRef.set({
          'name': '',
          'email': email,
          'role': selectedRole,
          'uid': userCred.user!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      String role = (await userRef.get()).get('role');

      if (role != selectedRole) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selected role does not match your account"),
          ),
        );
        setState(() => _loading = false);
        return;
      }

      // Navigate based on role
      if (role == 'Planner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PlannerDashboard()),
        );
      } else if (role == 'Vendor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VendorDashboard()),
        );
      } else if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showRoleSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161022),
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
                  setState(() => selectedRole = role);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161022),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Eventtoria Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Email
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1f1a30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1f1a30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Role Selector
              GestureDetector(
                onTap: _showRoleSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1f1a30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedRole,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5b13ec),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _loading ? null : login,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Signup Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
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
