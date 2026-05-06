import 'package:flutter/material.dart';

import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/event_setup_screen.dart';
import 'ui/screens/checkin_screen.dart';
import 'ui/screens/logs_search_screen.dart';

class Routes {
  static const String eventSetup = '/event-setup';
  static const String checkIn = '/check-in';
  static const String dashboard = '/dashboard';
  static const String logs = '/logs';

  static Map<String, WidgetBuilder> get routes => {
    eventSetup: (_) => const EventSetupScreen(),
    checkIn: (_) => const CheckInScreen(),
    dashboard: (_) => const DashboardScreen(),
    logs: (_) => const LogsSearchScreen(),
  };
}
