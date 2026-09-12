import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masroof_app/features/categories/data/models/category_model.dart';
import 'package:masroof_app/features/categories/data/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryRepository categoryRepository;
  CategoryCubit(this.categoryRepository) : super(CategoryState());

  Future<void> getCategories(int userId) async {
    emit(state.copyWith(status: EnCategoryStatus.loading));
    try {
      final categoryResponse = await categoryRepository.getCategories(userId);
      if (categoryResponse.status) {
        emit(
          state.copyWith(
            status: EnCategoryStatus.success,
            categories: categoryResponse.categories,
            message: categoryResponse.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EnCategoryStatus.failure,
            message: categoryResponse.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EnCategoryStatus.failure,
          message: 'حدث خطأ أثناء جلب الفئات',
        ),
      );
    }
  }

  void selectedCategory(int categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }
}
