import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF7F06F9);
    final backgroundDark = const Color(0xFF190F23);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About Eventtoria",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white, // Set title color to white
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mission
            const Text(
              "Our Mission",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Eventtoria's mission is to revolutionize event planning by providing an all-in-one platform that simplifies the process, enhances creativity, and ensures seamless execution. We aim to empower event organizers and vendors with innovative tools and resources, fostering collaboration and delivering exceptional event experiences.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Vision
            const Text(
              "Our Vision",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We envision a future where event planning is effortless and enjoyable for everyone. Eventtoria aspires to be the leading platform for event management, known for its user-friendly interface, advanced AI capabilities, and commitment to excellence. We strive to connect organizers and vendors seamlessly, creating a vibrant ecosystem that drives innovation and success in the event industry.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Key Features
            const Text(
              "Key Features",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                featureItem(Icons.auto_awesome, "AI-Powered Assistant", primaryColor),
                featureItem(Icons.groups, "Vendor Coordination", primaryColor),
                featureItem(Icons.event, "Event Management Tools", primaryColor),
                featureItem(Icons.palette, "Creative Resources", primaryColor),
              ],
            ),
            const SizedBox(height: 24),
            // Contact Us
            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.grey[400], height: 1.5),
                children: [
                  const TextSpan(text: "For inquiries, support, or feedback, please reach out to us at "),
                  TextSpan(
                    text: "support@eventtoria.com",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: ". We are always happy to hear from you!"),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget featureItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
