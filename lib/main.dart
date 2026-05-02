import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/auth/data/repositories/auth_repository.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:qareeb/features/splash/presentation/screens/splash_screens.dart';
import 'package:qareeb/firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const QareebApp());
}

class QareebApp extends StatelessWidget {
  const QareebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        AuthRepository(),
      ),
      child: MaterialApp(
        title: 'Qareeb - قريب',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}