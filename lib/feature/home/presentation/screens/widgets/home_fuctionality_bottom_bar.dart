import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/feature/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/show_picked_image.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/voice_recording_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFuctionalityBottomBar extends StatelessWidget {
  const HomeFuctionalityBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (context.watch<HomeCubit>().pickedImage != null)
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) => current is HomeImagePickedState,

              builder: (context, state) {
                state as HomeImagePickedState;
                return ShowPickedImage(pickedImage: state.pickedImage);
              },
            ),
          // Text field without shape
          TextField(
            controller: cubit.promptTextEditingController,
            decoration: InputDecoration(
              hintText: 'Ask anything...',
              hintStyle: TextStyle(color: AppColor.greyColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
          ),

          // Row of icons
          Row(
            children: [
              // Add files icon
              IconButton(
                icon: Icon(Icons.add, color: AppColor.greyColor),
                onPressed: () async {
                  // Handle file attachment
                  _showAttachmentOptions(context);
                },
              ),

              // Spacer to push mic and send to the right
              Spacer(),

              // Mic icon
              IconButton(
                icon: Icon(Icons.mic, color: AppColor.greyColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => BlocProvider.value(
                          value: cubit,
                          child: VoiceRecordingDialog(
                            onSpeechRecognized: (String? recognizedText) {
                              if (recognizedText != null &&
                                  recognizedText.isNotEmpty) {
                                // Add the recognized text to the text field
                                cubit.promptTextEditingController.text =
                                    recognizedText;

                                // Optional: Move cursor to the end of the text
                                cubit
                                    .promptTextEditingController
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(offset: recognizedText.length),
                                );
                              }
                            },
                          ),
                        ),
                  );
                },
              ),

              // Send icon
              IconButton(
                icon: Icon(Icons.send, color: AppColor.primaryColor),
                onPressed: () {
                  final message =
                      context
                          .read<HomeCubit>()
                          .promptTextEditingController
                          .text;
                  if (cubit.pickedImage != null) {
                    cubit.imageAnalyze(message: message);
                  } else if (message.isNotEmpty) {
                    cubit.sendTextMessage(message);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a message')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showAttachmentOptions(BuildContext context) {
  final HomeCubit cubit = context.read<HomeCubit>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => BlocProvider.value(
          value: cubit,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose an option', style: AppTextstyles.font16Medium),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Camera option
                    _AttachmentOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        cubit.pickImage(fromCamera: true);
                        Navigator.pop(context);
                      },
                    ),

                    // Gallery option
                    _AttachmentOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        cubit.pickImage(fromCamera: false);
                        Navigator.pop(context);
                      },
                    ),

                    // File option
                    _AttachmentOption(
                      icon: Icons.attach_file,
                      label: 'Document',
                      onTap: () {
                        cubit.pickImage(fromCamera: false);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );
}

// Helper widget for option items
class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.lightGreyColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.primaryColor, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: AppTextstyles.font14Regular),
        ],
      ),
    );
  }
}
