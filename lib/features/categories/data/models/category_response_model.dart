import 'package:masroof_app/features/categories/data/models/category_model.dart';

class CategoryResponseModel {
  final bool status;
  final String message;
  final List<CategoryModel> categories;

  CategoryResponseModel({
    required this.status,
    required this.message,
    required this.categories,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      status: json['status'],
      message: json['message'],
      categories:
          (json['categories'] as List)
              .map((category) => CategoryModel.fromJson(category))
              .toList(),
    );
  }
}
