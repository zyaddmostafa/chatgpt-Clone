import 'dart:io';
import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isFromUser;
  final DateTime timestamp;
  final String? imagepath; // Add this for File objects

  const ChatMessage({
    super.key,
    required this.message,
    required this.isFromUser,
    required this.timestamp,
    this.imagepath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ChatGPT Avatar (only shown for ChatGPT messages)
          if (!isFromUser)
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: ClipOval(
                  child: SvgPicture.asset(
                    Assets.assetsSvgsAvatarChatGPT,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // Add spacing for user messages to align with ChatGPT messages
          if (isFromUser) SizedBox(width: 48),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isFromUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                if (imagepath != null) _buildImageWidget(context),

                // Add spacing between image and text if both exist
                if (imagepath != null && message.isNotEmpty)
                  SizedBox(height: 8),
                // Message bubble
                message.isNotEmpty
                    ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isFromUser
                                ? AppColor.primaryColor
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show image if available

                          // Message text
                          Text(
                            message,
                            style: AppTextstyles.font14Regular.copyWith(
                              color: isFromUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                    : SizedBox.shrink(),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _formatTimestamp(timestamp),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          // Spacing at the end for visual balance (for user messages)
          if (isFromUser) SizedBox(width: 0) else SizedBox(width: 48),
        ],
      ),
    );
  }

  // Widget to build image with constraints
  Widget _buildImageWidget(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
        maxHeight: 200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imagepath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              width: 150,
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, color: Colors.red),
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Format timestamp as "hh:mm a" (e.g., "3:45 PM")
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final hourFormatted = hour == 0 ? 12 : hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hourFormatted:$minute $period';
  }
}
