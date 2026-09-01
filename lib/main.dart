import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 날짜/요일 로케일 초기화
  await initializeDateFormatting('ko_KR', null);

  runApp(const ZzipApp());
}

class ZzipApp extends StatelessWidget {
  const ZzipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZZIP',

      // 한국어
      locale: const Locale('ko', 'KR'),

      // Flutter Material/Cupertino 위젯 한국어 지원
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],

      theme: ThemeData(
        fontFamily: 'Arial',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE43F68),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}