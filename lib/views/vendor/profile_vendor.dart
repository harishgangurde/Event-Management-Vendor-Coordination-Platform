import 'dart:io';
import 'package:eventtoria/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  File? _selectedImage;
  bool isEditing = false;
  final picker = ImagePicker();

  String name = 'Atharva';
  String userType = 'Caterer';
  String joinedDate = 'Joined 2023';
  String phone = '9876543210';
  String email = 'atharva@example.com';
  String address = 'Nashik, Maharashtra';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _startEditing() {
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    addressController.text = address;
    setState(() => isEditing = true);
  }

  void _saveChanges() {
    setState(() {
      name = nameController.text;
      email = emailController.text;
      phone = phoneController.text;
      address = addressController.text;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 72.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProfileHeader(),
          const SizedBox(height: 30),
          buildSectionTitle('Business Info'),
          isEditing ? buildEditableFields() : buildStaticInfo(),
          const SizedBox(height: 20),
          buildSectionTitle('Portfolio'),
          buildPortfolioSection(),
          const SizedBox(height: 30),
          if (isEditing)
            FilledButton(
              onPressed: _saveChanges,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.kPrimaryColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
        ],
      ),
    );
  }

  Widget buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: isEditing ? _pickImage : null,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.kPrimaryColor, width: 4),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _selectedImage != null
                      ? FileImage(_selectedImage!) as ImageProvider
                      : const NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD_Ash2Dj4N9PtV17blvYUe7qVvOsgC78FhI00SEsv3lTXm79zPbeB_wMP5GF0_p0Vp0ykZ0wHxsJgRGVmhJE6EQ-wKdZ53fMXHtiNzxkjCoqUhjNNty4WV6DNXP8M6wP7Zkj3HioboLOWsQ06LnA2zF6fPGjqkat5WqiFcUvcfWWnGDBaaM57iINr-7mZ3YUw9U4VscEoBPXee7QrH10EVIpz-aD-n4xOGgNwObC2mesZ0p1iXPLQAEP4bl3etq4nLHUaZx47kRg'),
                ),
              ),
              child: isEditing
                  ? Center(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 40),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(userType,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(joinedDate,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          if (!isEditing)
            FilledButton(
              onPressed: _startEditing,
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.kPrimaryColor),
              child: const Text('Edit Profile',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget buildStaticInfo() {
    return Column(
      children: [
        buildInfoCardTile(Icons.business, 'Business Name', name),
        buildInfoCardTile(Icons.phone, 'Phone', phone),
        buildInfoCardTile(Icons.email, 'Email', email),
        buildInfoCardTile(Icons.location_on, 'Address', address),
      ],
    );
  }

  Widget buildEditableFields() {
    return Column(
      children: [
        textField(Icons.business, 'Business Name', nameController),
        textField(Icons.email, 'Email', emailController),
        textField(Icons.phone, 'Phone', phoneController),
        textField(Icons.location_on, 'Address', addressController),
      ],
    );
  }

  Widget buildInfoCardTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.kCardDarkColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.kPrimaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(
      IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.kPrimaryColor),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: AppTheme.kCardDarkColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget buildPortfolioSection() {
    final images = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCf_Lzl1Hjb5S11jAbYSAOVsuGYadtVWfDIOhZQJkB2Zu-wVzgDkKeETfNwNyAoJDMBg1WTlcWSYhSfIHgIMryrUXx1H0ftvqxCBdLILOFGW5ADf6JUZvT2a1NgJmF8i5QRQMTPW_I5TxwURAT_Sql-sUaoxWf4_Oafl8y5MLm9UqafUafcHr5oTr5BdAXuP0WMYsB2vYyA9OnvAb5pU3o_E8NKmz9IoLz1s7ERPDmUQFiAoGK1-HP_-gmwJpdcc2oUDjBeZHZZSQ',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAfapVUQ7y0jqz7fxo6eNppTMDVv32X-FnS16MU43OKx4ZShcRLkjWyHEjCiEiWSSN9F3C4dG4T9MwprZQmxq6hdUaOlBEqxwpHy-q3QxVDjp4Z7PopL7K998uBQS7BSHSLmb1JQcuPO20FA83KbYTyW7c8YcEJikXNIXWlAmMreNgpcuMCewts7lXTM576ueEb1WKxfg5rjKSTwLUPN1r_ZZ-aPqAoYxjGhs3sFWBXCYcr87ubtkeR_95Cce_oByJLf_EOOV4XrQ',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDe8RNX9aJTJc0_U_Q2K7nXHlBOErHYBnfhCXCun0ywU39BkJPqGcILbQLYCLZlkFIMdMsOtrfaGXOX5H4xR28xatdcqxxCsoJfn6JmRqMCvg4ytkQuyV-DlNS6l4WoE-K7MSy9KRuRX52a9PSpwQzL3GUwt3T8h7Bix2zIXw-7KLmbI0E-ebhjYZf0cCssePLTvMzeGdA9LNuz7brlhftfwPtdkv6_9U4a0ONlLzHq0Rg',
    ];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(images[index],
                  width: 120, height: 120, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}