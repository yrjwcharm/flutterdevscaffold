import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdevscaffold/app/common/app_theme.dart';
import 'package:flutterdevscaffold/app/http/token_manager.dart';
import 'package:flutterdevscaffold/app/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenManager.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'PromptHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
