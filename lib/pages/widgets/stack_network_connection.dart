import 'dart:ui';
import 'package:appnotify/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StackNetworkConnection extends StatelessWidget {
  Widget child;
  StackNetworkConnection({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double botton = MediaQuery.of(context).size.height / 2;
    var status = Provider.of<NetworkStatus>(context);
    return Stack(fit: StackFit.expand, children: [
      child,
      if (!(status == NetworkStatus.online))
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade200.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.wifi_off_outlined,
                    size: 36,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: botton),
                    child: const Text(
                      'Verifique seu sinal de Internet',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }
}
