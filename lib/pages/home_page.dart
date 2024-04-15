import 'package:flutter/material.dart';
import 'package:flutter_hw/services/auth_service.dart';
import 'package:flutter_hw/services/navigation_service.dart';
import 'package:flutter_hw/services/toast_service.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late final AuthService _authService;
  late final NavigationService _navigationService;
  late final ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _toastService = _getIt.get<ToastService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Homework'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _navigationService.pushReplacementNamed('/login');
              } else {
                _toastService.showToast(
                  text: 'An error occurred while logging out!',
                  icon: Icons.error,
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Welcome to the Home Page!'),
        ),
      ),
    );
  }
}
