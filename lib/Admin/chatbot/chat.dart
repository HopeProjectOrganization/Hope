import 'package:flutter/material.dart';
import 'package:hope/Api/chat/chatApi.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool isTyping = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _controller.clear();
      isTyping = true;
    });

    try {
      final response = await ChatApiService.sendPrompt(text);
      setState(() {
        _messages.add({'role': 'ai', 'text': response.trim()});
        isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'حدث خطأ: ${e.toString()}'});
        isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/chat1.json',
                      width: 400,
                      height: 400,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && isTyping) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 12),
                            child: Lottie.asset(
                              'assets/lottie/typing.json',
                              width: 60,
                              height: 60,
                            ),
                          ),
                        );
                      }

                      final message = _messages[index];
                      final isUser = message['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          textDirection:
                              isUser ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage: AssetImage(
                                isUser ? AppAssets.chatbot1 : AppAssets.chatbot,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xffCFCADA)
                                    : AppColors.lavender,
                                borderRadius: isUser
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(24),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      )
                                    : const BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(16),
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                              ),
                              child: Text(
                                message['text'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask your question...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.lavender,
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.send_rounded,
                        color: AppColors.gray, size: 32),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
