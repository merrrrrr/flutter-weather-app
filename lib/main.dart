import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/change_location_screen.dart';
import 'package:weather_app/screens/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
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
			routes: {
				'/changeLocation': (context) => const ChangeLocationScreen(),
				'/settings': (context) => const SettingsScreen(),
			},
			home: const WeatherScreen(),
    );
  }
}
