import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_hw/services/auth_service.dart';
import 'package:flutter_hw/services/firestore_service.dart';
import 'package:flutter_hw/services/media_service.dart';
import 'package:flutter_hw/services/navigation_service.dart';
import 'package:flutter_hw/services/storage_service.dart';
import 'package:flutter_hw/services/toast_service.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<ToastService>(
    ToastService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );
  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
  getIt.registerSingleton<FirestoreService>(
    FirestoreService(),
  );
}
