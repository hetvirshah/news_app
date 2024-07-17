import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/categories_cubit.dart';
import 'package:news/cubits/language_cubit.dart';
import 'package:news/cubits/news_cubit.dart';
import 'package:news/cubits/region_cubit.dart';
import 'package:news/ui/screens/homescreen.dart';

Future<void> initilizaApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsCubit>(create: (_) => NewsCubit()),
        BlocProvider<RegionCubit>(create: (_) => RegionCubit()),
        BlocProvider<CategoriesCubit>(create: (_) => CategoriesCubit()),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
      ],
      child: MaterialApp(
          home: HomeScreen(),
          theme: ThemeData(
              listTileTheme: ListTileThemeData(tileColor: Colors.white),
              cardTheme:
                  CardTheme(color: Colors.white, shadowColor: Colors.white),
              scaffoldBackgroundColor:
                  Colors.white, // Change the scaffold background color
              tabBarTheme: TabBarTheme(labelColor: Colors.black))),
    );
  }
}
