import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/core/widgets/custom_text_form_field.dart';
import 'package:masroof_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masroof_app/features/categories/presentation/cubit/cubit/category_cubit.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_model.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/date_picker.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/total_balance_card_widget.dart';

class AddTransactionsScreen extends StatefulWidget {
  const AddTransactionsScreen({super.key});

  @override
  State<AddTransactionsScreen> createState() => _AddTransactionsScreenState();
}

class _AddTransactionsScreenState extends State<AddTransactionsScreen> {
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  void _saveTransaction() {
    final user = context.read<AuthCubit>().state.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لم يتم العثور على بيانات المستخدم',
          ),
        ),
      );
      return;
    }
    final userId = user.id;
    final categoryId =
        context.read<CategoryCubit>().state.selectedCategoryId;
    final amount = double.tryParse(
      amountController.text,
    );
    final type =
        context.read<TransactionCubit>().state.selectedType;
    final description = descriptionController.text.trim();
    final selectedDate =
        context.read<TransactionCubit>().state.selectedDate;

    if (categoryId == null ||
        amount == null ||
        type == null ||
        description.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء ملء جميع الحقول'),
        ),
      );
      return;
    }
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء إدخال مبلغ صحيح'),
        ),
      );
      return;
    }
    final transaction = TransactionModel(
      userId: userId,
      categoryId: categoryId,
      amount: amount,
      type: type,
      description: description,
      transactionDate: selectedDate,
    );

    context
        .read<TransactionCubit>()
        .createTransaction(transaction);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة عملية'), centerTitle: true),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state.status == EnTransactionStatus.success) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            }
          } else if (state.status == EnTransactionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'حدث خطأ أثناء إضافة العملية'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(AppSize.ph16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TotalBalanceCardWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<TransactionCubit>()
                              .selectTransactionType('income');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              state.selectedType == 'income'
                                  ? AppLightColors.primaryColor
                                  : AppLightColors.wightColor,
                          foregroundColor:
                              state.selectedType == 'income'
                                  ? AppLightColors.wightColor
                                  : AppLightColors.mainTextColor,
                        ),
                        child: Text("دخل"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<TransactionCubit>()
                              .selectTransactionType('expense');
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              state.selectedType == 'expense'
                                  ? AppLightColors.primaryColor
                                  : AppLightColors.wightColor,
                          foregroundColor:
                              state.selectedType == 'expense'
                                  ? AppLightColors.wightColor
                                  : AppLightColors.mainTextColor,
                        ),
                        child: Text("مصروف"),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.h24),
                  CustomTextFormField(
                    controller: descriptionController,
                    hintText: 'مشتريات البقالة',
                    title: 'العنوان',
                    maxLines: 1,
                  ),
                  SizedBox(height: AppSize.h12),
                  Text(
                    'الفئة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSize.h12),

                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return DropdownFlutter<String>(
                        hintText: 'اختر الفئة',

                        items:
                            state.categories
                                .map((category) => category.categoryName)
                                .toList(),

                        decoration: CustomDropdownDecoration(
                          closedFillColor: AppLightColors.wightColor,
                          closedBorderRadius: BorderRadius.circular(
                            AppSize.w10,
                          ),
                          closedBorder: Border.all(
                            color: AppLightColors.strokeColor,
                            width: 1,
                          ),
                        ),

                        onChanged: (value) {
                          if (value == null) return;

                          final selectedCategory = state.categories.firstWhere(
                            (category) => category.categoryName == value,
                          );
                          context.read<CategoryCubit>().selectedCategory(
                            selectedCategory.categoryId,
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: AppSize.h12),

                  CustomTextFormField(
                    controller: amountController,
                    hintText: ' 0.00',
                    title: 'المبلغ',
                    maxLines: 1,
                  ),

                  SizedBox(height: AppSize.h12),
                  Text(
                    //textAlign: TextAlign.end,
                    'التاريخ',

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSize.h12),

                  DatePickerWidget(),
                  SizedBox(height: AppSize.h24),

                  ElevatedButton(
                    onPressed:
                        state.status == EnTransactionStatus.loading
                            ? null :_saveTransaction,
                            // : () {
                            //   final user = context.read<AuthCubit>().state.user;

                            //   if (user == null) {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //         content: Text(
                            //           'لم يتم العثور على بيانات المستخدم',
                            //         ),
                            //       ),
                            //     );
                            //     return;
                            //   }
                            //   final userId = user.id;
                            //   final categoryId =
                            //       context
                            //           .read<CategoryCubit>()
                            //           .state
                            //           .selectedCategoryId;
                            //   final amount = double.tryParse(
                            //     amountController.text,
                            //   );
                            //   final type =
                            //       context
                            //           .read<TransactionCubit>()
                            //           .state
                            //           .selectedType;
                            //   final description = descriptionController.text;
                            //   final selectedDate =
                            //       context
                            //           .read<TransactionCubit>()
                            //           .state
                            //           .selectedDate;

                            //   if (categoryId == null ||
                            //       amount == null ||
                            //       type == null ||
                            //       description.isEmpty ||
                            //       selectedDate == null) {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         content: Text('الرجاء ملء جميع الحقول'),
                            //       ),
                            //     );
                            //     return;
                            //   }
                            //   if (amount <= 0) {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         content: Text('الرجاء إدخال مبلغ صحيح'),
                            //       ),
                            //     );
                            //     return;
                            //   }
                            //   final transaction = TransactionModel(
                            //     userId: userId,
                            //     categoryId: categoryId,
                            //     amount: amount,
                            //     type: type,
                            //     description: description,
                            //     transactionDate: selectedDate,
                            //   );

                            //   context
                            //       .read<TransactionCubit>()
                            //       .createTransaction(transaction);
                            // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppLightColors.primaryColor,
                      minimumSize: Size(AppSize.w350, AppSize.h60),
                    ),
                    child:
                        state.status == EnTransactionStatus.loading
                            ? CircularProgressIndicator()
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'حفظ العملية',
                                  style: TextStyle(
                                    color: AppLightColors.wightColor,
                                    fontSize: AppSize.sp16,
                                  ),
                                ),
                                SizedBox(width: AppSize.w8),
                                Icon(
                                  Icons.save_as_outlined,
                                  color: AppLightColors.wightColor,
                                  size: 18,
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
