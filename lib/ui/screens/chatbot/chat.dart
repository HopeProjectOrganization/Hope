import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/chat/chatApi.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool isTyping = false;
  String? avatarAsset;

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  void loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarId = prefs.getString("avatarId") ?? "5";
    final asset = Avatar.getAvatarById(avatarId);
    setState(() {
      avatarAsset = asset;
    });
  }

  void _sendMessage() async {
    final appLocalizations = AppLocalizations.of(context)!;
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
        _messages
            .add({'role': 'ai', 'text': appLocalizations.errorSendingMessage});
        isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.chatTitle)),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/chat1.json',
                      width: 300,
                      height: 300,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
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
                                isUser
                                    ? (avatarAsset ??
                                        'assets/avatar/avatar5.png')
                                    : AppAssets.chatbot,
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
                                    ? Theme.of(context).colorScheme.secondary
                                    : AppColors.lavender,
                                borderRadius: isUser
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(24),
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      )
                                    : const BorderRadius.only(
                                        bottomRight: Radius.circular(16),
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                              ),
                              child: Text(
                                message['text'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
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
                      hintText: appLocalizations.askYourQuestion,
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
                        color: isDark ? Colors.black : AppColors.Teal,
                        size: 32),
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
