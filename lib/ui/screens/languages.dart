// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/language_cubit.dart';
import 'package:news/ui/screens/filterednews.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen>
    with AutomaticKeepAliveClientMixin {
  late LanguageCubit languageCubit;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      languageCubit = context.read<LanguageCubit>();
      languageCubit.fetchLanguages();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchlanguages() {
    context.read<LanguageCubit>().fetchLanguages();
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
          Text('no languages found' + errorMessageCode),
          ElevatedButton(onPressed: onTapRetry(), child: Text('retry'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (BuildContext context, state) {
          if (state is LanguageInitial || state is LanguageFetchInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LanguageFetchSuccess) {
            return ListView.builder(
              itemCount: state.languages.length,
              itemBuilder: (context, index) {
                final language = state.languages[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FilteredNews(languages: language.queryCode)),
                  ),
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromRGBO(236, 35, 35, 1),
                            child: Text(
                              language.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              language.name,
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
          if (state is LanguageFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: () {
                  context.read<LanguageCubit>().fetchLanguages();
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
