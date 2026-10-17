import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/core/widgets/custom_text_form_field.dart';
import 'package:masroof_app/features/categories/presentation/cubit/cubit/category_cubit.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_data_model.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_model.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';

class EditTransactionBottomSheet extends StatefulWidget {
  final TransactionDataModel transaction;

  const EditTransactionBottomSheet({super.key, required this.transaction});

  @override
  State<EditTransactionBottomSheet> createState() =>
      _EditTransactionBottomSheetState();
}

class _EditTransactionBottomSheetState
    extends State<EditTransactionBottomSheet> {
  late final TextEditingController descriptionController;
  late final TextEditingController amountController;

  late String selectedType;
  late DateTime selectedDate;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController(
      text: widget.transaction.description,
    );

    amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );

    selectedType = widget.transaction.type;

    selectedDate = DateTime.parse(widget.transaction.transactionDate);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    if (!_validateInputs()) return;
    setState(() {
      _isSaving = true;
    });

    try {
      final cubit = context.read<TransactionCubit>();

      await cubit.updateTransaction(
        widget.transaction.transactionId,
        _buildTransactionModel(),
      );

      if (!mounted) return;

      if (cubit.state.status == EnTransactionStatus.success) {
        Navigator.of(context).pop(true);
      } else {
        final message = cubit.state.message ?? '';

        if (message == 'No changes were made') {
          final shouldReturnHome = await _showNoChangesDialog();
          if (!mounted) return;
          if (shouldReturnHome == true) {
            Navigator.of(context).pop(true);
            return;
          }
        } else {
          _showErrorMessage(message);
        }

        if (!mounted) return;

        setState(() {
          _isSaving = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تعديل العملية')),
      );
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.isEmpty ? 'حدث خطأ أثناء تعديل العملية' : message,
        ),
      ),
    );
  }

  TransactionModel _buildTransactionModel() {
    return TransactionModel(
      userId: widget.transaction.userId,
      categoryId: context.read<CategoryCubit>().state.selectedCategoryId!,
      amount: double.parse(amountController.text.trim()),
      type: selectedType,
      description: descriptionController.text.trim(),
      transactionDate: selectedDate,
    );
  }

  bool _validateInputs() {
    final description = descriptionController.text.trim();
    final amount = double.tryParse(amountController.text.trim());
    final categoryId = context.read<CategoryCubit>().state.selectedCategoryId;

    if (description.isEmpty ||
        amount == null ||
        amount <= 0 ||
        categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول بشكل صحيح')),
      );
      return false;
    }
    return true;
  }

  Future<bool?> _showNoChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تنبيه'),
          content: const Text(
            'لم يتم إجراء أي تعديل على العملية. '
            'هل تريد العودة إلى الشاشة الرئيسية؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('موافق'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSize.ph16,
          right: AppSize.ph16,
          top: AppSize.h16,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSize.h16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================
              // العنوان
              // ==========================
              Center(
                child: Text(
                  'تعديل العملية',
                  style: TextStyle(
                    fontSize: AppSize.sp20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: AppSize.h24),

              // ==========================
              // نوع العملية
              // ==========================
              Text(
                'نوع العملية',
                style: TextStyle(
                  fontSize: AppSize.sp16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: AppSize.h12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedType = 'income';
                        });

                        context.read<TransactionCubit>().selectTransactionType(
                          'income',
                        );

                        context.read<CategoryCubit>().clearSelectedCategory();

                        context.read<CategoryCubit>().getCategories('income');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedType == 'income'
                                ? AppLightColors.primaryColor
                                : AppLightColors.wightColor,
                        foregroundColor:
                            selectedType == 'income'
                                ? AppLightColors.wightColor
                                : AppLightColors.mainTextColor,
                      ),
                      child: const Text('دخل'),
                    ),
                  ),

                  SizedBox(width: AppSize.w12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedType = 'expense';
                        });

                        context.read<TransactionCubit>().selectTransactionType(
                          'expense',
                        );

                        context.read<CategoryCubit>().clearSelectedCategory();

                        context.read<CategoryCubit>().getCategories('expense');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedType == 'expense'
                                ? AppLightColors.primaryColor
                                : AppLightColors.wightColor,
                        foregroundColor:
                            selectedType == 'expense'
                                ? AppLightColors.wightColor
                                : AppLightColors.mainTextColor,
                      ),
                      child: const Text('مصروف'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.h16),

              // ==========================
              // الوصف
              // ==========================
              CustomTextFormField(
                controller: descriptionController,
                hintText: 'الوصف',
                title: 'الوصف',
                maxLines: 1,
              ),

              SizedBox(height: AppSize.h12),

              // ==========================
              // المبلغ
              // ==========================
              CustomTextFormField(
                controller: amountController,
                hintText: '0.00',
                title: 'المبلغ',
                maxLines: 1,
              ),

              SizedBox(height: AppSize.h16),

              // ==========================
              // الفئة
              // ==========================
              Text(
                'الفئة',
                style: TextStyle(
                  fontSize: AppSize.sp16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: AppSize.h12),

              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state.status == EnCategoryStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.categories.isEmpty) {
                    return const Text('لا توجد فئات');
                  }

                  final selectedCategoryValue =
                      state.categories.any(
                            (category) =>
                                category.categoryId == state.selectedCategoryId,
                          )
                          ? state.selectedCategoryId
                          : null;

                  return DropdownFlutter<String>(
                    key: ValueKey(
                      state.categories
                          .map((category) => category.categoryId)
                          .join('-'),
                    ),
                    hintText: 'اختر الفئة',
                    items:
                        state.categories
                            .map((category) => category.categoryName)
                            .toList(),
                    decoration: CustomDropdownDecoration(
                      closedFillColor: AppLightColors.wightColor,
                      closedBorderRadius: BorderRadius.circular(AppSize.w10),
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

              SizedBox(height: AppSize.h16),

              // ==========================
              // التاريخ
              // ==========================
              Text(
                'التاريخ',
                style: TextStyle(
                  fontSize: AppSize.sp16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: AppSize.h8),

              InkWell(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSize.w16),
                  decoration: BoxDecoration(
                    color: AppLightColors.wightColor,
                    border: Border.all(color: AppLightColors.strokeColor),
                    borderRadius: BorderRadius.circular(AppSize.w10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      SizedBox(width: AppSize.w12),
                      Text(_formatDate(selectedDate)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSize.h24),

              // ==========================
              // حفظ
              // ==========================
              SizedBox(
                width: double.infinity,
                height: AppSize.h52,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightColors.primaryColor,
                    foregroundColor: AppLightColors.wightColor,
                  ),
                  child: const Text('حفظ التعديل'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    setState(() {
      selectedDate = selected;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
