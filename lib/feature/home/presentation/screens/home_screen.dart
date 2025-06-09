import 'package:chatgpt/core/di/dependency_injection.dart';
import 'package:chatgpt/core/services/firebase_store_service.dart';
import 'package:chatgpt/core/theme/app_textstyles.dart';
import 'package:chatgpt/feature/home/presentation/cubits/home/home_cubit.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/chat_message.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/drawer_menu.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/home_fuctionality_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  String secondName = '';

  @override
  void initState() {
    getIt<FirebaseStoreService>().getCurrentUserData().then((userData) {
      setState(() {
        firstName = userData?['firstName'] ?? '';
        secondName = userData?['lastName'] ?? '';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Load chat history when screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().chatCubit.loadChatHistory();
    });

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('ChatGpt', style: AppTextstyles.font16Medium),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, size: 30),
                ),
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<HomeCubit>().createNewChat();
            },
            icon: Icon(Icons.add, size: 30),
          ),
        ],
      ),
      drawer: DrawerMenu(firstName: firstName, secondName: secondName),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                // Always get messages from cubit to ensure consistency
                final cubit = context.read<HomeCubit>();
                final messages = cubit.chatMessages;

                // Handle empty message list
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      "Start a conversation",
                      style: AppTextstyles.font16Regular,
                    ),
                  );
                }

                // Show messages with appropriate state handling
                return ListView.builder(
                  itemCount: messages.length,
                  padding: EdgeInsets.all(16),
                  reverse: false, // Set to true if you want newest at bottom
                  itemBuilder: (context, index) {
                    final chatMessage = messages[index];

                    // For regular messages or images
                    return Column(
                      children: [
                        ChatMessage(
                          message: chatMessage.message,
                          isFromUser: chatMessage.isUserMessage,
                          timestamp: chatMessage.timestamp,
                          imagepath: chatMessage.imagepath,
                        ),

                        // Show loading indicator at the end if we're processing
                        if (state is HomeCubitLoading &&
                            index == messages.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          HomeFuctionalityBottomBar(),
        ],
      ),
    );
  }
}
