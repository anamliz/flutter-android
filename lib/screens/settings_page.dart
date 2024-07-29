import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/users.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   List<Map<String, dynamic>> _placesList = [];
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
    return CommonScaffold(
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Theme'),
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
              title: const Text('Language'),
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
              title: const Text('Notifications'),
              value: isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Two-Factor Authentication'),
              value: isTwoFactorAuthEnabled,
              onChanged: (value) {
                setState(() {
                  isTwoFactorAuthEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ), currentIndex: 3, userFirstName: user.userfirstName, places: _placesList,
    );
  }
}
