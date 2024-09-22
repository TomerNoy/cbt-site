import 'package:cbt_inbal/app/services/services.dart';
import 'package:cbt_inbal/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'log_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceProvider.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: generateTheme(),
        debugShowCheckedModeBanner: false,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: App(),
        ),
      ),
    );
  }
}

/// todo
/// - add copy paste usability (if not overloading the page)
