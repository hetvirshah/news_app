// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/categories_cubit.dart';
import 'package:news/ui/screens/filterednews.dart';
import 'package:news/ui/screens/latestnews.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin {
  late CategoriesCubit categoriesCubit;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      categoriesCubit = context.read<CategoriesCubit>();
      categoriesCubit.fetchCategories();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchCategories() {
    context.read<CategoriesCubit>().fetchCategories();
  }

  Widget ErrorContainer(
      {required String errorMessageCode, required Null Function() onTapRetry}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: MediaQuery.of(context).size.width * (0.075),
      ),
      child: Column(
        children: [
          Text('no categories found' + errorMessageCode),
          ElevatedButton(onPressed: onTapRetry(), child: Text('retry'))
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<CategoriesCubit, Categoriesstate>(
        builder: (BuildContext context, state) {
          if (state is CategoryInitial || state is CategoryFetchInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryFetchSuccess) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FilteredNews(categories: category.name)),
                  ),
                  child: Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: Color.fromRGBO(236, 35, 35, 1),
                            size: 30,
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (state is CategoryFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: () {
                  context.read<CategoriesCubit>().fetchCategories();
                },
              ),
            );
          } else {
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
