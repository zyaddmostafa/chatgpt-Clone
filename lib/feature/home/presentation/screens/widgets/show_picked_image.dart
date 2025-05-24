import 'dart:io';

import 'package:chatgpt/feature/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowPickedImage extends StatelessWidget {
  const ShowPickedImage({super.key, required this.pickedImage});

  final File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: 65.w,
      height: 65.h,
      child: Stack(
        children: [
          // Image preview with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              pickedImage!,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          // Close button overlay
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                // Clear the picked image
                context.read<HomeCubit>().clearPickedImage();
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
