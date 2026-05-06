import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'state/event_manager.dart';
import 'state/log_manager.dart';
import 'ui/theme/app_theme.dart';

class SmartEventApp extends StatelessWidget {
  const SmartEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventManager()),
        ChangeNotifierProvider(create: (_) => LogManager()),
      ],
      child: MaterialApp(
        title: 'Smart Event Check-in',
        theme: AppTheme.theme(),
        initialRoute: Routes.eventSetup,
        routes: Routes.routes,
      ),
    );
  }
}
