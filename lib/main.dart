import 'package:flutter/material.dart';
import 'package:whether_app/whether_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
	await dotenv.load(fileName: '.env');
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
    return MaterialApp(
      title: 'Flutter Demo',
			debugShowCheckedModeBanner: false,
			theme: ThemeData.dark(
				useMaterial3: true
			),
			home: const WeatherScreen(),
    );
  }
}
