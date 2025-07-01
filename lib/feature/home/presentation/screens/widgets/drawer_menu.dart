import 'package:chatgpt/core/di/dependency_injection.dart';
import 'package:chatgpt/feature/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:chatgpt/feature/home/presentation/screens/widgets/drawer_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerMenu extends StatelessWidget {
  final String firstName, secondName;

  const DrawerMenu({
    super.key,
    required this.firstName,
    required this.secondName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
      child: DrawerContent(firstName: firstName, secondName: secondName),
    );
  }
}
