import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wamo/bloc/wallpaper_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'model/wallpaper.dart';
import 'view/main_page.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(WallpaperImageAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
      );
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
        backgroundColor: const Color(0xFF202124),
        cardColor: const Color(0xFF303134),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
