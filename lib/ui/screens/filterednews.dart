import 'package:flutter/material.dart';
import 'package:news/utils/constant.dart';

import 'latestnews.dart';

class FilteredNews extends StatefulWidget {
  final String countryCode;
  final String categories;
  final String languages;

  const FilteredNews(
      {super.key,
      this.countryCode = "",
      this.categories = "",
      this.languages = ""});

  @override
  State<FilteredNews> createState() => _FilteredNewsState();
}

class _FilteredNewsState extends State<FilteredNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: News(
        countryCode: widget.countryCode,
        languages: widget.languages,
        categories: widget.categories,
        apiUrl: findEndPt,
      ),
    );
  }
}
