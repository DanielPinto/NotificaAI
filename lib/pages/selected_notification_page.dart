import 'package:appnotify/models/notify_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedNotificationPage extends StatefulWidget {
  const SelectedNotificationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedNotificationPage> createState() =>
      _SelectedNotificationPageState();
}

class _SelectedNotificationPageState extends State<SelectedNotificationPage> {
  late NotifyModel notify;

  @override
  void initState() {
    super.initState();
    notify = Provider.of<NotifyModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Informa.AI'),
          backgroundColor: Colors.amber[200],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              alignment: Alignment.topCenter,
              child: Text(
                notify.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 8.0, 8.0),
              child: Text(
                notify.body,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
