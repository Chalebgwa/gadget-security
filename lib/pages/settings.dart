import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //fit: StackFit.loose,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.jpg"), fit: BoxFit.fill),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: "User",
                  tiles: [
                    SettingsTile(
                      title: 'Change User Details',
                      //subtitle: '',
                      leading: Icon(Icons.verified_user),
                      onTap: () {},
                    ),
                    SettingsTile.switchTile(
                      title: "Notifications",
                      leading: Icon(Icons.info),
                      onToggle: (value) {},
                      switchValue: false,
                    ),
                  ],
                ),
                SettingsSection(
                  title: "UI",
                  tiles: [
                    SettingsTile.switchTile(
                      title: "Dark Mode",
                      leading: Icon(Icons.info),
                      onToggle: (value) {},
                      switchValue: false,
                    ),
                  ],
                ),
                SettingsSection(
                  title: "Account",
                  tiles: [
                    SettingsTile(
                      title: 'Email',
                      subtitle: 'Test@gmail.com',
                      leading: Icon(Icons.email),
                      onTap: () {},
                    ),
                    SettingsTile(
                      title: 'Phone',
                      leading: Icon(Icons.phone),
                      subtitle: "77147912",
                      onTap: () {},
                    ),
                    SettingsTile(
                      title: 'Sign Out',
                      leading: Icon(Icons.lock_outline),
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Security',
                  tiles: [
                    SettingsTile(
                      title: 'Password',
                      subtitle: '******',
                      leading: Icon(Icons.language),
                      onTap: () {},
                    ),
                    SettingsTile(
                      title: 'Change Pin',
                      subtitle: '********',
                      leading: Icon(Icons.vpn_key),
                      onTap: () {},
                    ),
                    SettingsTile.switchTile(
                      title: 'Keep Tracker on',
                      leading: Icon(Icons.gps_fixed),
                      switchValue: true,
                      onToggle: (bool value) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
