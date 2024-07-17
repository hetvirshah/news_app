import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/repository/news_repo.dart';

import '../data/class models/news_class.dart';
import '../utils/constant.dart';

abstract class NewsFetchState {}

class NewsFetchStateInit extends NewsFetchState {}

class NewsFetchStateLoading extends NewsFetchState {}

class NewsFetchStateSuccess extends NewsFetchState {
  final List<News> latestNews;
  final bool hasMoreData;
  NewsFetchStateSuccess(this.latestNews, this.hasMoreData);
}

class NewsFetchStateFailure extends NewsFetchState {
  final String errorMsg;
  NewsFetchStateFailure(this.errorMsg);
}

class NewsCubit extends Cubit<NewsFetchState> {
  NewsCubit() : super(NewsFetchStateInit());
  List<News> moreNews = [];
  int currentPage = 1;
  bool isDataAvailable = true;
  Future<void> fetchNews({
    int pageNo = 1,
    String apiUrl = newsEndPt,
    String countryCode = "",
    String language = "",
    String categories = "",
  }) async {
    if (pageNo == 1) {
      emit(NewsFetchStateLoading());
    }

    try {
      final News = await NewsRepository.getNews(
          pageNo: pageNo,
          apiUrl: apiUrl,
          countryCode: countryCode,
          language: language,
          categories: categories);
      isDataAvailable = News.isNotEmpty;
      if (kDebugMode) {
        print("The dart obj of the news:$News");
      }
      if (pageNo == 1) {
        moreNews = News;
      } else {
        moreNews.addAll(News);
      }
      emit(NewsFetchStateSuccess(moreNews, isDataAvailable));
    } catch (e) {
      emit(NewsFetchStateFailure(e.toString()));
    }
  }

  Future<void> fetchMoreNews(
      {String apiUrl = newsEndPt,
      String countryCode = "",
      String language = "",
      String categories = ""}) async {
    if (isDataAvailable) {
      currentPage++;
      await fetchNews(
          pageNo: currentPage,
          apiUrl: apiUrl,
          countryCode: countryCode,
          language: language,
          categories: categories);
    }
  }
}
