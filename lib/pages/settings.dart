import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordhunt/models/widget_tree.dart';
import 'package:wordhunt/pages/login_register_page.dart';
import 'package:wordhunt/providers/auth.dart';
import 'package:wordhunt/providers/theme_provider.dart';
import 'package:wordhunt/utils/quick_box.dart';
import 'package:wordhunt/utils/theme_preferences.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: Column(
        children: [
          Consumer<ThemeProvider>(
            builder: (_, notifier, __) {
              bool isSwitched = false;
              isSwitched = notifier.isDark;

              return SwitchListTile(
                  value: isSwitched,
                  onChanged: (value) {
                    isSwitched = value;
                    ThemePreferences.saveTheme(isDark: isSwitched);
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(turnOn: isSwitched);
                  });
            },
          ),
          ListTile(
            title: const Text('Reset Stats'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('stats');
              prefs.remove('chart');
              prefs.remove('row');
              runQuickBox(context: context, message: 'Stats Cleared!');
            },
          ),
          ElevatedButton(
              onPressed: () async {
                await auth.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WidgetTree()),
                    (Route<dynamic> route) => false);
              },
              child: Text('Sign Out')),
        ],
      ),
    );
  }
}
