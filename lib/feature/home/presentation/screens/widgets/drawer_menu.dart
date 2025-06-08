import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/extention.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:chatgpt/feature/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/chat_history_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerMenu extends StatelessWidget {
  final String firstName, secondName;
  const DrawerMenu({
    super.key,
    required this.firstName,
    required this.secondName,
  });

  @override
  Widget build(BuildContext context) {
    final userName = '$firstName $secondName';
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(40),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColor.lightGreyColor,
                      child: Text(
                        _getInitials(userName),
                        style: AppTextstyles.font16Regular.copyWith(
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                    horizontalSpacing(8),
                    Text(
                      '$firstName $secondName',
                      style: AppTextstyles.font16Medium,
                    ),
                  ],
                ),
                verticalSpacing(20),
                InkWell(
                  onTap: () async {
                    // Handle new chat creation
                    await context.read<HomeCubit>().createNewChat();
                    context.pop(); // Close drawer
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreyColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.greyColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(Icons.add, size: 30),
                          Text('New Chat', style: AppTextstyles.font16Medium),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 2),
          Expanded(child: ChatHistoryWidget()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                verticalSpacing(24),
                InkWell(
                  onTap: () async {
                    // Handle clear conversation
                    await context.read<HomeCubit>().clearAndCreateNewChat();
                    context.pop(); // Close drawer
                  },
                  child: Row(
                    spacing: 12,
                    children: [
                      Icon(Icons.settings, size: 30),
                      horizontalSpacing(8),
                      Text(
                        'Clear conversation',
                        style: AppTextstyles.font16Regular,
                      ),
                    ],
                  ),
                ),
                verticalSpacing(20),
                Row(
                  spacing: 12,
                  children: [
                    Icon(Icons.help, size: 30),
                    horizontalSpacing(8),
                    Text('Help & Feedback', style: AppTextstyles.font16Regular),
                  ],
                ),
                verticalSpacing(20),
                Row(
                  spacing: 12,
                  children: [
                    Icon(Icons.logout, size: 30),
                    horizontalSpacing(8),
                    Text('Log out', style: AppTextstyles.font16Regular),
                  ],
                ),
                verticalSpacing(20),
                Row(
                  spacing: 12,
                  children: [
                    Icon(Icons.info, size: 30),
                    horizontalSpacing(8),
                    Text('Version 1.0.0', style: AppTextstyles.font16Regular),
                  ],
                ),
                verticalSpacing(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getInitials(String name) {
  final names = name.split(' ');
  final firstName = names.isNotEmpty ? names[0] : '';
  final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
  final secondInitial = names.length > 1 ? names[1][0] : '';
  return (firstInitial + secondInitial).toUpperCase();
}
