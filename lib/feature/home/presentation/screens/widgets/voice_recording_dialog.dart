import 'dart:async';
import 'dart:developer';
import 'package:chatgpt/core/theme/app_color.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/feature/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceRecordingDialog extends StatefulWidget {
  final Function(String recognizedText) onSpeechRecognized;

  const VoiceRecordingDialog({Key? key, required this.onSpeechRecognized})
    : super(key: key);

  @override
  State<VoiceRecordingDialog> createState() => _VoiceRecordingDialogState();
}

class _VoiceRecordingDialogState extends State<VoiceRecordingDialog>
    with SingleTickerProviderStateMixin {
  // State variables
  int _recordingSeconds = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _hasError = false;
  String _errorMessage = '';
  String _currentRecognizedText = '';
  bool _isStartingListening = false;

  // Getters for better readability
  HomeCubit get _cubit => context.read<HomeCubit>();
  bool get _isListening => _cubit.isListening;
  bool get _hasRecognizedText => _currentRecognizedText.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isListening) {
        setState(() => _recordingSeconds++);
      }
    });
  }

  String _formatDuration() {
    final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _startListening() async {
    try {
      _resetState();
      await _cubit.startListening();
      if (mounted) {
        setState(() => _isStartingListening = false);
      }
    } catch (e) {
      _handleListeningError(e);
    }
  }

  void _resetState() {
    setState(() {
      _isStartingListening = true;
      _hasError = false;
      _errorMessage = '';
      _recordingSeconds = 0;
      _currentRecognizedText = '';
    });
  }

  void _handleListeningError(dynamic error) {
    if (mounted) {
      setState(() {
        _isStartingListening = false;
        _hasError = true;
        _errorMessage = _getErrorMessage(error.toString());
      });
    }
    log('Error starting speech recognition: $error');
  }

  String _getErrorMessage(String error) {
    if (error.contains('error_speech_timeout')) {
      return 'Speech recognition timed out. Please try again.';
    } else if (error.contains('error_no_match')) {
      return 'No speech detected. Please speak clearly and try again.';
    } else if (error.contains('error_audio')) {
      return 'Audio error. Please check microphone permissions.';
    } else if (error.contains('error_network')) {
      return 'Network error. Please check your connection.';
    }
    return 'Speech recognition failed. Please try again.';
  }

  void _handleBlocState(HomeState state) {
    if (state is HomeSpeechToTextErrorState) {
      _handleSpeechError(state.error);
    } else if (state is HomeSpeechToTextSuccessState) {
      _handleSpeechSuccess(state.recognizedText);
    } else if (state is HomeSpeechToTextStoppedState) {
      _handleSpeechStopped(state.recognizedText);
    }
  }

  void _handleSpeechError(String error) {
    setState(() {
      _hasError = true;
      _errorMessage = _getErrorMessage(error);
      _isStartingListening = false;
    });
  }

  void _handleSpeechSuccess(String recognizedText) {
    setState(() {
      _currentRecognizedText = recognizedText;
      _hasError = false;
      _isStartingListening = false;
    });
    log("Received recognized text: '$_currentRecognizedText'");
  }

  void _handleSpeechStopped(String recognizedText) {
    setState(() {
      _currentRecognizedText = recognizedText;
      _hasError = false;
      _isStartingListening = false;
    });
    log("Speech recognition stopped with text: '$_currentRecognizedText'");
  }

  String _getHeaderText(bool isProcessing) {
    if (_isStartingListening) return "Starting...";
    if (_isListening) return "Listening...";
    if (isProcessing) return "Processing...";
    if (_hasRecognizedText) return "Is this correct?";
    return "Voice to Text";
  }

  Widget _buildHeader(bool isProcessing) {
    return Text(
      _getHeaderText(isProcessing),
      style: AppTextstyles.font16Medium,
    );
  }

  Widget _buildTimer() {
    if (!_isListening) return const SizedBox.shrink();

    return Text(
      _formatDuration(),
      style: AppTextstyles.font14Regular.copyWith(color: AppColor.greyColor),
    );
  }

  Widget _buildErrorMessage() {
    if (!_hasError) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        _errorMessage,
        textAlign: TextAlign.center,
        style: AppTextstyles.font14Regular.copyWith(color: Colors.red),
      ),
    );
  }

  Widget _buildStartingIndicator() {
    if (!_isStartingListening) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 10),
        Text("Initializing microphone...", style: AppTextstyles.font14Regular),
      ],
    );
  }

  Widget _buildAnimatedMicrophone() {
    if (!_isListening || _isStartingListening) return const SizedBox.shrink();

    return AnimatedBuilder(
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
              decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 32),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProcessingIndicator(bool isProcessing) {
    if (!isProcessing || _isStartingListening) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Converting speech to text...",
          style: AppTextstyles.font14Regular,
        ),
      ],
    );
  }

  Widget _buildMicrophoneButton(bool isProcessing) {
    final shouldShow =
        !_isListening &&
        !isProcessing &&
        !_hasRecognizedText &&
        !_isStartingListening;

    if (!shouldShow) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _startListening,
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: AppColor.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mic, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildRecognizedText(bool isProcessing) {
    final shouldShow =
        !_isListening &&
        !isProcessing &&
        _hasRecognizedText &&
        !_isStartingListening;

    if (!shouldShow) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(_currentRecognizedText, style: AppTextstyles.font14Regular),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: _isStartingListening ? null : _handleCancel,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.grey[100],
      ),
      child: Text("Cancel", style: AppTextstyles.font14Regular),
    );
  }

  Future<void> _handleCancel() async {
    if (_isListening) {
      await _cubit.stopListening();
    }
    Navigator.pop(context);
  }

  Widget _buildStopButton() {
    if (!_isListening || _isStartingListening) return const SizedBox.shrink();

    return TextButton(
      onPressed: () => _cubit.stopListening(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        backgroundColor: AppColor.primaryColor.withOpacity(0.1),
      ),
      child: Text(
        "Stop",
        style: AppTextstyles.font14Medium.copyWith(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTryAgainButton(bool isProcessing) {
    final shouldShow =
        _hasError &&
        !_isListening &&
        !isProcessing &&
        !_hasRecognizedText &&
        !_isStartingListening;

    if (!shouldShow) return const SizedBox.shrink();

    return TextButton(
      onPressed: _startListening,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        backgroundColor: AppColor.primaryColor,
      ),
      child: const Text(
        "Try Again",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildUseTextButton(bool isProcessing) {
    final shouldShow =
        !_isListening &&
        !isProcessing &&
        _hasRecognizedText &&
        !_isStartingListening;

    if (!shouldShow) return const SizedBox.shrink();

    return TextButton(
      onPressed: _handleUseText,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        backgroundColor: AppColor.primaryColor,
      ),
      child: const Text(
        "Use Text",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _handleUseText() {
    log("Using text: '$_currentRecognizedText'");
    widget.onSpeechRecognized(_currentRecognizedText);
    Navigator.pop(context);
  }

  Widget _buildActionButtons(bool isProcessing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCancelButton(),
        const SizedBox(width: 16),
        _buildStopButton(),
        _buildTryAgainButton(isProcessing),
        _buildUseTextButton(isProcessing),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) => _handleBlocState(state),
      builder: (context, state) {
        final isProcessing =
            state is HomeSpeechToTextLoadingState && !_isListening;

        return Dialog(
          elevation: 5,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(isProcessing),
                const SizedBox(height: 16),
                _buildTimer(),
                _buildErrorMessage(),
                const SizedBox(height: 20),
                _buildStartingIndicator(),
                _buildAnimatedMicrophone(),
                _buildProcessingIndicator(isProcessing),
                _buildMicrophoneButton(isProcessing),
                _buildRecognizedText(isProcessing),
                const SizedBox(height: 24),
                _buildActionButtons(isProcessing),
              ],
            ),
          ),
        );
      },
    );
  }
}
