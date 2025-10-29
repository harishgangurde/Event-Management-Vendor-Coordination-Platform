// lib/views/planner/chat_detail_screen.dart
// --- THIS FILE IS COMPLETELY REPLACED ---
// It is now a functional, stateful chat screen instead of a mockup.
// It is based on the logic from 'lib/views/vendor/vendor_chat.dart'.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/views/planner/planner_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

// Define colors for consistency
const Color kPrimaryColor = Color(0xFF7F06F9); // Purple
const Color kAccentPurple = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);
const Color kCardDarkColor = Color(0xFF1E122D);

class ChatDetailScreen extends StatefulWidget {
  final String vendorId;
  final String vendorName;

  const ChatDetailScreen({
    super.key,
    required this.vendorId,
    required this.vendorName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? currentPlannerId = FirebaseAuth.instance.currentUser?.uid;

  late String _chatRoomId;
  String _plannerName = "Planner"; // Default, will be fetched

  @override
  void initState() {
    super.initState();
    if (currentPlannerId != null) {
      _chatRoomId = _getChatRoomId(currentPlannerId!, widget.vendorId);
      _loadPlannerName();
    } else {
      // Handle user not logged in
      _chatRoomId = 'invalid_chat';
    }
  }

  // Load the planner's name to save in the chat doc
  Future<void> _loadPlannerName() async {
    if (currentPlannerId == null) return;
    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentPlannerId)
          .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          _plannerName = doc.data()!['name'] ?? 'Planner';
        });
      }
    } catch (e) {
      // Handle error
    }
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
    if (text.isEmpty || currentPlannerId == null) return;

    _messageController.clear();

    final messageData = {
      'text': text,
      'senderId': currentPlannerId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add message to the subcollection
    await _firestore
        .collection('chats')
        .doc(_chatRoomId)
        .collection('messages')
        .add(messageData);

    // Update the 'lastMessage' doc for chat list previews for BOTH users
    await _firestore.collection('chats').doc(_chatRoomId).set({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'participants': [currentPlannerId, widget.vendorId],
      'plannerName': _plannerName, // Fetched name
      'vendorName': widget.vendorName, // Passed-in name
    }, SetOptions(merge: true));
  }

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
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Just pop, don't clear stack
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vendorName, // Use the passed-in vendorName
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Vendor', // Role
                style: TextStyle(fontSize: 12, color: Colors.white70),
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(_chatRoomId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Say hello to ${widget.vendorName}!',
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
                      // Check if the sender is the current planner
                      final bool isSender =
                          data['senderId'] == currentPlannerId;

                      // Format timestamp
                      String time = 'Sending...';
                      if (data['timestamp'] != null) {
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
            _buildChatInput(),
          ],
        ),
      ),
    );
  }

  // --- Chat Message Bubble ---
  Widget _buildMessageBubble(String text, bool isSender, String time) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isSender ? kAccentPurple : kCardDarkColor,
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

  // --- Input Field ---
  Widget _buildChatInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          color: kCardDarkColor,
          border: Border(top: BorderSide(color: kBackgroundDark, width: 1)),
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
                  color: kPrimaryColor,
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
