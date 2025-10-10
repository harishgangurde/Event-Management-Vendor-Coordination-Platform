import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorChat extends StatefulWidget {
  const VendorChat({super.key});

  @override
  State<VendorChat> createState() => _VendorChatState();
}

class _VendorChatState extends State<VendorChat> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          "Hi, I'm Sophia, your event planner. I'm excited to help you plan your special day! To get started, could you tell me a bit about the event you’re planning?",
      'isSender': false,
      'time': '10:00 AM'
    },
    {
      'text':
          "Hi Sophia, I’m planning a wedding for about 150 guests. The date is set for August 12th, and we’re looking for a venue with a rustic or garden theme.",
      'isSender': true,
      'time': '10:01 AM'
    },
    {
      'text':
          "That sounds lovely! I’ll start looking for venues that match your criteria. In the meantime, do you have any specific locations or areas in mind?",
      'isSender': false,
      'time': '10:02 AM'
    },
    {
      'text':
          "We’re open to suggestions, but we’d prefer something within a 50-mile radius of the city center.",
      'isSender': true,
      'time': '10:03 AM'
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isSender': true,
        'time': 'Now',
      });
    });

    _messageController.clear();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sophia Carter",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              "Event Planner",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.call, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg['text'], msg['isSender'], msg['time']);
              },
            ),
          ),
          _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isSender, String time) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF9B62FF) : const Color(0xFF2B1C4C),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isSender ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isSender ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF2B1C4C),
          border: Border(
            top: BorderSide(color: Color(0xFF3B217A), width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: GoogleFonts.poppins(color: Colors.white60),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF9B62FF),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
