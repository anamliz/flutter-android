import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Settings Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  String selectedTheme = 'Light';
  String selectedLanguage = 'English';
  bool isNotificationsEnabled = true;
  bool isDarkModeEnabled = false;
  bool isTwoFactorAuthEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme = _prefs.getString('theme') ?? 'Light';
      selectedLanguage = _prefs.getString('language') ?? 'English';
      isNotificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
      isDarkModeEnabled = _prefs.getBool('darkModeEnabled') ?? false;
      isTwoFactorAuthEnabled = _prefs.getBool('twoFactorAuthEnabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setString('theme', selectedTheme);
    await _prefs.setString('language', selectedLanguage);
    await _prefs.setBool('notificationsEnabled', isNotificationsEnabled);
    await _prefs.setBool('darkModeEnabled', isDarkModeEnabled);
    await _prefs.setBool('twoFactorAuthEnabled', isTwoFactorAuthEnabled);
    print('Settings saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Theme'),
              trailing: DropdownButton<String>(
                value: selectedTheme,
                onChanged: (value) {
                  setState(() {
                    selectedTheme = value!;
                  });
                },
                items: ['Light', 'Dark'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text('Language'),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
                items: ['English', 'Spanish', 'French'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SwitchListTile(
              title: Text('Notifications'),
              value: isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Two-Factor Authentication'),
              value: isTwoFactorAuthEnabled,
              onChanged: (value) {
                setState(() {
                  isTwoFactorAuthEnabled = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
