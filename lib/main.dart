import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordhunt/constants/colors.dart';
import 'package:wordhunt/firebase_options.dart';
import 'package:wordhunt/pages/settings.dart';
import 'package:wordhunt/providers/controller.dart';
import 'package:wordhunt/pages/home_page.dart';
import 'package:wordhunt/providers/theme_provider.dart';
import 'package:wordhunt/utils/theme_preferences.dart';
import 'package:wordhunt/constants/themes.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Controller()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: FutureBuilder(
        initialData: false,
        future: ThemePreferences.getTheme(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setTheme(turnOn: snapshot.data as bool);
            });
          }
          return Consumer<ThemeProvider>(
            builder: (_, notifier, __) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'WordHunt',
              theme: notifier.isDark ? darkTheme : lightTheme,
              home: const HomePage(),
            ),
          );
        },
      ),
    );
  }
}
