import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/core/widgets/custom_text_form_field.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:masroof_app/features/auth/presentation/screens/login_screen.dart';
import 'package:masroof_app/features/auth/presentation/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

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
          if (state.status == EnumAuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? ' تم التسجيل بنجاح'),
                backgroundColor: AppLightColors.secondaryNumberColor,
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false,
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
                  SizedBox(height: AppSize.h100),
                  Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppLightColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSize.h8),
                  Text('انضم إلى مصروف لتحكم أفضل بأموالك'),
                  SizedBox(height: AppSize.h24),

                  CustomTextFormField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'أدخل اسمك ';
                      }
                      return null;
                    },
                    controller: nameController,
                    hintText: 'أدخل اسمك ',
                    title: 'الاسم ',
                  ),
                  SizedBox(height: AppSize.h16),

                  CustomTextFormField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                    controller: emailController,
                    hintText: 'البريد الإلكتروني',
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
                                    context.read<AuthCubit>().register(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  }
                                },
                        title: 'إنشاء الحساب',
                        child:
                            isLoading
                                ? CircularProgressIndicator(
                                  color: AppLightColors.wightColor,
                                )
                                : null,
                      );
                    },
                  ),
                  SizedBox(height: AppSize.h40),
                  Divider(),
                  SizedBox(height: AppSize.h16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('لديك حساب بالفعل؟  '),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'سجل دخولك  ',
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
