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
import 'core/services/sync_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  try {
    await Hive.initFlutter();
    
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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: SmartQueueApp(),
    ),
  );
}

class SmartQueueApp extends ConsumerStatefulWidget {
  const SmartQueueApp({super.key});

  @override
  ConsumerState<SmartQueueApp> createState() => _SmartQueueAppState();
}

class _SmartQueueAppState extends ConsumerState<SmartQueueApp> {
  @override
  void initState() {
    super.initState();
    // Start background sync listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncServiceProvider).startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
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
