import 'package:chatgpt/core/services/firebase_auth_service.dart';
import 'package:chatgpt/core/services/firebase_store_service.dart';
import 'package:chatgpt/feature/auth/data/repos/sign_up_repo_impl.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/signup_cubit/sign_up_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Register your services and repositories here
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<FirebaseStoreService>(
    () => FirebaseStoreService(),
  );
  getIt.registerLazySingleton<SignUpRepoImpl>(
    () => SignUpRepoImpl(getIt<FirebaseAuthService>()),
  );

  getIt.registerLazySingleton<SignUpCubit>(
    () => SignUpCubit(getIt<SignUpRepoImpl>()),
  );
}
