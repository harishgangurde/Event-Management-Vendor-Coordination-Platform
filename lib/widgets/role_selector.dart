import 'package:flutter/material.dart';

class RoleSelector extends StatefulWidget {
  final String? selectedRole;
  final List<String> roles;
  final ValueChanged<String> onRoleSelected;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.roles,
    required this.onRoleSelected,
  });

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  final Color backgroundDark = const Color(0xFF161022);
  final Color cardDark = const Color(0xFF1f1a30);
  final Color primaryColor = const Color(0xFF7F06F9);

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
            children: widget.roles.asMap().entries.map((entry) {
              int index = entry.key;
              String role = entry.value;
              return AnimatedRoleTile(
                role: role,
                delay: Duration(milliseconds: 100 * index),
                onTap: () {
                  widget.onRoleSelected(role);
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
    return GestureDetector(
      onTap: _showRoleSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.selectedRole == null ? Colors.grey : primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedRole ?? "Select Role",
              style: TextStyle(
                color: widget.selectedRole == null ? Colors.grey : Colors.white,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

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
