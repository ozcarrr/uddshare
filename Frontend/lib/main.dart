import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/marketplace/providers/marketplace_provider.dart';
import 'features/notes/providers/notes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadStoredAuth();

  runApp(UDDShareApp(authProvider: authProvider));
}

class UDDShareApp extends StatelessWidget {
  final AuthProvider authProvider;
  const UDDShareApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: Builder(builder: (ctx) {
        final router = createRouter(authProvider);
        return MaterialApp.router(
          title: 'UDDShare',
          theme: appTheme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
