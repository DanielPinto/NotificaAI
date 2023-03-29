import 'dart:io';
import 'package:appnotify/models/notify_model.dart';
import 'package:appnotify/pages/widgets/stack_network_connection.dart';
import 'package:appnotify/routes/routes.dart';
import 'package:appnotify/services/firebase_messaging_service.dart';
import 'package:appnotify/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NotificacaoPage extends StatefulWidget {
  const NotificacaoPage({super.key});

  @override
  State<NotificacaoPage> createState() => _NotificacaoPageState();
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  bool statusChangeNotifications = false;
  bool isNotifications = false;

  late FirebaseStoregeService firebaseStoregeServiceProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<FirebaseMessagingService>(context, listen: false).initialize();

    firebaseStoregeServiceProvider =
        Provider.of<FirebaseStoregeService>(context, listen: false);

    initializeFirebaseStoregeService().then((value) {
      setState(() {
        statusChangeNotifications = true;
      });
    });
  }

  Future<void> initializeFirebaseStoregeService() async {
    await firebaseStoregeServiceProvider.initialize();
  }

  viewSelectedNotication(int index, BuildContext context) {
    Provider.of<NotifyModel>(context, listen: false)
        .setValues(firebaseStoregeServiceProvider.notifications[index]);
    Navigator.of(Routes.navigatorKey!.currentContext!)
        .pushNamed('/selected_notification');
  }

  settings() => Navigator.of(Routes.navigatorKey!.currentContext!)
      .pushNamed('/settings')
      .then((value) => setState(() {}));

  Future<bool> _onWillPop() async {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancelar",
        style: TextStyle(color: Colors.grey[700], fontSize: 18),
      ),
      onPressed: () => Navigator.of(context).pop(false),
    );

    Widget continueButton = TextButton(
      child: Text(
        "Sair",
        style: TextStyle(color: Colors.redAccent[700], fontSize: 18),
      ),
      onPressed: () => exitApp(),
    );
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.amber[50],
            title: const Text('Atenção'),
            content: const Text('Deseja sair da aplicação?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            icon: Icon(
              Icons.warning_rounded,
              color: Colors.redAccent[700],
              size: 48,
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          ),
        )) ??
        false;
  }

  exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text("Informa.AI"),
          backgroundColor: Colors.amber[200],
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      settings();
                      break;
                    case 1:
                      _onWillPop();
                      break;
                    default:
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Configuração'),
                          Icon(Icons.settings_rounded),
                        ]),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Sair'),
                          Icon(Icons.exit_to_app_outlined),
                        ]),
                  )
                ],
              ),
            )
          ],
        ),
        body: StackNetworkConnection(
          child: statusChangeNotifications
              ? firebaseStoregeServiceProvider.notifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 30,
                            ),
                            Text("Parece que tudo está funcionando!"),
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: firebaseStoregeServiceProvider
                          .notifications.length, //notifications.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          onTap: () => viewSelectedNotication(index, context),
                          title: Text(firebaseStoregeServiceProvider
                              .notifications[index].title),
                          textColor: Colors.amber[600],
                          tileColor: Colors.amber[50],
                          trailing: Icon(
                            Icons.arrow_circle_right,
                            color: Colors.amber[600],
                            size: 30.0,
                          ),
                        ),
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
