import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hw/firebase.dart';
import 'package:flutter_hw/services/auth_service.dart';
import 'package:flutter_hw/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  //await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();

  // Registers the needed services as singletions with GetIt
  await registerServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;

  late final NavigationService _navigationService;
  late final AuthService _authService;

  MyApp({super.key}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      title: 'Flutter Homework',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: GoogleFonts.montserratTextTheme()),
      debugShowCheckedModeBanner: false,
      routes: _navigationService.routes,
      initialRoute: _authService.user != null ? "/" : "/login",
    );
  }
}
