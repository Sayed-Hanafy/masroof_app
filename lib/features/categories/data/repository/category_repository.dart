import 'package:masroof_app/features/categories/data/models/category_response_model.dart';
import 'package:masroof_app/features/categories/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService categoryService;

  CategoryRepository({required this.categoryService});

  Future<CategoryResponseModel> getCategories(int userId) async {
    final response = await categoryService.getCategories(userId: userId);

    return CategoryResponseModel.fromJson(response);
  }
}
