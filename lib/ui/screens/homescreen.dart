import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/cubits/news_cubit.dart';
import 'package:news/ui/screens/categories.dart';
import 'package:news/ui/screens/languages.dart';
import 'package:news/ui/screens/latestnews.dart';
import 'package:news/ui/screens/regions.dart';
import 'package:news/utils/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: DefaultTabController(
        length: 4, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(236, 35, 35, 0.151),
            title: Center(
              child: Text(
                'News',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              indicatorColor: Color.fromRGBO(236, 35, 35, 1),
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.fill,
              labelPadding: EdgeInsets.symmetric(horizontal: 7.0),
              indicatorWeight: 2,
              tabs: [
                Tab(text: 'Latest'),
                Tab(text: 'Categories'),
                Tab(text: 'Regions'),
                Tab(text: 'Languages'),
              ],
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              children: [
                News(apiUrl: newsEndPt),
                CategoriesScreen(),
                RegionsScreen(),
                LanguagesScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
