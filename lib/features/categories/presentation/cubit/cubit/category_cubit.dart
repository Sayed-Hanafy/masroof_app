import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masroof_app/features/categories/data/models/category_model.dart';
import 'package:masroof_app/features/categories/data/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryCubit(this.categoryRepository) : super(const CategoryState());

  Future<void> getCategories(String type, {int? selectedCategoryId}) async {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: EnCategoryStatus.loading,
        categories: [],
        clearSelectedCategory: true,
      ),
    );

    try {
      final categoryResponse = await categoryRepository.getCategories(type);

      if (isClosed) return;

      if (!categoryResponse.status) {
        emit(
          state.copyWith(
            status: EnCategoryStatus.failure,
            message: categoryResponse.message,
          ),
        );
        return;
      }

      final categories = categoryResponse.categories;

      int? categoryToSelect;

      if (selectedCategoryId != null) {
        final exists = categories.any(
          (category) => category.categoryId == selectedCategoryId,
        );

        if (exists) {
          categoryToSelect = selectedCategoryId;
        }
      }

      emit(
        state.copyWith(
          status: EnCategoryStatus.success,
          categories: categories,
          selectedCategoryId: categoryToSelect,
          message: categoryResponse.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

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

  void clearSelectedCategory() {
    emit(state.copyWith(clearSelectedCategory: true));
  }
}
