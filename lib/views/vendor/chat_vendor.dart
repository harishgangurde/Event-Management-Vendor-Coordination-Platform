import 'package:eventtoria/config/app_theme.dart';
import 'package:flutter/material.dart';

class VendorChatScreen extends StatelessWidget {
  const VendorChatScreen({super.key});

  // Assuming you have these assets in your project
  static const String plannerAvatar = 'assets/images/varad.jpg';
  static const String vendorAvatar = 'assets/images/atharva.jpg';

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [_buildChatMessages(context), _buildChatInput(context)]);
  }

  // --- Chat Message Area ---
  Widget _buildChatMessages(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        'text':
            "Hey! Yes, that's correct. Guests will start arriving around 6 PM. We need you to be set up by 5:45 PM latest.",
        'time': '5:32 PM',
        'isVendor': false, // Message from Planner
        'showAvatar': true,
      },
      {
        'text':
            "Got it. We'll be there. Also, wanted to check about the power outlet access near the stage.",
        'time': '5:33 PM',
        'isVendor': true, // Message from Vendor
        'showAvatar': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for input
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _buildMessageBubble(
          context,
          text: msg['text'] as String,
          time: msg['time'] as String,
          isVendor: msg['isVendor'] as bool,
          showAvatar: msg['showAvatar'] as bool,
        );
      },
    );
  }

  Widget _buildMessageBubble(
    BuildContext context, {
    required String text,
    required String time,
    required bool isVendor,
    required bool showAvatar,
  }) {
    final bubbleColor =
        isVendor ? AppTheme.kPrimaryColor : AppTheme.kCardDarkColor;
    final alignment = isVendor ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft:
          isVendor ? const Radius.circular(20) : const Radius.circular(4),
      bottomRight:
          isVendor ? const Radius.circular(4) : const Radius.circular(20),
    );

    final avatar = CircleAvatar(
      radius: 16,
      backgroundImage: AssetImage(isVendor ? vendorAvatar : plannerAvatar),
    );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          textDirection: isVendor ? TextDirection.rtl : TextDirection.ltr,
          children: [
            if (showAvatar) avatar,
            const SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: borderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
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

  // --- Chat Input ---
  Widget _buildChatInput(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.kBackgroundDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: AppTheme.kCardDarkColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: AppTheme.kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}