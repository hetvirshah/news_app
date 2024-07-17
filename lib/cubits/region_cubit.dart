import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/data/class%20models/language_class.dart';

abstract class RegionState {}

class RegionInitial extends RegionState {}

class RegionFetchInProgress extends RegionState {}

class RegionFetchFailure extends RegionState {
  final String errorMessage;

  RegionFetchFailure({required this.errorMessage});
}

class RegionFetchSuccess extends RegionState {
  final List<Region> regions;
  final bool FetchError;
  final bool FetchInProgress;

  RegionFetchSuccess({
    required this.regions,
    required this.FetchError,
    required this.FetchInProgress,
  });

  RegionFetchSuccess copyWith({
    List<Region>? newregions,
    bool? newFetchMoreError,
    bool? newFetchError,
  }) {
    return RegionFetchSuccess(
      regions: newregions ?? regions,
      FetchError: newFetchError ?? FetchError,
      FetchInProgress: newFetchMoreError ?? FetchInProgress,
    );
  }
}

class RegionCubit extends Cubit<RegionState> {
  RegionCubit() : super(RegionInitial());
  bool isLoading() {
    if (state is RegionFetchInProgress) {
      return true;
    }
    return false;
  }

  final Dio _dio = Dio();

  Future<void> fetchRegions() async {
    try {
      emit(RegionFetchInProgress());

      final response = await _dio.get(
        'https://api.currentsapi.services/v1/available/regions',
      );

      if (response.statusCode == 200) {
        var getData = response.data;
        var results = getData['regions'] as Map<String, dynamic>;

        List<Region> fetchedRegions = results.entries
            .map((entry) => Region.fromJson({
                  'name': entry.key,
                  'queryCode': entry.value,
                }))
            .toList();

        emit(RegionFetchSuccess(
            regions: fetchedRegions,
            FetchError: false,
            FetchInProgress: false));
      }
    } catch (e) {
      emit(RegionFetchFailure(
        errorMessage: e.toString(),
      ));
    }
  }
}
