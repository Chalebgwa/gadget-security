import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/settings_provider.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLeftHanded = false;
  bool _isDarkThemed = false;
  SettingsProvider _settingsProvider;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _isLeftHanded = _settingsProvider.isLeftHanded;
    _isDarkThemed = _settingsProvider.isDarkTheme;
    //setState(() {});
  }

  void saveHand(bool value) {
    _settingsProvider.isLefHanded(value);
  }

  void switchToDarkTheme(bool value) {
    _settingsProvider.isDarkThemed(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          buildSettingsCard(
              'Gestures', 'switch to left hand', saveHand, _isLeftHanded),
          buildSettingsCard('Appearance', 'switch to dark theme',
              switchToDarkTheme, _isDarkThemed),
          Card(
            color: Theme.of(context).primaryColor.withOpacity(.4),
            child: ListBody(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Text(
                      "Security",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Pin"),
                  trailing: Icon(Icons.edit),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Pin"),
                  trailing: Icon(Icons.edit),
                  onTap: showPinDialog,
                ),
                ListTile(
                  title: Text("Emergency Contact"),
                  trailing: Icon(Icons.edit),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showPinDialog() {
    AwesomeDialog(
        dialogType: DialogType.INFO,
        context: context,
        animType: AnimType.SCALE,
        body: TextField(
          decoration: InputDecoration(hintText: "Type in Pin"),
        )).show();
  }

  Widget _buildTextField(hint, controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  Widget buildSettingsCard(String title, String action, funct, value) {
    var detailStyle = TextStyle(color: Theme.of(context).accentColor);

    return ListBody(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: ListTileTheme(
            style: ListTileStyle.list,
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        Container(
          color: Theme.of(context).primaryColor.withOpacity(.5),
          child: Column(
            children: <Widget>[
              buildListItem(action, detailStyle, funct, value),
            ],
          ),
        ),
        Divider(
          height: 30,
        )
      ],
    );
  }

  ListTile buildListItem(label, TextStyle detailStyle, funct, value) {
    return ListTile(
      title: Text(
        label,
        style: detailStyle,
      ),
      trailing: Switch(
        onChanged: funct,
        value: value,
      ),
    );
  }
}
