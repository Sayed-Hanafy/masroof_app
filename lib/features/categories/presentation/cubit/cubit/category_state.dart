part of 'category_cubit.dart';

enum EnCategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  final EnCategoryStatus status;
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final String? message;

  const CategoryState({
    this.status = EnCategoryStatus.initial,
    this.categories = const [],
    this.selectedCategoryId,
    this.message,
  });

  CategoryState copyWith({
    EnCategoryStatus? status,
    List<CategoryModel>? categories,
    int? selectedCategoryId,
    String? message,
    bool clearSelectedCategory = false,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategoryId:
          clearSelectedCategory
              ? null
              : selectedCategoryId ?? this.selectedCategoryId,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, categories, selectedCategoryId, message];
}
