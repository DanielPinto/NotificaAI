import 'dart:convert';

import 'package:appnotify/routes/routes.dart';
import 'package:appnotify/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;
  late CustomNotification _custonNotification;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    _getPermission();
    getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  Future<bool> _getPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getDeviceFirebaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token.toString();
  }

  void _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _custonNotification = CustomNotification(
          id: android.hashCode,
          title: notification.title!,
          body: notification.body!,
          payload: message.data['route'],
        );

        _notificationService.showNotification(_custonNotification);
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    if (message.data['route'] != null) {
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushNamed(message.data['route']);
    }
  }
}
