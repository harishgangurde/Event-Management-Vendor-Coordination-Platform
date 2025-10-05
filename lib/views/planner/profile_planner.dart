import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'setting_screen.dart'; // Import the setting screen

class ProfilePlannerScreen extends StatefulWidget {
  const ProfilePlannerScreen({super.key});

  @override
  State<ProfilePlannerScreen> createState() => _ProfilePlannerScreenState();
}

class _ProfilePlannerScreenState extends State<ProfilePlannerScreen> {
  // Local file for the picked image
  File? _selectedImage;
  bool isEditing = false;
  final picker = ImagePicker();

  // Asset paths (Updated to your latest file names)
  static const String _defaultAvatarPath = 'assets/images/default.jpg';
  static const String _pastEvent1 = 'assets/images/eventwedding.jpg';
  static const String _pastEvent2 = 'assets/images/gala.jpg';
  static const String _pastEvent3 = 'assets/images/birthday.jpg';
  static const String _pastEvent4 = 'assets/images/product.jpg';

  // Editable fields with default values (Updated with your data)
  String name = 'Rugwed Khairnar';
  String userType = 'Event Planner';
  String joinedDate = 'Joined 2024';
  String phone = '8334645968';
  String email = 'rugwed@gmail.com';
  String dateOfBirth = 'July 28, 2005';
  String address = 'Guthe Lawns, Gangapur Road, Nashik';

  // Controllers for editing state
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();

  // --- Image Picker Function ---
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  // --- Start Editing (Text Fields only) ---
  void _startEditing() {
    // 1. Set controllers with current values
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    addressController.text = address;
    dobController.text = dateOfBirth;

    // 2. Set the editing state, switching the UI from static info to TextFields
    setState(() => isEditing = true);
  }

  void _saveChanges() {
    setState(() {
      name = nameController.text;
      email = emailController.text;
      phone = phoneController.text;
      address = addressController.text;
      dateOfBirth = dobController.text;
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.dispose();
  }

  // Navigation handler for the AppBar settings icon
  void _navigateToSettings() {
    // Navigates to the SettingScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // FIXED: Settings icon is now correctly placed in Profile AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        // FIXED: Using symmetric padding and ensuring sufficient bottom space (72.0)
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 72.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Profile Header Section ---
            buildProfileHeader(theme, primaryColor),
            const SizedBox(height: 30),

            // --- Personal Info Section ---
            buildSectionTitle('Personal Info'),
            isEditing ? buildEditableFields() : buildStaticInfo(),
            const SizedBox(height: 20),

            // --- Past Events Section (Horizontal Scroll) ---
            buildSectionTitle('Past Events'),
            buildPastEventsSection(context),
            const SizedBox(height: 20),

            // --- Account Settings (Simplified) ---
            buildSectionTitle('Account Settings'),
            ListTile(
              leading: Icon(Icons.security, color: primaryColor),
              title: const Text('Privacy & Security'),
              onTap: () {},
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: const Text('Logout'),
              onTap: () {},
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 30),

            // --- Save Button (Conditional) ---
            if (isEditing)
              Padding(
                // Removed bottom padding from this inner Padding widget
                padding: const EdgeInsets.only(top: 0),
                child: FilledButton(
                  onPressed: _saveChanges,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Profile Header Widget (ASSET UPDATED) ---
  Widget buildProfileHeader(ThemeData theme, Color primaryColor) {
    // Determine the tap action: _pickImage() if editing, null otherwise.
    final Function()? onAvatarTap = isEditing ? _pickImage : null;

    return Center(
      child: Column(
        children: [
          // Wrapped the avatar in GestureDetector to enable tap-to-change image
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor, width: 4),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _selectedImage != null
                      ? FileImage(_selectedImage!) as ImageProvider
                      // Using AssetImage for default avatar
                      : const AssetImage(_defaultAvatarPath),
                ),
              ),
              // Conditional visual feedback for editing mode
              child: isEditing
                  ? Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            userType,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            joinedDate,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Only show the Edit Profile button if not currently editing
          if (!isEditing)
            FilledButton(
              onPressed: _startEditing,
              style: FilledButton.styleFrom(backgroundColor: primaryColor),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildStaticInfo() {
    return Column(
      children: [
        buildInfoCardTile(Icons.person, 'Name', name),
        buildInfoCardTile(Icons.phone, 'Phone', phone),
        buildInfoCardTile(Icons.email, 'Email', email),
        buildInfoCardTile(Icons.account_circle, 'User Type', userType),
        buildInfoCardTile(Icons.cake, 'Date of Birth', dateOfBirth),
        // Used home_mini icon for Address
        buildInfoCardTile(Icons.home_mini, 'Address', address),
      ],
    );
  }

  Widget buildInfoCardTile(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableFields() {
    return Column(
      children: [
        textField(Icons.person, 'Full Name', nameController),
        textField(Icons.email, 'Email', emailController),
        textField(Icons.phone, 'Phone', phoneController),
        textField(Icons.cake, 'Date of Birth', dobController),
        // Used home_mini icon for Address
        textField(Icons.home_mini, 'Address', addressController),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: buildInfoCardTile(Icons.account_circle, 'User Type', userType),
        ),
      ],
    );
  }

  Widget textField(
    IconData icon,
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  // --- Past Events Section (FIXED OVERFLOW) ---
  Widget buildPastEventsSection(BuildContext context) {
    final events = [
      {'title': 'Elegant Wedding', 'date': '12/12/2023', 'image': _pastEvent1},
      {'title': 'Corporate Gala', 'date': '11/15/2023', 'image': _pastEvent2},
      {'title': 'Birthday Bash', 'date': '10/20/2023', 'image': _pastEvent3},
      {'title': 'Product Launch', 'date': '09/01/2023', 'image': _pastEvent4},
    ];

    return SizedBox(
      // Reduced height slightly to 190 to guarantee fit,
      // as previous height was causing the overflow.
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final e = events[i];
          return SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flexible Image: takes remaining vertical space after text/spacing is accounted for
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      // FIXED: Use Image.asset
                      child: Image.asset(e['image']!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 4), // Reduced spacing slightly
                Text(
                  e['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  e['date']!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
