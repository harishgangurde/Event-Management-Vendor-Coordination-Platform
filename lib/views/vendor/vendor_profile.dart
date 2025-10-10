import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vendor_setting.dart';

class VendorProfile extends StatefulWidget {
  const VendorProfile({super.key});

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  File? _profileImage;
  String vendorName = "Sophia Carter";
  String description = "Wedding Photographer";
  double rating = 4.8;
  int totalReviews = 120;

  // Dynamic Calendar Data
  final int monthDays = 31;
  final int currentMonth = 7; // July (example)
  Set<int> bookedDates = {4, 11, 18, 25}; // Example booked days

  @override
  void initState() {
    super.initState();
    _loadVendorData();
  }

  Future<void> _loadVendorData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorName = prefs.getString('vendorName') ?? vendorName;
      description = prefs.getString('description') ?? description;
      totalReviews = prefs.getInt('totalReviews') ?? totalReviews;
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        _profileImage = File(imagePath);
      }
      // If you later want to persist bookedDates, you'd load them here too.
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', picked.path);
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VendorSetting()),
    );
  }

  // Toggle availability dynamically (for testing or demo)
  void _toggleDate(int day) {
    setState(() {
      if (bookedDates.contains(day)) {
        bookedDates.remove(day);
      } else {
        bookedDates.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A102E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Vendor Profile",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const NetworkImage(
                              "https://images.unsplash.com/photo-1603415526960-f7e0328e2c7a")
                          as ImageProvider,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9B62FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              vendorName,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  "$rating (${totalReviews} reviews)",
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Pricing Section
            _sectionTitle("Pricing"),
            const SizedBox(height: 8),
            _priceTile("Base Package", "\$500"),
            _priceTile("Additional Hours", "\$150/hr"),
            const SizedBox(height: 20),

            // Availability Section
            _sectionTitle("Availability"),
            const SizedBox(height: 12),
            _calendarView(),
            const SizedBox(height: 20),

            // Portfolio Section
            _sectionTitle("Portfolio"),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _portfolioImage("https://images.unsplash.com/photo-1504208434309-cb69f4fe52b0"),
                _portfolioImage("https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e"),
                _portfolioImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d"),
                _portfolioImage("https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e"),
              ],
            ),
            const SizedBox(height: 25),

            // Ratings & Reviews
            _sectionTitle("Ratings & Reviews"),
            const SizedBox(height: 12),
            _ratingsSection(),
            const SizedBox(height: 25),

            // AI Pricing Suggestion
            _sectionTitle("AI Pricing Suggestion"),
            const SizedBox(height: 10),
            _aiPricingCard(),
            const SizedBox(height: 30),

            // Manage Profile Button
            ElevatedButton.icon(
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageProfilePage()),
                );
                if (updated == true) _loadVendorData();
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: Text(
                "Manage Profile",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B62FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ─────────────────── UI Components ───────────────────
  Widget _sectionTitle(String title) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _priceTile(String label, String price) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2B1C4C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.white70)),
            Text(price, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _calendarView() {
    DateTime today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B1C4C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "July 2025",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(
              monthDays,
              (i) {
                int day = i + 1;
                bool isBooked = bookedDates.contains(day);
                bool isToday = (today.day == day && today.month == currentMonth);

                return GestureDetector(
                  onTap: () => _toggleDate(day),
                  child: Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isBooked
                          ? const Color(0xFF9B62FF)
                          : isToday
                              ? Colors.greenAccent
                              : const Color(0xFF3B217A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$day",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _portfolioImage(String url) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(url, fit: BoxFit.cover),
      );

  Widget _ratingsSection() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B1C4C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$rating", style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _ratingBar(5, 0.7),
            _ratingBar(4, 0.2),
            _ratingBar(3, 0.1),
            const SizedBox(height: 12),
            _reviewTile("Olivia Bennett", "Sophia was amazing! She captured our special day perfectly."),
            const SizedBox(height: 10),
            _reviewTile("Ava Jasper", "Professional, friendly, and the photos turned out stunning."),
          ],
        ),
      );

  Widget _ratingBar(int stars, double progress) => Row(
        children: [
          Text("$stars ★", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: const Color(0xFF9B62FF),
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      );

  Widget _reviewTile(String name, String review) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(review, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
        ],
      );

  Widget _aiPricingCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B1C4C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Based on your event details, AI suggests a budget of \$500–\$900 for photography.",
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B62FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Accept", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
}

// ─────────────────────────────
// Manage Profile Page (edit vendor info)
// ─────────────────────────────
class ManageProfilePage extends StatefulWidget {
  const ManageProfilePage({super.key});

  @override
  State<ManageProfilePage> createState() => _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name.text = prefs.getString('vendorName') ?? "Sophia Carter";
      _desc.text = prefs.getString('description') ?? "Wedding Photographer";
      _mobile.text = prefs.getString('mobile') ?? "+91 9876543210";
      _email.text = prefs.getString('email') ?? "sophia.carter@example.com";
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vendorName', _name.text.trim());
    await prefs.setString('description', _desc.text.trim());
    await prefs.setString('mobile', _mobile.text.trim());
    await prefs.setString('email', _email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A102E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Manage Profile",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _field("Vendor Name", _name),
                      const SizedBox(height: 15),
                      _field("Description", _desc, maxLines: 3),
                      const SizedBox(height: 15),
                      _field("Mobile No.", _mobile),
                      const SizedBox(height: 15),
                      _field("Email Address", _email),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B217A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _saveProfile();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Profile updated successfully!")),
                                  );
                                  Navigator.pop(context, true); // return true to parent
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9B62FF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("Save", style: GoogleFonts.poppins(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _field(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2B1C4C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return "Please enter $label";
        if (label == "Email Address" && !v.contains('@')) return "Enter a valid email";
        return null;
      },
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _mobile.dispose();
    _email.dispose();
    super.dispose();
  }
}
