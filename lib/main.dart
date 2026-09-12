import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masroof_app/core/constants/them_data/light_them.dart';
import 'package:masroof_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:masroof_app/features/auth/data/repositories/auth_repository.dart';
import 'package:masroof_app/features/auth/data/services/auth_service.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:masroof_app/features/categories/data/repository/category_repository.dart';
import 'package:masroof_app/features/categories/data/services/category_service.dart';
import 'package:masroof_app/features/transactions/data/repository/transaction_repository.dart';
import 'package:masroof_app/features/transactions/data/services/transaction_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScreenUtil.ensureScreenSize();

  final preference = await SharedPreferences.getInstance();
  final authLocalDataSource = AuthLocalDataSource(preferences: preference);

  final authService = AuthService();

  final authRepository = AuthRepository(
    authService: authService,
    authLocalDataSource: authLocalDataSource,
  );

  final transactionService = TransactionService();
  final transactionRepository = TransactionRepository(
    transactionService: transactionService,
  );

  final CategoryService categoryService = CategoryService();
  final categoryRepository = CategoryRepository(categoryService: categoryService);



  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<TransactionRepository>.value(
          value: transactionRepository,
        ),
        RepositoryProvider<CategoryRepository>.value(value: categoryRepository),
      ],
      child: BlocProvider(
        create:
            (_) => AuthCubit(authRepository: authRepository)..checkAuthStatus(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 884),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          title: 'Flutter Demo',
          theme: lightTheme,
          home: AuthGate(),
        );
      },
    );
  }
}
