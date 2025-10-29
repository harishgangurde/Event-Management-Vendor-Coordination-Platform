// lib/views/vendor/vendor_chat.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // ✅ 1. ADD THIS IMPORT

class VendorChat extends StatefulWidget {
  // These will be passed from the chat list screen
  final String plannerId;
  final String plannerName;

  const VendorChat({
    super.key,
    required this.plannerId,
    required this.plannerName,
  });

  @override
  State<VendorChat> createState() => _VendorChatState();
}

class _VendorChatState extends State<VendorChat> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? currentVendorId = FirebaseAuth.instance.currentUser?.uid;

  late String _chatRoomId;

  @override
  void initState() {
    super.initState();
    // Create a unique, consistent chat room ID for the planner-vendor pair
    _chatRoomId = _getChatRoomId(widget.plannerId, currentVendorId!);
  }

  // Creates a sorted, unique ID for the chat room
  String _getChatRoomId(String plannerId, String vendorId) {
    if (plannerId.hashCode <= vendorId.hashCode) {
      return '$plannerId\_$vendorId';
    } else {
      return '$vendorId\_$plannerId';
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || currentVendorId == null) return;

    _messageController.clear();

    final messageData = {
      'text': text,
      'senderId': currentVendorId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add message to the subcollection
    await _firestore
        .collection('chats')
        .doc(_chatRoomId)
        .collection('messages')
        .add(messageData);

    // Update the 'lastMessage' doc for chat list previews
    await _firestore.collection('chats').doc(_chatRoomId).set({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'participants': [widget.plannerId, currentVendorId],
      'plannerName': widget.plannerName,
      // You'd also store vendorName here, fetched from vendor's profile
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A102E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.plannerName, // Use planner name
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              "Event Planner", // Role
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.call, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(_chatRoomId)
                  .collection('messages')
                  .orderBy(
                    'timestamp',
                    descending: true,
                  ) // Show newest at bottom
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Start the conversation!',
                      style: GoogleFonts.poppins(color: Colors.white54),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true, // Start from the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final doc = messages[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final bool isSender = data['senderId'] == currentVendorId;

                    // Format timestamp
                    String time = 'Sending...';
                    if (data['timestamp'] != null) {
                      // ✅ 2. THIS IS THE FIX
                      time = DateFormat(
                        'hh:mm a',
                      ).format((data['timestamp'] as Timestamp).toDate());
                    }

                    return _buildMessageBubble(
                      data['text'] ?? '',
                      isSender,
                      time,
                    );
                  },
                );
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF9B62FF) : const Color(0xFF2B1C4C),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isSender
                ? const Radius.circular(16)
                : const Radius.circular(4),
            bottomRight: isSender
                ? const Radius.circular(4)
                : const Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
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
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
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
          border: Border(top: BorderSide(color: Color(0xFF3B217A), width: 1)),
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
                onSubmitted: (_) => _sendMessage(),
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
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
