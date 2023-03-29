import 'package:appnotify/pages/selected_notification_page.dart';
import 'package:appnotify/pages/setting_page.dart';
import 'package:flutter/widgets.dart';

import '../pages/notificacao_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/notificacao': (_) => const NotificacaoPage(),
    '/settings': (_) => const SettingPage(),
    '/selected_notification': (_) => const SelectedNotificationPage(),
  };

  static String initial = '/notificacao';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
