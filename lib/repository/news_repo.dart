import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news/data/class%20models/news_class.dart';
import 'package:news/utils/apis.dart';
import 'package:news/utils/constant.dart';

class NewsRepository {
  static Future<List<News>> getNews(
      {int pageNo = 1,
      String apiUrl = newsEndPt,
      String countryCode = "",
      String language = "",
      String categories = ""}) async {
    try {
      final response = await Api.get(baseUrl, newsEndPt,
          pageNo: pageNo,
          countryCode: countryCode,
          language: language,
          category: categories);
      if (kDebugMode) {
        print("API response: $response");
      }
      if (response is List) {
        List<News> latestNews =
            response.map((json) => News.fromJson(json)).toList();
        return latestNews;
      } else {
        throw ApiException("Unexpected response format");
      }
    } on SocketException {
      throw ApiException("your device is no internet connected ");
    } on DioException catch (e) {
      throw ApiException(e.toString());
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
