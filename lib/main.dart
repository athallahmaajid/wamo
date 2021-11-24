import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamo/bloc/wallpaper_bloc.dart';
import 'view/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<WallpaperBloc>(
        create: (context) => WallpaperBloc()..add(WallpaperEvent()),
        child: const MainPage(),
      ),
      theme: ThemeData(
        backgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        backgroundColor: const Color(0xFF1e1e1e),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
