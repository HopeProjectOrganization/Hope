import 'package:flutter/material.dart';
import 'package:hope/Api/chat/chatApi.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
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
      appBar: AppBar(
        title: Text(appLocalizations.chatTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Lottie.asset(
                        'assets/lottie/chat1.json',
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
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
                                width: MediaQuery.of(context).size.width * 0.08,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isUser)
                                  Image.asset(
                                    AppAssets.chatbot,
                                    width:
                                        MediaQuery.of(context).size.width * .04,
                                    height: MediaQuery.of(context).size.height *
                                        .04,
                                    fit: BoxFit.cover,
                                  ),
                                if (!isUser) const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                color: isUser
                                          ? AppColors.Teal.withOpacity(0.9)
                                          : AppColors.cloudi.withOpacity(0.9),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: Radius.circular(
                                            isUser ? 16 : 0), // Tail direction
                                        bottomRight: Radius.circular(
                                            isUser ? 0 : 16), // Tail direction
                                      ),
                                    ),
                              child: Text(
                                message['text'] ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isUser
                                            ? AppColors.white
                                            : AppColors.dark,
                                      ),
                                    ),
                            ),
                                ),
                                if (isUser) const SizedBox(width: 8),
                                if (isUser)
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      avatarAsset ??
                                          'assets/avatar/avatar5.png',
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: appLocalizations.askYourQuestion,
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.yellow,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: isDark ? AppColors.dark : AppColors.Teal,
                        size: 26,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
