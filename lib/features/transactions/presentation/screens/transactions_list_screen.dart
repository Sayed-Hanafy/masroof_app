import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/search_textbox.dart';

class TransactionsListScreen extends StatelessWidget {
  TransactionsListScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final List category = ['الفئات', 'المصروفات', 'الدخل', 'الكل'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.notification_add_outlined),
              Spacer(),
              Text('قائمة العمليات'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.ph16),
        child: Column(
          children: [
            SearchTextbox(
              controller: searchController,
              hintText: 'بحث عن معاملة',
            ),

            SizedBox(height: AppSize.h16),

            SizedBox(
              height: 50,
              child: ListView.separated(
                itemCount: category.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: AppSize.w16);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppLightColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        category[index],
                        style: TextStyle(color: AppLightColors.wightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSize.h16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ Text('اليوم', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),Text('15 مايو 2025'),],
            ),
          ],
        ),
      ),
    );
  }
}
