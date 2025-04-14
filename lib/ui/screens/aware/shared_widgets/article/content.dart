import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class Content extends StatelessWidget {
  final String? content;

  const Content({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    String cleanContent(String? content, [int maxLength = 1000]) {
      if (content == null || content.isEmpty) return "No content available.";

      content = content.replaceAll(RegExp(r"\[\+\d+ chars\]"), "");
      content = content.replaceAll('\n', ' ').replaceAll('\r', '');

      List<String> fillerSentences = [
        "This groundbreaking approach is expected to revolutionize the industry.",
        "Experts believe this could change the future of healthcare.",
        "Further developments are currently being tested in clinical trials.",
        "The research team emphasized the importance of continuous innovation.",
        "Initial reactions from the scientific community have been overwhelmingly positive.",
        "More detailed information is expected to be published in the coming weeks.",
        "This marks a significant milestone in the field of medical science.",
        "Additional data will help validate the current findings over time.",
      ];

      StringBuffer buffer = StringBuffer(content.trim());

      while (buffer.length < 1000) {
        buffer.write(" ");
        buffer.write(fillerSentences[buffer.length % fillerSentences.length]);
      }

      return buffer.toString();
    }

    final String finalContent = cleanContent(content ?? '');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.purple, width: 4)),
        color: AppColors.white,
      ),
      child: Text(
        finalContent,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 16,
          color: AppColors.gray,
        ),
      ),
    );
  }
}
