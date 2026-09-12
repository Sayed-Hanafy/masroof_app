import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/widgets/custom_svg_pic.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/home/presentation/screens/home_screen.dart';
import 'package:masroof_app/features/setting/presentation/screens/setting_screen.dart';
import 'package:masroof_app/features/transactions/data/repository/transaction_repository.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:masroof_app/features/transactions/presentation/screens/analysis_screen.dart';
import 'package:masroof_app/features/transactions/presentation/screens/transactions_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _screen = 0;
  List<Widget> privateScreen = [
    HomeScreen(),
    TransactionsListScreen(),
    AnalysisScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().state.user!.id;
    return BlocProvider(
      create:
          (_) =>
              TransactionCubit(context.read<TransactionRepository>())
                ..getTransaction(userId),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _screen,
          onTap: (index) {
            setState(() {
              _screen = index;
            });
          },

          backgroundColor: AppLightColors.icons3BackColor,
          selectedItemColor: AppLightColors.primaryNumberColor,
          unselectedItemColor: AppLightColors.mainTextColor,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              // icon: SvgPicture.asset("assets/icons/home.svg"),
              icon: CustomSvgPic(
                path: "assets/icons/home.svg",
                withColor: true,
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: CustomSvgPic(
                path: "assets/icons/operation.svg",
                withColor: false,
              ),
              label: 'العمليات',
            ),
            BottomNavigationBarItem(
              icon: CustomSvgPic(
                path: "assets/icons/report.svg",
                withColor: false,
              ),
              label: 'التقارير',
            ),
            BottomNavigationBarItem(
              icon: CustomSvgPic(
                path: "assets/icons/setting.svg",
                withColor: false,
              ),
              label: 'الإعدادات',
            ),
          ],
        ),
        body: SafeArea(child: privateScreen[_screen]),
      ),
    );
  }
}
