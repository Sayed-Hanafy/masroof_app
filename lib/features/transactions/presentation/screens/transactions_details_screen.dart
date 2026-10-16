import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/categories/data/repository/category_repository.dart';
import 'package:masroof_app/features/categories/presentation/cubit/cubit/category_cubit.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_data_model.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/details_card.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/edit_transaction_bottom_sheet.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionDataModel transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.type == 'income';
    final userId = context.read<AuthCubit>().state.user!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل العملية'), centerTitle: true),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSize.ph16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: AppSize.h24),
                        decoration: BoxDecoration(
                          color: AppLightColors.wightColor,
                          borderRadius: BorderRadius.circular(AppSize.w10),
                          border: Border.all(color: AppLightColors.strokeColor),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'المبلغ الإجمالي',
                              style: TextStyle(
                                fontSize: AppSize.sp14,
                                color: AppLightColors.mainTextColor,
                              ),
                            ),

                            SizedBox(height: AppSize.h8),

                            Text(
                              '${transaction.amount.toStringAsFixed(2)} جنيه',
                              style: TextStyle(
                                fontSize: AppSize.sp24,
                                fontWeight: FontWeight.bold,
                                color: AppLightColors.primaryColor,
                              ),
                            ),

                            SizedBox(height: AppSize.h12),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.w16,
                                vertical: AppSize.h6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isIncome
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(
                                  AppSize.w20,
                                ),
                              ),
                              child: Text(
                                isIncome ? 'دخل' : 'مصروف',
                                style: TextStyle(
                                  fontSize: AppSize.sp12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isIncome
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSize.h16),

                      DetailsCard(
                        title: 'الفئة',
                        icon: isIncome ? Icons.trending_up : Icons.restaurant,
                        child: Text(
                          transaction.categoryName,
                          style: TextStyle(
                            fontSize: AppSize.sp16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.h12),

                      DetailsCard(
                        title: 'التاريخ',
                        icon: Icons.calendar_month,
                        child: Text(
                          transaction.transactionDate,
                          style: TextStyle(
                            fontSize: AppSize.sp16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.h12),

                      DetailsCard(
                        title: 'الوصف',
                        icon: Icons.description_outlined,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            transaction.description,
                            style: TextStyle(
                              fontSize: AppSize.sp15,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.h12),

                      DetailsCard(
                        title: 'رقم العملية',
                        icon: Icons.receipt_long_outlined,
                        child: Text(
                          '#${transaction.transactionId}',
                          style: TextStyle(
                            fontSize: AppSize.sp14,
                            color: AppLightColors.mainTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSize.h16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final transactionCubit =
                            context.read<TransactionCubit>();
                        final categoryRepository =
                            context.read<CategoryRepository>();

                        final update = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppLightColors.wightColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create:
                                      (_) =>
                                          CategoryCubit(categoryRepository)
                                            ..getCategories(
                                              transaction.type,
                                              selectedCategoryId:
                                                  transaction.categoryId,
                                            ),
                                ),
                                BlocProvider.value(value: transactionCubit),
                              ],
                              child: EditTransactionBottomSheet(
                                transaction: transaction,
                              ),
                            );
                          },
                        );
                        if (update == true) {
                          await transactionCubit.getTransaction(userId);
                          if (!context.mounted) return;
                          Navigator.pop(context, true);
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('تعديل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppLightColors.primaryColor,
                        foregroundColor: AppLightColors.wightColor,
                        minimumSize: Size(double.infinity, AppSize.h52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.w10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: AppSize.w12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmDeleteTransaction(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('حذف'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade700,
                        minimumSize: Size(double.infinity, AppSize.h52),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.w10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteTransaction(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text(
            'هل أنت متأكد من حذف هذه العملية؟ '
            'لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (shouldDelete != true) return;
    final transactionCubit = context.read<TransactionCubit>();
    await transactionCubit.deleteTransaction(
      transaction.transactionId,
      transaction.userId,
    );

    if (!context.mounted) return;

    if (transactionCubit.state.status == EnTransactionStatus.success) {
      Navigator.of(context).pop(true);
    } else {
      final message = transactionCubit.state.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message?.isNotEmpty == true
                ? message!
                : 'حدث خطأ أثناء حذف العملية',
          ),
        ),
      );
    }
  }
}
