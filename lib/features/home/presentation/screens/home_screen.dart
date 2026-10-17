import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:masroof_app/features/auth/presentation/screens/login_screen.dart';
import 'package:masroof_app/features/categories/data/repository/category_repository.dart';
import 'package:masroof_app/features/categories/presentation/cubit/cubit/category_cubit.dart';
import 'package:masroof_app/features/home/presentation/widgets/income_card.dart';
import 'package:masroof_app/features/home/presentation/widgets/outcome_card%20.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:masroof_app/features/transactions/presentation/screens/transactions_add_screen.dart';
import 'package:masroof_app/features/transactions/presentation/screens/transactions_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == EnumAuthStatus.unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: AppLightColors.primaryColor,
          child: Icon(Icons.add, color: AppLightColors.wightColor),

          onPressed: () async {
            final userId = context.read<AuthCubit>().state.user!.id;

            final transactionCubit = context.read<TransactionCubit>();
            transactionCubit.resetTransactionForm();

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: transactionCubit),
                        BlocProvider(
                          create:
                              (_) => CategoryCubit(
                                context.read<CategoryRepository>(),
                              ),
                        ),
                      ],
                      child: AddTransactionsScreen(),
                    ),
              ),
            );
            if (result == true) {
              await transactionCubit.getTransaction(userId);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تمت إضافة العملية بنجاح')),
              );
            }
          },
        ),
        appBar: AppBar(
          //centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                      icon: const Icon(Icons.logout),
                    ),
                    Icon(Icons.notification_add_outlined),
                    Spacer(),
                    Text('الرئيسية'),
                    Spacer(),
                    Text(state.user?.name ?? ''),
                  ],
                );
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      Container(
                        width: AppSize.w350,
                        height: AppSize.h168,
                        decoration: BoxDecoration(
                          color: AppLightColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: AppSize.w111,
                            height: AppSize.h111,
                            decoration: BoxDecoration(
                              color: AppLightColors.wightColor.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  "الرصيد الحالي",
                                  style: TextStyle(
                                    color: AppLightColors.wightColor,
                                    fontSize: AppSize.sp12,
                                  ),
                                ),
                                SizedBox(height: AppSize.h12),
                                Text(
                                  " ${state.balance.toStringAsFixed(2)} EGP",
                                  style: TextStyle(
                                    color: AppLightColors.wightColor,
                                    fontSize: AppSize.sp20,
                                  ),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppLightColors.wightColor
                                        .withAlpha(30),
                                    foregroundColor: AppLightColors.wightColor,
                                  ),
                                  onPressed: () {},
                                  child: Text('تحليل المصاريف '),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: AppSize.h24),
              BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      CustomOutcomeCard(totalExpense: state.totalExpense),
                      CustomIncomeCard(totalIncome: state.totalIncome),
                    ],
                  );
                },
              ),
              SizedBox(height: AppSize.h24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " عرض الكل",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppLightColors.primaryColor,
                    ),
                  ),
                  Text(
                    "العمليات الأخيرة",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppLightColors.mainTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.h24),
              Expanded(
                child: BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {

                    if (state.getTransactionStatus ==
                        EnGetTransactionStatus.loading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state.getTransactionStatus ==
                        EnGetTransactionStatus.failure) {
                      return Center(
                        child: Text(state.message ?? 'فشل في تحميل العمليات'),
                      );
                    }
                    if (state.getTransactionStatus ==
                            EnGetTransactionStatus.success &&
                        state.transactions.isEmpty) {
                      return Center(child: Text('لا توجد عمليات'));
                    }
                    return ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions[index];

                        return Card(
                          color: AppLightColors.wightColor,
                          child: ListTile(
                            onTap: () async {
                              final transactionCubit =
                                  context.read<TransactionCubit>();

                              final deleted = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: transactionCubit,
                                        child: TransactionDetailsScreen(
                                          transaction: transaction,
                                        ),
                                      ),
                                ),
                              );

                              if (deleted == true && context.mounted) {
                                await transactionCubit.getTransaction(
                                  transaction.userId,
                                );
                              }
                            },
                            title: Text(transaction.description),
                            subtitle: Text(
                              ' ${transaction.categoryName} • ${transaction.transactionDate} ',
                            ),
                            leading: Icon(Icons.arrow_forward_ios),
                            trailing: Text(
                              '${transaction.amount.toStringAsFixed(2)} EGP',
                              style: TextStyle(
                                color: AppLightColors.primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
