import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'core/state/app_state.dart';
import 'core/state/user_state.dart';
import 'core/deeplink/deep_link.dart';

void main() {
  DeepLink.parseFromUri(Uri.base);
  runApp(const CrefigexLiveApp());
}

class CrefigexLiveApp extends StatelessWidget {
  const CrefigexLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, app, _) {
          if (!app.initialized) {
            return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserState()..loadFromToken()),
            ],
            child: MaterialApp(
              title: 'Crefigex Live',
              theme: AppTheme.light,
              initialRoute: DeepLink.initialRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
            ),
          );
        },
      ),
    );
  }
}
