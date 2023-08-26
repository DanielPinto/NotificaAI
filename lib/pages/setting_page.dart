import 'package:appnotify/models/zone_model.dart';
import 'package:appnotify/pages/widgets/stack_network_connection.dart';
import 'package:appnotify/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool changeData = true;
  late ZoneModel selectedItem;
  late FirebaseStoregeService firebaseStoregeServiceProvider;

  @override
  void initState() {
    super.initState();
    firebaseStoregeServiceProvider =
        Provider.of<FirebaseStoregeService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Informa.AI"),
        backgroundColor: Colors.amber[200],
      ),
      body: StackNetworkConnection(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 36.0),
                child: Text(
                  "Selecione a sua Regional.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "Você pode selecionar outras Regionais.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              getBody(),
              firebaseStoregeServiceProvider.conditionals.length == 2
                  ? const Padding(
                      padding: EdgeInsets.only(top: 27.0),
                      child: Text(
                          "* você deve ter no minimo uma região selecionada!",
                          style: TextStyle(color: Colors.redAccent)),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCard(ZoneModel zone) => SwitchListTile(
        title: Text(zone.description),
        onChanged: (bool val) {
          firebaseStoregeServiceProvider.subscribeOrUnSubscribe(zone.id);
          setState(() {});
        },
        value: firebaseStoregeServiceProvider.conditionals.contains(zone.id),
        activeColor: Colors.amber[600],
      );

  Widget getBody() => Container(
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: firebaseStoregeServiceProvider.listZones.length,
            itemBuilder: (context, index) {
              return firebaseStoregeServiceProvider.listZones[index].sigla !=
                      "TODAS"
                  ? getCard(firebaseStoregeServiceProvider.listZones[index])
                  : Container();
            }),
      );
}
