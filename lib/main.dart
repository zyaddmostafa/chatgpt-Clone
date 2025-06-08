import 'dart:developer';

import 'package:chatgpt/app_bloc_observer.dart';
import 'package:chatgpt/core/di/dependency_injection.dart';
import 'package:chatgpt/core/routing/app_routes.dart';
import 'package:chatgpt/core/routing/routes.dart';
import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/feature/home/data/apis/speech_to_text_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupGetIt();
  getIt<SpeechToTextService>().initializeSpeechState();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'PingFang SC'),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.ongenerateRoute,
        initialRoute: Routes.welcomeScreen,
      ),
    );
  }
}
