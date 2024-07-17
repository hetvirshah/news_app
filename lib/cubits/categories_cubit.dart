import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/class%20models/categories_class.dart';

abstract class Categoriesstate {}

class CategoryInitial extends Categoriesstate {}

class CategoryFetchInProgress extends Categoriesstate {}

class CategoryFetchFailure extends Categoriesstate {
  final String errorMessage;

  CategoryFetchFailure({required this.errorMessage});
}

class CategoryFetchSuccess extends Categoriesstate {
  final List<Category> categories;
  final bool FetchError;
  final bool FetchInProgress;

  CategoryFetchSuccess({
    required this.categories,
    required this.FetchError,
    required this.FetchInProgress,
  });

  CategoryFetchSuccess copyWith({
    List<Category>? newcategories,
    bool? newFetchMoreError,
    bool? newFetchError,
  }) {
    return CategoryFetchSuccess(
      categories: newcategories ?? categories,
      FetchError: newFetchError ?? FetchError,
      FetchInProgress: newFetchMoreError ?? FetchInProgress,
    );
  }
}

class CategoriesCubit extends Cubit<Categoriesstate> {
  CategoriesCubit() : super(CategoryInitial());
  bool isLoading() {
    if (state is CategoryFetchInProgress) {
      return true;
    }
    return false;
  }

  final Dio _dio = Dio();

  Future<void> fetchCategories() async {
    try {
      emit(CategoryFetchInProgress());

      final response = await _dio.get(
        'https://api.currentsapi.services/v1/available/categories',
      );

      if (response.statusCode == 200) {
        var getData = response.data;
        List<dynamic> categoriesData = getData['categories'];

        List<Category> fetchedCategories = categoriesData
            .map((category) => Category.fromJson({'name': category}))
            .toList();

        emit(CategoryFetchSuccess(
            categories: fetchedCategories,
            FetchError: false,
            FetchInProgress: false));
      }
    } catch (e) {
      emit(CategoryFetchFailure(
        errorMessage: e.toString(),
      ));
    }
  }
}
