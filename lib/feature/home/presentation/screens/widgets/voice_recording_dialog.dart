import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';

class VoiceRecordingDialog extends StatefulWidget {
  final Function(String? recognizedText) onSpeechRecognized;

  const VoiceRecordingDialog({Key? key, required this.onSpeechRecognized})
    : super(key: key);

  @override
  State<VoiceRecordingDialog> createState() => _VoiceRecordingDialogState();
}

class _VoiceRecordingDialogState extends State<VoiceRecordingDialog>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  int _recordingSeconds = 0;
  Timer? _timer;
  String _recognizedText = "";
  bool _isProcessing = false;

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _recordingSeconds = 0;
      _recognizedText = "";
    });

    // Start timer to show recording duration
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
    });

    // In actual implementation, you would start speech recognition here
    // using a plugin like 'speech_to_text'
  }

  void _stopListening() {
    _timer?.cancel();

    setState(() {
      _isListening = false;
      _isProcessing = true;
      // Simulate processing delay
      Future.delayed(Duration(milliseconds: 800), () {
        setState(() {
          // In a real implementation, this would be the text from speech recognition
          _recognizedText = "This is a sample recognized text.";
          _isProcessing = false;
        });
      });
    });
  }

  void _confirmRecognizedText() {
    widget.onSpeechRecognized(_recognizedText);
    Navigator.pop(context);
  }

  void _cancelListening() {
    _timer?.cancel();
    widget.onSpeechRecognized(null);
    Navigator.pop(context);
  }

  String _formatDuration() {
    final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isListening
                  ? "Listening..."
                  : _isProcessing
                  ? "Processing..."
                  : _recognizedText.isNotEmpty
                  ? "Is this correct?"
                  : "Voice to Text",
              style: AppTextstyles.font16Medium,
            ),
            const SizedBox(height: 16),

            // Show timer during recording
            if (_isListening)
              Text(
                _formatDuration(),
                style: AppTextstyles.font14Regular.copyWith(
                  color: AppColor.greyColor,
                ),
              ),

            const SizedBox(height: 20),

            // Animated recording indicator
            if (_isListening)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 80 * _pulseAnimation.value,
                    height: 80 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.mic, color: Colors.white, size: 32),
                      ),
                    ),
                  );
                },
              ),

            // Processing indicator
            if (_isProcessing)
              Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Converting speech to text...",
                    style: AppTextstyles.font14Regular,
                  ),
                ],
              ),

            // Start recording button when not listening
            if (!_isListening && !_isProcessing && _recognizedText.isEmpty)
              GestureDetector(
                onTap: _startListening,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mic, color: Colors.white, size: 40),
                ),
              ),

            // Show recognized text result
            if (!_isListening && !_isProcessing && _recognizedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _recognizedText,
                  style: AppTextstyles.font14Regular,
                ),
              ),

            SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel button
                TextButton(
                  onPressed: _cancelListening,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.grey[100],
                  ),
                  child: Text("Cancel", style: AppTextstyles.font14Regular),
                ),

                SizedBox(width: 16),

                // Stop button (visible only when listening)
                if (_isListening)
                  TextButton(
                    onPressed: _stopListening,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                    ),
                    child: Text(
                      "Stop",
                      style: AppTextstyles.font14Medium.copyWith(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),

                // Use text button (visible when text is recognized)
                if (!_isListening &&
                    !_isProcessing &&
                    _recognizedText.isNotEmpty)
                  TextButton(
                    onPressed: _confirmRecognizedText,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      backgroundColor: AppColor.primaryColor,
                    ),
                    child: Text(
                      "Use Text",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
