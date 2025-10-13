import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../services/gemini_service.dart';

// Define the colors used for consistency
const Color kPrimaryColor = Color(0xFF7F06F9);
const Color kAccentPurple = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);
const Color kCardDarkColor = Color(0xFF1E122D);

// Data structure to hold messages
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isStreaming;

  ChatMessage(this.text, {required this.isUser, this.isStreaming = false});
}

class EventtoriaAIScreen extends StatefulWidget {
  const EventtoriaAIScreen({super.key});

  @override
  State<EventtoriaAIScreen> createState() => _EventtoriaAIScreenState();
}

class _EventtoriaAIScreenState extends State<EventtoriaAIScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showMenuCards = true;

  final List<ChatMessage> _messages = [
    ChatMessage(
      "Hello! I'm Eventtoria AI, your event planning expert. Ask me for recommendations or start with a prompt below!",
      isUser: false,
    ),
  ];

  // --- API CALL LOGIC ---
  void _sendMessage() async {
    final userMessageText = _controller.text.trim();
    if (userMessageText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(userMessageText, isUser: true));
    });
    _controller.clear();

    _scrollToEnd();

    final aiIndex = _messages.length;
    setState(() {
      _messages.add(ChatMessage('', isUser: false, isStreaming: true));
    });

    try {
      final stream = _geminiService.sendMessageStream(userMessageText);
      String fullResponse = '';

      await for (var chunk in stream) {
        fullResponse += chunk;
        setState(() {
          _messages[aiIndex] = ChatMessage(
            fullResponse,
            isUser: false,
            isStreaming: true,
          );
        });
        _scrollToEnd();
      }

      setState(() {
        _messages[aiIndex] = ChatMessage(
          fullResponse,
          isUser: false,
          isStreaming: false,
        );
      });
    } catch (e) {
      setState(() {
        _messages[aiIndex] = ChatMessage(
          'Error: Could not connect to Eventtoria AI. Please check your API key and internet connection.',
          isUser: false,
          isStreaming: false,
        );
      });
    }
    _scrollToEnd();
  }

  // --- TASK CARD HANDLER ---
  void _handleTaskCardTap(String promptTitle) {
    setState(() {
      _showMenuCards = false;
    });

    _controller.text = promptTitle;
    _sendMessage();
  }

  // --- UI HELPER METHODS ---

  Widget _buildTaskCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: kCardDarkColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.isUser;
    final theme = Theme.of(context);

    // Style the Markdown rendering for the dark theme
    final markdownStyleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      // Style for regular paragraphs (p)
      p: const TextStyle(color: Colors.white, fontSize: 16),
      // Style for strong text (e.g., **Local Talent:**)
      strong: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      // Style for headings (h3/###)
      h3: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: kAccentPurple,
        height: 1.5,
      ),
      // Remove default bullet point padding/indentation
      listIndent: 20,
      listBullet: const TextStyle(color: Colors.white),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : kCardDarkColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),

        // --- CONDITIONAL WIDGET BASED ON ROLE ---
        child: isUser
            ? Text(
                // Use Text for user messages
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : MarkdownBody(
                // Use MarkdownBody for AI responses
                data: message.text.isEmpty && message.isStreaming
                    ? 'Typing...'
                    : message.text,
                selectable: true,
                styleSheet: markdownStyleSheet,
              ),
        // ----------------------------------------
      ),
    );
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tasks = [
      {
        'icon': Icons.location_on_outlined,
        'color': kAccentPurple,
        'title': 'Venue Recommendations: Near Me',
        'subtitle': 'Find the perfect venue for your event',
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'color': kPrimaryColor,
        'title': 'Budget Optimization: Current Event',
        'subtitle': 'Optimize your budget for maximum impact',
      },
      {
        'icon': Icons.emoji_objects_outlined,
        'color': kAccentPurple,
        'title': 'Theme Ideas: New Suggestions',
        'subtitle': 'Get personalized theme ideas',
      },
      {
        'icon': Icons.checklist_rtl,
        'color': kPrimaryColor,
        'title': 'Task Reminders: Next 3 Days',
        'subtitle': 'Stay on track with your planning',
      },
    ];

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        colorScheme: const ColorScheme.dark().copyWith(primary: kPrimaryColor),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Eventtoria AI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // CONTENT AREA (Switches between Menu Cards and Chat History)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hi, Planner! How can I assist you today?',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 24),

                    // CONDITIONAL VIEW
                    if (_showMenuCards) ...[
                      ...tasks
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildTaskCard(
                                icon: task['icon'] as IconData,
                                title: task['title'] as String,
                                subtitle: task['subtitle'] as String,
                                iconColor: task['color'] as Color,
                                onTap: () =>
                                    _handleTaskCardTap(task['title'] as String),
                              ),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 120),
                    ] else ...[
                      ..._messages
                          .map((message) => _buildMessageBubble(message))
                          .toList(),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),

            // FIXED INPUT FIELD at the bottom
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBackgroundDark,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: kCardDarkColor,
                        prefixIcon: Icon(
                          Icons.mic,
                          color: Colors.grey.shade500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
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
                      icon: const Icon(Icons.arrow_upward, color: Colors.white),
                      onPressed: _sendMessage,
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
}
