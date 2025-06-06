import 'package:chatgpt/core/utils/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/feature/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:chatgpt/feature/home/data/models/chat_model.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final chatHistory = cubit.chatHistory;

        if (state is HomeCubitLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatHistory.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No chat history', style: AppTextstyles.font16Regular),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Chat History', style: AppTextstyles.font16Medium),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = chatHistory[index];
                  final isCurrentChat = cubit.currentChat?.id == chat.id;

                  return _chatHistoryWidgetItem(
                    isCurrentChat,
                    chat,
                    cubit,
                    context,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _chatHistoryWidgetItem(
    bool isCurrentChat,
    ChatModel chat,
    HomeCubit cubit,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isCurrentChat ? AppColor.lightGreyColor : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          chat.title,
          style: AppTextstyles.font16Regular.copyWith(
            fontWeight: isCurrentChat ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDate(chat.updatedAt),
          style: AppTextstyles.font14Regular,
        ),
        onTap: () async {
          context.pop(); // Close drawer
          await cubit.loadChat(chat.id);
          // Close drawer
        },
        trailing: IconButton(
          icon: Icon(Icons.delete, size: 20),
          onPressed: () => _showDeleteDialog(context, chat),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showDeleteDialog(BuildContext context, ChatModel chat) {
    // Capture the cubit reference before opening the dialog
    final cubit = context.read<HomeCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Chat'),
          content: Text('Are you sure you want to delete this chat?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Use the captured cubit reference instead of reading from dialogContext
                  await cubit.deleteChat(chat.id);
                  Navigator.pop(dialogContext);
                  // Show success message using the original context
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chat deleted successfully')),
                  );
                } catch (e) {
                  Navigator.pop(dialogContext);
                  // Show error message using the original context
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete chat: $e')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
