import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:masroof_app/features/auth/presentation/screens/login_screen.dart';
import 'package:masroof_app/features/navigation/main_screens.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) {
        return current.status == EnumAuthStatus.checking ||
            current.status == EnumAuthStatus.authenticated ||
            current.status == EnumAuthStatus.unauthenticated;
      },
      builder: (context, state) {
        if (state.status == EnumAuthStatus.checking ||
            state.status == EnumAuthStatus.initial) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.status == EnumAuthStatus.authenticated) {
          return const MainScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
