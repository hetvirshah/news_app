import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/class%20models/language_class.dart';

abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageFetchInProgress extends LanguageState {}

class LanguageFetchFailure extends LanguageState {
  final String errorMessage;

  LanguageFetchFailure({required this.errorMessage});
}

class LanguageFetchSuccess extends LanguageState {
  final List<Region> languages;
  final bool FetchError;
  final bool FetchInProgress;

  LanguageFetchSuccess({
    required this.languages,
    required this.FetchError,
    required this.FetchInProgress,
  });

  LanguageFetchSuccess copyWith({
    List<Region>? newlanguages,
    bool? fetchinprogress,
    bool? newFetchError,
  }) {
    return LanguageFetchSuccess(
      languages: newlanguages ?? languages,
      FetchError: newFetchError ?? FetchError,
      FetchInProgress: fetchinprogress ?? FetchInProgress,
    );
  }
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());
  bool isLoading() {
    if (state is LanguageFetchInProgress) {
      return true;
    }
    return false;
  }

  final Dio _dio = Dio();

  Future<void> fetchLanguages() async {
    try {
      emit(LanguageFetchInProgress());

      final response = await _dio.get(
        'https://api.currentsapi.services/v1/available/languages',
      );

      if (response.statusCode == 200) {
        var getData = response.data;
        var results = getData['languages'] as Map<String, dynamic>;

        List<Region> fetchedLanguages = results.entries
            .map((entry) => Region.fromJson({
                  'name': entry.key,
                  'queryCode': entry.value,
                }))
            .toList();

        emit(LanguageFetchSuccess(
            languages: fetchedLanguages,
            FetchError: false,
            FetchInProgress: false));
      }
    } catch (e) {
      emit(LanguageFetchFailure(
        errorMessage: e.toString(),
      ));
    }
  }
}
