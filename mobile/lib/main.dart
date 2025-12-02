import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const CrefigexLiveApp());
}

class CrefigexLiveApp extends StatelessWidget {
  const CrefigexLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crefigex Live',
      theme: AppTheme.light,
      routes: AppRouter.routes,
    );
  }
}
