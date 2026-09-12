import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/core/widgets/custom_text_form_field.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:masroof_app/features/auth/presentation/screens/register_screen.dart';
import 'package:masroof_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:masroof_app/features/navigation/main_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == EnumAuthStatus.authenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
          }
          if (state.status == EnumAuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'يوجد خطأ'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSize.ph16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: AppSize.w350,
                    height: AppSize.h168,
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: 96,
                      height: 96,
                    ),
                  ),
                  SizedBox(height: AppSize.h16),
                  Text(
                    'مرحباً بك في مصروف',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppLightColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSize.h8),
                  Text('سجل دخولك لمتابعة مصاريفك بذكاء'),
                  SizedBox(height: AppSize.h24),
                  CustomTextFormField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                    controller: emailController,
                    hintText: 'name@example.com',
                    title: 'البريد الإلكتروني',
                  ),
                  SizedBox(height: AppSize.h16),

                  CustomTextFormField(
                    maxLines: 1,
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                    controller: passwordController,
                    hintText: '************',
                    title: 'كلمة المرور ',
                  ),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'نسيت كلمة المرور؟ ',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppLightColors.primaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: AppSize.h16),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state.status == EnumAuthStatus.loading;

                      return CustomButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                        title: 'تسجيل الدخول ',
                        icon: Icons.save_as_outlined,
                        child:
                            isLoading
                                ? CircularProgressIndicator(
                                  color: AppLightColors.wightColor,
                                )
                                : null,
                      );
                    },
                  ),
                  SizedBox(height: AppSize.h16),
                  Divider(),
                  SizedBox(height: AppSize.h16),
                  SizedBox(height: AppSize.h16),
                  CustomButton(
                    onPressed: () {},
                    title: 'المتابعة باستخدام Google  ',
                    icon: Icons.save_as_outlined,
                    color: AppLightColors.strokeColor,
                    textColor: AppLightColors.primaryColor,
                  ),
                  SizedBox(height: AppSize.h16),

                  CustomButton(
                    onPressed: () {},
                    title: 'المتابعة باستخدام Apple  ',
                    icon: Icons.save_as_outlined,
                    color: AppLightColors.mainTextColor,
                    textColor: AppLightColors.wightColor,
                  ),

                  SizedBox(height: AppSize.h16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'سجل الآن ',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppLightColors.primaryColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
