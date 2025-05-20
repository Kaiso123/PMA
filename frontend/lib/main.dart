import 'package:doan/features/core/injection.dart';
import 'package:doan/features/presentation/blocs/auth_bloc.dart';
import 'package:doan/features/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        builder: (context, child) {
          return ScaffoldMessenger(
            child: child!,
          );
        },
        home: LoginPage(),
      ),
    );
  }
}