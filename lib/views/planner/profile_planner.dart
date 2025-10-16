import 'dart:io';
import 'package:eventtoria/views/planner/planner_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'setting_screen.dart'; // Import the setting screen
import 'package:intl/intl.dart'; // REQUIRED for date formatting

class ProfilePlanner extends StatefulWidget {
  const ProfilePlanner({super.key});

  @override
  State<ProfilePlanner> createState() => _ProfilePlannerScreenState();
}

class _ProfilePlannerScreenState extends State<ProfilePlanner> {
  File? _selectedImage;
  bool isEditing = false;
  final picker = ImagePicker();

  static const String _defaultAvatarPath = 'assets/images/default.jpg';
  static const String _pastEvent1 = 'assets/images/eventwedding.jpg';
  static const String _pastEvent2 = 'assets/images/gala.jpg';
  static const String _pastEvent3 = 'assets/images/birthday.jpg';
  static const String _pastEvent4 = 'assets/images/product.jpg';

  // State Variables
  String name = 'Rugwed Khairnar';
  String userType = 'Event Planner';
  String joinedDate = 'Joined 2024';
  String phone = '8334645968';
  String email = 'rugwed@gmail.com';
  String dateOfBirth = 'July 28, 2005';
  String address = 'Guthe Lawns, Gangapur Road, Nashik';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  // 🌟 Date Picker Logic 🌟
  Future<void> _selectDate() async {
    DateTime initialDate;
    try {
      initialDate = DateFormat('MMMM d, yyyy').parse(dateOfBirth);
    } catch (e) {
      initialDate = DateTime(2005, 7, 28); // Default date if parsing fails
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // Customize date picker theme if needed
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary, // Primary color
              onPrimary: Colors.white, // Text color on primary color
              onSurface: Colors.black, // Text color on background
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('MMMM d, yyyy').format(pickedDate);
      setState(() {
        dateOfBirth = formattedDate;
        dobController.text = formattedDate;
      });
    }
  }
  // 🌟 END: Date Picker Logic 🌟

  void _startEditing() {
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    addressController.text = address;
    dobController.text =
        dateOfBirth; // Initialize controller with current value
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

  void _navigateToSettings() {
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
        // ✅ FIX: Use pushAndRemoveUntil to reset the stack and go to DashboardPlanner
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // This ensures the user lands on the main tab container (DashboardPlanner)
            // with a clean navigation stack, guaranteeing the tabs load correctly.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPlanner()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 72.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileHeader(theme, primaryColor),
            const SizedBox(height: 30),
            buildSectionTitle('Personal Info'),
            isEditing ? buildEditableFields() : buildStaticInfo(),
            const SizedBox(height: 20),
            buildSectionTitle('Past Events'),
            buildPastEventsSection(context),
            const SizedBox(height: 20),
            if (isEditing)
              Padding(
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

  Widget buildProfileHeader(ThemeData theme, Color primaryColor) {
    final Function()? onAvatarTap = isEditing ? _pickImage : null;

    return Center(
      child: Column(
        children: [
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
                      : const AssetImage(_defaultAvatarPath),
                ),
              ),
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
        textField(
          Icons.person,
          'Full Name',
          nameController,
          isDateField: false,
        ),
        textField(Icons.email, 'Email', emailController, isDateField: false),
        textField(Icons.phone, 'Phone', phoneController, isDateField: false),
        // Date of Birth field now calls the date picker
        textField(
          Icons.cake,
          'Date of Birth',
          dobController,
          isDateField: true,
        ),
        textField(
          Icons.home_mini,
          'Address',
          addressController,
          isDateField: false,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: buildInfoCardTile(Icons.account_circle, 'User Type', userType),
        ),
      ],
    );
  }

  // 🌟 UPDATED: Added isDateField parameter to conditionally add onTap behavior
  Widget textField(
    IconData icon,
    String label,
    TextEditingController controller, {
    required bool isDateField,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        readOnly: isDateField, // Makes DOB field read-only to force date picker
        onTap: isDateField ? _selectDate : null, // Opens date picker on tap
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

  Widget buildPastEventsSection(BuildContext context) {
    final events = [
      {
        'title': 'Elegant Wedding',
        'date': '12/12/2023',
        'image': _pastEvent1,
        'description':
            'A royal wedding ceremony with floral decorations and a grand banquet.',
        'venue': 'Royal Palace Banquet Hall, Mumbai',
        'organizer': 'Shivkumar Events Pvt. Ltd.',
      },
      {
        'title': 'Corporate Gala',
        'date': '11/15/2023',
        'image': _pastEvent2,
        'description':
            'An elegant corporate evening with awards and networking opportunities.',
        'venue': 'Grand Hyatt, Pune',
        'organizer': 'Elite Corporate Planners',
      },
      {
        'title': 'Birthday Bash',
        'date': '10/20/2023',
        'image': _pastEvent3,
        'description':
            'A fun and vibrant birthday party with themed decorations and activities.',
        'venue': 'Skyline Rooftop Lounge, Pune',
        'organizer': 'DreamPlanners Co.',
      },
      {
        'title': 'Product Launch',
        'date': '09/01/2023',
        'image': _pastEvent4,
        'description':
            'A product launch event with media coverage, presentations, and demos.',
        'venue': 'Tech Park Convention Center, Bengaluru',
        'organizer': 'Innovate India Group',
      },
    ];

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final e = events[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EventDetailScreen(event: e)),
              );
            },
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.asset(e['image']!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
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
            ),
          );
        },
      ),
    );
  }
}

// New screen to show event details (Remains unchanged)
class EventDetailScreen extends StatelessWidget {
  final Map<String, String> event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(event['image']!, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              'Date: ${event['date']!}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Venue: ${event['venue']!}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Organizer: ${event['organizer']!}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${event['description']!}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
