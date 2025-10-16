import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart'; // <--- NEW IMPORT
import 'dart:io';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController guestCountController = TextEditingController();

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
    dateController.dispose();
    timeController.dispose();
    venueController.dispose();
    budgetController.dispose();
    guestCountController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildAISuggestionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label clicked!')));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.2),
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: primaryColor,
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name
            buildSectionTitle('Event Name'),
            const SizedBox(height: 8.0),
            _buildTextField(
              controller: eventNameController,
              hintText: 'e.g., Sarah\'s Birthday Bash',
            ),
            const SizedBox(height: 24.0),

            // Date & Time
            buildSectionTitle('Date & Time'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: dateController,
                    hintText: 'mm/dd/yyyy',
                    readOnly: true,
                    onTap: _selectDate,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: primaryColor.withOpacity(0.7),
                      ),
                      onPressed: _selectDate,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildTextField(
                    controller: timeController,
                    hintText: '-:--',
                    readOnly: true,
                    onTap: _selectTime,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.access_time,
                        color: primaryColor.withOpacity(0.7),
                      ),
                      onPressed: _selectTime,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Venue
            buildSectionTitle('Venue'),
            const SizedBox(height: 8.0),
            _buildTextField(
              controller: venueController,
              hintText: 'e.g., The Grand Ballroom',
            ),
            const SizedBox(height: 24.0),

            // Budget & Guest Count
            buildSectionTitle('Budget & Guest Count'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: budgetController,
                    hintText: '₹500,000',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildTextField(
                    controller: guestCountController,
                    hintText: '250',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Upload Images
            buildSectionTitle('Upload Images'),
            const SizedBox(height: 8.0),

            // --- FIXED BLOCK: Using DottedBorder package ---
            GestureDetector(
              onTap: _pickImages,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(0),
                dashPattern: const [8, 4], // Dash pattern for dashed effect
                color: primaryColor, // Primary color for the dash lines
                strokeWidth: 1.5,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Click to upload or drag and drop',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'SVG, PNG, JPG or GIF (MAX. 800x400px)',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- END FIXED BLOCK ---
            _selectedImages.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImages[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 24.0),

            // AI Suggestions
            buildSectionTitle('AI Suggestions'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildAISuggestionButton(
                    context,
                    label: 'Suggest Themes',
                    icon: Icons.auto_awesome,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: _buildAISuggestionButton(
                    context,
                    label: 'Suggest Tasks',
                    icon: Icons.lightbulb_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),

            // Create Event Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Creating event: ${eventNameController.text}',
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
