import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/core/services/firebase_store_service.dart';
import 'package:chatgpt/feature/auth/data/repos/login_repo_impl.dart';
import 'package:chatgpt/feature/auth/data/repos/sign_up_repo_impl.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';
import 'package:chatgpt/feature/home/data/apis/speech_to_text_service.dart';
import 'package:chatgpt/feature/home/data/repos/home_repo_impl.dart';
import 'package:chatgpt/feature/home/presentation/cubits/chat/chat_cubit.dart';
import 'package:chatgpt/feature/home/presentation/cubits/image/image_cubit.dart';
import 'package:chatgpt/feature/home/presentation/cubits/message/message_cubit.dart';
import 'package:chatgpt/feature/home/presentation/cubits/speech/speech_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Register your services and repositories here

  // Firebase services
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<FirebaseStoreService>(
    () => FirebaseStoreService(),
  );
  // gemini and speech services
  getIt.registerLazySingleton<GeminiService>(() => GeminiService());
  getIt.registerLazySingleton<SpeechToTextService>(() => SpeechToTextService());
  getIt.registerLazySingleton<SignUpRepoImpl>(
    () => SignUpRepoImpl(
      getIt<FirebaseAuthService>(),
      getIt<FirebaseStoreService>(),
    ),
  );
  // repos
  getIt.registerLazySingleton<HomeRepoImpl>(
    () => HomeRepoImpl(getIt<SpeechToTextService>()),
  );

  getIt.registerLazySingleton<SignUpCubit>(
    () => SignUpCubit(getIt<SignUpRepoImpl>()),
  );

  getIt.registerLazySingleton<LoginRepoImpl>(
    () => LoginRepoImpl(getIt<FirebaseAuthService>()),
  );

  getIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(getIt<LoginRepoImpl>()),
  );

  // Register cubits
  getIt.registerLazySingleton<MessageCubit>(
    () => MessageCubit(getIt<GeminiService>()),
  );
  getIt.registerLazySingleton<ImageCubit>(
    () => ImageCubit(getIt<GeminiService>()),
  );
  getIt.registerLazySingleton<ChatCubit>(() => ChatCubit());
  getIt.registerLazySingleton<SpeechCubit>(
    () => SpeechCubit(getIt<HomeRepoImpl>()),
  );
}
