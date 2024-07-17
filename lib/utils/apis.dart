import 'package:dio/dio.dart';
import 'package:news/utils/constant.dart';

class ApiException {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

class Api {
  static Dio dio = Dio();

  static Future get(String baseUrl, String endPoints,
      {int pageNo = 1,
      String language = "",
      String countryCode = "",
      String category = ""}) async {
    try {
      final response = await dio.get(baseUrl + endPoints,
          options: Options(
            headers: {'Authorization': apikey},
          ),
          queryParameters: {
            "page_number": pageNo,
            if (language.isNotEmpty) "language": language,
            if (countryCode.isNotEmpty) "country": countryCode,
            if (category.isNotEmpty) "category": category
          });
      return response.data["news"];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
