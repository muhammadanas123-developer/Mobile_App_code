import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../shared/chat_message_model.dart';
import '../data/ai_service.dart';

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessageModel>>((ref) {
  return ChatMessagesNotifier();
});

class ChatMessagesNotifier extends StateNotifier<List<ChatMessageModel>> {
  ChatMessagesNotifier()
      : super([
    ChatMessageModel(
      id: 'c_init',
      text: 'Hello! I am your Beauty ai assistant. How can I help personalize your skincare or styling routine today?',
      sender: 'ai',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    )
  ]);

  void sendMessage(String text, String sender) {
    state = [
      ...state,
      ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        sender: sender,
        timestamp: DateTime.now(),
      ),
    ];
  }
}

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AIService _aiService = AIService();

  bool _isTyping = false;

  final ScrollController _scrollController = ScrollController();

  final List<String> _suggestedPrompts = [
    'Skincare for oily skin?',
    'What haircut fits round faces?',
    'How often should I exfoliate?',
    'Best product for fine hair?',
  ];

  Future<void> _submitMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();

    ref.read(chatMessagesProvider.notifier).sendMessage(text, 'user');

    _scrollToBottom();

    setState(() {
      _isTyping = true;
    });

    try {
      final reply = await _aiService.chat(text);

      if (!mounted) return;

      setState(() {
        _isTyping = false;
      });

      ref.read(chatMessagesProvider.notifier).sendMessage(
        reply.isNotEmpty ? reply : 'Sorry, I could not generate a response.',
        'ai',
      );

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isTyping = false;
      });

      ref.read(chatMessagesProvider.notifier).sendMessage(
        'Unable to connect to AI service. Please try again.',
        'ai',
      );

      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Beauty ai Chat'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Suggested Prompts
            if (messages.length <= 1) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggested Prompts',
                      style: AppTextStyles.label(color: AppColors.textMedium),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _suggestedPrompts.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final prompt = _suggestedPrompts[index];
                          return ActionChip(
                            label: Text(prompt),
                            backgroundColor: AppColors.surface,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.borderMD),
                            labelStyle: AppTextStyles.bodySmall(
                                color: AppColors.primaryDark),
                            side: const BorderSide(color: AppColors.border),
                            onPressed: () => _submitMessage(prompt),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
            ],

            // Message list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return _buildTypingIndicator();
                  }

                  final msg = messages[index];
                  final isUser = msg.sender == 'user';

                  return _buildMessageBubble(msg.text, isUser);
                },
              ),
            ),

            // Input panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: _submitMessage,
                      decoration: InputDecoration(
                        hintText: 'Ask ai beauty advisor...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.borderLG,
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryDark,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.surface, size: 20),
                      onPressed: () async {
                        if (_messageController.text.trim().isEmpty) return;

                        final userMessage = _messageController.text;

                        _messageController.clear();

                        // Add user message using provider
                        ref.read(chatMessagesProvider.notifier).sendMessage(
                          userMessage,
                          'user',
                        );

                        _scrollToBottom();

                        setState(() {
                          _isTyping = true;
                        });

                        try {
                          final reply = await _aiService.chat(userMessage);

                          if (!mounted) return;

                          setState(() {
                            _isTyping = false;
                          });

                          // Add AI reply using provider
                          ref.read(chatMessagesProvider.notifier).sendMessage(
                            reply.isNotEmpty ? reply : 'Sorry, I could not generate a response.',
                            'ai',
                          );

                          _scrollToBottom();
                        } catch (e) {
                          if (!mounted) return;

                          setState(() {
                            _isTyping = false;
                          });

                          // Add error message using provider
                          ref.read(chatMessagesProvider.notifier).sendMessage(
                            'Unable to connect to AI service. Please try again.',
                            'ai',
                          );

                          _scrollToBottom();
                        }
                      },
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

  Widget _buildMessageBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.primaryDark, size: 16),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryDark : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 16),
                ),
                border: isUser ? null : Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Text(
                text,
                style: AppTextStyles.bodyMedium(
                  color: isUser ? AppColors.surface : AppColors.textDark,
                ).copyWith(height: 1.45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.primaryDark, size: 16),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.textLight,
        shape: BoxShape.circle,
      ),
    );
  }
}