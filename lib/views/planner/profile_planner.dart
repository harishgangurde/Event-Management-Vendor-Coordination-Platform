// lib/views/planner/profile_planner.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/config/app_theme.dart';
import 'package:eventtoria/views/planner/planner_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? _profileImageUrl;
  bool isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;
  final picker = ImagePicker();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();

  // State Variables (getters for controllers)
  String get name => nameController.text;
  String get userType => 'Event Planner';
  String get joinedDate => 'Joined 2024';
  String get phone => phoneController.text;
  String get email => emailController.text;
  String get dateOfBirth => dobController.text;
  String get address => addressController.text;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? 'Your Name';
          emailController.text = data['email'] ?? 'your.email@example.com';
          phoneController.text = data['phone'] ?? '';
          addressController.text = data['address'] ?? '';
          dobController.text = data['dob'] ?? '';
          _profileImageUrl = data['profileImageUrl'];
        });
      } else {
         setState(() {
            nameController.text = 'Your Name';
            emailController.text = user.email ?? 'your.email@example.com';
         });
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: ${e.toString()}')),
        );
      }
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(user.uid); 

      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': downloadUrl});

      setState(() {
        _profileImageUrl = downloadUrl;
        _selectedImage = null;
      });

       if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
       }

    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
        );
      }
    } finally {
      if(mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate;
    try {
      initialDate = DateFormat('MMMM d, yyyy').parse(dobController.text);
    } catch (e) {
      initialDate = DateTime(2000, 1, 1); 
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.kPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.kPrimaryColor,
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
        dobController.text = formattedDate;
      });
    }
  }

  void _startEditing() {
    setState(() => isEditing = true);
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': nameController.text,
        'email': emailController.text, 
        'phone': phoneController.text,
        'address': addressController.text,
        'dob': dobController.text,
      }, SetOptions(merge: true)); 

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
      setState(() => isEditing = false);

    } catch (e) {
       if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${e.toString()}')),
        );
       }
    } finally {
       if(mounted) {
        setState(() => _isSaving = false);
       }
    }
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
    // 💡 FIX: 'theme' is defined here
    final theme = Theme.of(context); 
    final primaryColor = AppTheme.kPrimaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (isEditing) {
              setState(() {
                isEditing = false;
                _loadProfileData(); 
              });
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPlanner()),
                (route) => false,
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ).copyWith(bottom: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileHeader(theme, primaryColor),
                  const SizedBox(height: 30),
                  buildSectionTitle('Personal Info'),
                  // 💡 FIX: Pass the 'theme' object here
                  isEditing ? buildEditableFields(theme) : buildStaticInfo(theme),
                  const SizedBox(height: 20),
                  buildSectionTitle('Past Events'),
                  buildPastEventsSection(context), 
                  const SizedBox(height: 20),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: FilledButton(
                        onPressed: _isSaving ? null : _saveChanges,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
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

    ImageProvider displayImage;
    if (_selectedImage != null) {
      displayImage = FileImage(_selectedImage!);
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      displayImage = NetworkImage(_profileImageUrl!);
    } else {
      displayImage = const AssetImage('assets/images/default.jpg');
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 4),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: displayImage,
                      onError: (exception, stackTrace) {
                        if (mounted) {
                          setState(() {
                            _profileImageUrl = null;
                          });
                        }
                      },
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
                if (_isSaving && isEditing)
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
              ],
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
              style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white
              ),
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

  // 💡 FIX: Pass 'theme'
  Widget buildStaticInfo(ThemeData theme) {
    return Column(
      children: [
        buildInfoCardTile(theme, Icons.person, 'Name', name),
        buildInfoCardTile(theme, Icons.phone, 'Phone', phone.isEmpty ? 'Not set' : phone),
        buildInfoCardTile(theme, Icons.email, 'Email', email),
        buildInfoCardTile(theme, Icons.account_circle, 'User Type', userType),
        buildInfoCardTile(theme, Icons.cake, 'Date of Birth', dateOfBirth.isEmpty ? 'Not set' : dateOfBirth),
        buildInfoCardTile(theme, Icons.home_mini, 'Address', address.isEmpty ? 'Not set' : address),
      ],
    );
  }

  // 💡 FIX: Pass 'theme'
  Widget buildInfoCardTile(ThemeData theme, IconData icon, String label, String value) {
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

  // 💡 FIX: Pass 'theme'
  Widget buildEditableFields(ThemeData theme) {
    return Form(
      child: Column(
        children: [
          textField(
            theme, // 💡 FIX: Pass theme
            Icons.person,
            'Full Name',
            nameController,
            isDateField: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          textField(
            theme, // 💡 FIX: Pass theme
            Icons.email, 
            'Email', 
            emailController, 
            isDateField: false,
            readOnly: true, 
          ),
          textField(theme, Icons.phone, 'Phone', phoneController, isDateField: false), // 💡 FIX: Pass theme
          textField(
            theme, // 💡 FIX: Pass theme
            Icons.cake,
            'Date of Birth',
            dobController,
            isDateField: true,
          ),
          textField(
            theme, // 💡 FIX: Pass theme
            Icons.home_mini,
            'Address',
            addressController,
            isDateField: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            // 💡 FIX: Pass theme
            child: buildInfoCardTile(theme, Icons.account_circle, 'User Type', userType),
          ),
        ],
      ),
    );
  }

  // 💡 FIX: Add 'theme' parameter and use it
  Widget textField(
    ThemeData theme,
    IconData icon,
    String label,
    TextEditingController controller, {
    required bool isDateField,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: isDateField || readOnly,
        onTap: isDateField ? _selectDate : null,
        // 💡 FIX: Use theme
        style: TextStyle(color: readOnly ? Colors.grey : theme.colorScheme.onSurface),
        decoration: InputDecoration(
          // 💡 FIX: Use theme
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          labelText: label,
          // 💡 FIX: Use theme
          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // 💡 FIX: Use theme
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2)
          ),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey.withOpacity(0.1) : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }

  // This section remains hardcoded
  Widget buildPastEventsSection(BuildContext context) {
    final events = [
      {
        'title': 'Elegant Wedding',
        'date': '12/12/2023',
        'image': 'assets/images/eventwedding.jpg',
        'description':
            'A royal wedding ceremony with floral decorations and a grand banquet.',
        'venue': 'Royal Palace Banquet Hall, Mumbai',
        'organizer': 'Shivkumar Events Pvt. Ltd.',
      },
      {
        'title': 'Corporate Gala',
        'date': '11/15/2023',
        'image': 'assets/images/gala.jpg',
        'description':
            'An elegant corporate evening with awards and networking opportunities.',
        'venue': 'Grand Hyatt, Pune',
        'organizer': 'Elite Corporate Planners',
      },
      {
        'title': 'Birthday Bash',
        'date': '10/20/2023',
        'image': 'assets/images/birthday.jpg',
        'description':
            'A fun and vibrant birthday party with themed decorations and activities.',
        'venue': 'Skyline Rooftop Lounge, Pune',
        'organizer': 'DreamPlanners Co.',
      },
      {
        'title': 'Product Launch',
        'date': '09/01/2023',
        'image': 'assets/images/product.jpg',
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
                        child: Image.asset(e['image']!, fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
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

// This is the hardcoded detail screen for past events
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
            Image.asset(event['image']!, fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                height: 200,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
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