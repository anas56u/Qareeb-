import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qareeb/features/auth/data/repositories/auth_repository.dart';
import 'package:qareeb/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:qareeb/features/cart/logic/cart_cubit/cart_cubit.dart';
import 'package:qareeb/firebase_options.dart';

import 'core/helpers/cache_helper.dart';
import 'features/splash/presentation/screens/splash_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الفايربيس
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تهيئة SharedPreferences
  await CacheHelper.init();

  runApp(const QareebApp());
}

class QareebApp extends StatelessWidget {
  const QareebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthRepository())),
        BlocProvider<CartCubit>(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'Qareeb - قريب',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        ),
        // التطبيق يبدأ دائماً من شاشة البداية، وهي من ستقرر أين نذهب
        home: const SplashScreen(),
      ),
    );
  }
}
