import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/spacing.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
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
                    'ZM',
                    style: AppTextstyles.font16Regular.copyWith(
                      color: Colors.cyan,
                    ),
                  ),
                ),
                horizontalSpacing(8),
                Text('Zyad mostafa', style: AppTextstyles.font16Medium),
              ],
            ),
            verticalSpacing(20),
            Container(
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
            Spacer(),
            Divider(thickness: 2),
            verticalSpacing(24),
            Row(
              spacing: 12,
              children: [
                Icon(Icons.settings, size: 30),
                horizontalSpacing(8),
                Text('Clear conversation', style: AppTextstyles.font16Regular),
              ],
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
    );
  }
}
