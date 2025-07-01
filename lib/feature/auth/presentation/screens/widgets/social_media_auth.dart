import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialMediaAuth extends StatelessWidget {
  final VoidCallback? onTap;
  const SocialMediaAuth({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 327,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: const Color(0xFFE5E6EB)),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(Assets.assetsSvgsGoogle, width: 20, height: 20),
            Text('Continue with Google', style: AppTextstyles.font16Regular),
          ],
        ),
      ),
    );
  }
}
