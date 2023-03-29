import 'package:appnotify/app.dart';
import 'package:appnotify/models/notify_model.dart';
import 'package:appnotify/services/firebase_messaging_service.dart';
import 'package:appnotify/services/firebase_storage_service.dart';
import 'package:appnotify/services/network_service.dart';
import 'package:appnotify/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) => FirebaseMessagingService(
            context.read<NotificationService>(),
          ),
        ),
        Provider<FirebaseStoregeService>(
          create: (context) => FirebaseStoregeService(),
        ),
        Provider<NotifyModel>(
          create: (context) => NotifyModel("", "", []),
        ),
        StreamProvider(
            create: (context) => NetworkService().controller.stream,
            initialData: NetworkStatus.online),
      ],
      child: const App(),
    ),
  );
}
