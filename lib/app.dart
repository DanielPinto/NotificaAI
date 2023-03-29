import 'package:appnotify/routes/routes.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool statusChange = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification',
      theme: ThemeData(primarySwatch: Colors.amber),
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
