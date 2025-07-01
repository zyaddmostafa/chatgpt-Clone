import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/presentation/cubits/speech/speech_cubit.dart';

class SimpleSpeechTestDialog extends StatelessWidget {
  const SimpleSpeechTestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeechCubit, SpeechState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text('Speech Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current State: ${state.runtimeType}'),
              if (state is SpeechError)
                Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Colors.red),
                ),
              if (state is SpeechResult)
                Text(
                  'Result: ${state.text}',
                  style: TextStyle(color: Colors.green),
                ),
              if (state is SpeechStopped)
                Text(
                  'Final: ${state.finalText}',
                  style: TextStyle(color: Colors.orange),
                ),
              if (state is SpeechListening)
                Text('Listening...', style: TextStyle(color: Colors.blue)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<SpeechCubit>().startListening();
                    },
                    child: Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<SpeechCubit>().stopListening();
                    },
                    child: Text('Stop'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
