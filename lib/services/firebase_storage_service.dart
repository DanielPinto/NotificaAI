import 'package:appnotify/models/notify_model.dart';
import 'package:appnotify/models/zone_model.dart';
import 'package:appnotify/services/firebase_messaging_service.dart';
import 'package:appnotify/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseStoregeService {
  List<ZoneModel> listZones = [];
  List<String> conditionals = [];
  List<NotifyModel> notifications = [];
  Dio dio = Dio();

  late FirebaseStoregeService firebaseStoregeServiceProvider;

  initialize() async {
    if (listZones.isEmpty) {
      await readList('zone');
    }

    await getZonesSubscribe();

    await getNotifications();
  }

  Future<void> readList(String collection) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .get()
          .then((value) {
        for (var element in value.docs) {
          listZones.add(ZoneModel.fromJson(element.data()));
        }
      });
    } on Exception {
      rethrow;
    }
  }

  Future<void> getZonesSubscribe() async {
    try {
      late String token;
      await FirebaseMessagingService(NotificationService())
          .getDeviceFirebaseToken()
          .then((value) => token = value);

      print("TOKEN: " + token);

      Response response = await dio.get(
        'https://iid.googleapis.com/iid/info/$token?details=true',
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAA5mCU7Qs:APA91bH6vYgUYCaj_Lg1bfbfdLSyAaX07C89BzIH-AR-92KvbJxFMjsFFmWmw00NmF4aAVZCaooyW_8uiYcOLhpzW1yv565iaCe9XexyPXjEohL_6yKt8EGarOTooURpsg993lvUfNeF",
        }),
      );

      for (var element in listZones) {
        if (response.data['rel'] != null) {
          if (response.data['rel']['topics'][element.id] != null) {
            conditionals.add(element.id);
          }
        }
      }

      if (conditionals.isEmpty) {
        conditionalsEmptyPopulate();
      }
    } on Exception {
      rethrow;
    }
  }

  Future<bool> conditionalsEmptyPopulate() async {
    try {
      late bool ok;

      for (var element in listZones) {
        subscribeOrUnSubscribe(element.id);
        ok = true;
      }

      return ok;
    } on Exception {
      rethrow;
    }
  }

  Future<void> getNotifications() async {
    try {
      notifications.clear();
      await FirebaseFirestore.instance
          .collection('notifications')
          .where("status", isEqualTo: true)
          .where("zones", arrayContainsAny: conditionals)
          .get()
          .then((value) {
        for (var element in value.docs) {
          notifications.add(NotifyModel.fromJson(element.data()));
        }
      });
    } on Exception {
      rethrow;
    }
  }

  void subscribeOrUnSubscribe(String zoneId) {
    try {
      if (!conditionals.contains(zoneId)) {
        conditionals.add(zoneId);
        FirebaseMessaging.instance.subscribeToTopic(zoneId);
      } else if (conditionals.length > 2) {
        print(conditionals.length);

        conditionals.remove(zoneId);
        FirebaseMessaging.instance.unsubscribeFromTopic(zoneId);
        print(conditionals.toString());
      }
      getNotifications();
    } on Exception {
      rethrow;
    }
  }
}
