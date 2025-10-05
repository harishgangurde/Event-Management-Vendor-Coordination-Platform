import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // Ensure widgets are accessible for AssetImage

// Define colors for consistency
const Color kPrimaryColor = Color(0xFF7F06F9); // Purple
const Color kAccentPurple = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);
const Color kCardDarkColor = Color(0xFF1E122D);

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // IMPORTANT: Updated to use local asset paths
  // Make sure you place images named 'vendor_avatar.png' and 'planner_avatar.png'
  // inside your 'assets/images/' directory.
  static const String vendorAvatar = 'assets/images/atharva.jpg';
  static const String plannerAvatar = 'assets/images/varad.jpg';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: kPrimaryColor,
          surface: kCardDarkColor,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rhythm & Hues',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 8),
                  SizedBox(width: 4),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(children: [_buildChatMessages(), _buildChatInput(context)]),
      ),
    );
  }

  // --- Chat Message Area ---
  Widget _buildChatMessages() {
    // Message data structure: {text, time, isPlanner, showAvatar}
    final List<Map<String, dynamic>> messages = [
      {
        'text':
            "Hi there! We are so excited to be part of Anand & Priya's wedding. Just confirming, the event starts at 6 PM, right?",
        'time': '5:30 PM',
        'isPlanner': false,
        'showAvatar': true,
      },
      {
        'text':
            "Hey! Yes, that's correct. Guests will start arriving around 6 PM. We need you to be set up by 5:45 PM latest.",
        'time': '5:32 PM',
        'isPlanner': true,
        'showAvatar': true,
      },
      {
        'text':
            "Got it. We'll be there. Also, wanted to check about the power outlet access near the stage.",
        'time': '5:33 PM',
        'isPlanner': false,
        'showAvatar': true,
      },
      // Mock typing indicator
      {
        'text': '...',
        'time': '',
        'isPlanner': false,
        'showAvatar': true,
        'isTyping': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: 250,
      ), // Padding to avoid input field overlap
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _buildMessageBubble(
          context,
          text: msg['text'] as String,
          time: msg['time'] as String,
          isPlanner: msg['isPlanner'] as bool,
          showAvatar: msg['showAvatar'] as bool,
          isTyping: msg.containsKey('isTyping') && msg['isTyping'] as bool,
        );
      },
    );
  }

  Widget _buildMessageBubble(
    BuildContext context, {
    required String text,
    required String time,
    required bool isPlanner,
    required bool showAvatar,
    bool isTyping = false,
  }) {
    final bubbleColor = isPlanner ? kAccentPurple : kCardDarkColor;
    final alignment = isPlanner ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isPlanner
          ? const Radius.circular(20)
          : const Radius.circular(4),
      bottomRight: isPlanner
          ? const Radius.circular(4)
          : const Radius.circular(20),
    );

    // FIXED: Use AssetImage instead of NetworkImage
    final avatar = CircleAvatar(
      radius: 16,
      backgroundImage: AssetImage(isPlanner ? plannerAvatar : vendorAvatar),
    );

    // Typing indicator animation
    if (isTyping) {
      return Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isPlanner && showAvatar) avatar,
              const SizedBox(width: 8),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: borderRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 600 + i * 200),
                        builder: (context, opacity, child) => Opacity(
                          opacity: opacity,
                          child: const CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          textDirection: isPlanner ? TextDirection.rtl : TextDirection.ltr,
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

  // --- AI Quick Replies and Input ---
  Widget _buildChatInput(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: kBackgroundDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI Quick Replies Section
            Container(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: kAccentPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'AI Quick Replies',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          // Hide quick replies
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickReplyButton(
                          context,
                          'Confirm setup by 5:45 PM',
                          () {},
                        ),
                        const SizedBox(width: 8),
                        _buildQuickReplyButton(
                          context,
                          'Ask about their arrival',
                          () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Text Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: kCardDarkColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic, color: Colors.white),
                        onPressed: () {},
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
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Handle send action
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyButton(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return ActionChip(
      label: Text(
        text,
        style: TextStyle(color: kAccentPurple, fontWeight: FontWeight.w600),
      ),
      backgroundColor: kAccentPurple.withOpacity(0.15),
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: kAccentPurple.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}
