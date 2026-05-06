import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'data/models/appointment_model.dart';
import 'data/models/queue_token_model.dart';
import 'data/models/user_model.dart';
import 'data/models/admin_model.dart';
import 'data/models/sync_task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  try {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register Adapters
    Hive.registerAdapter(AppointmentAdapter());
    Hive.registerAdapter(QueueTokenAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(AdminAdapter());
    Hive.registerAdapter(SyncTaskAdapter());

    // Open Boxes
    await Hive.openBox<Appointment>('appointments');
    await Hive.openBox<QueueToken>('queue_tokens');
    await Hive.openBox<SyncTask>('sync_tasks');
  } catch (e) {
    debugPrint('Hive Initialization failed or already initialized: $e');
  }

  // Initialize Firebase
  try {
    // If you have run `flutterfire configure`, you can use DefaultFirebaseOptions.currentPlatform
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    debugPrint('Please ensure you have run `flutterfire configure` to generate firebase_options.dart');
  }

  runApp(
    const ProviderScope(
      child: SmartQueueApp(),
    ),
  );
}

class SmartQueueApp extends ConsumerWidget {
  const SmartQueueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Smart Queue Management',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
