import 'package:flutter/material.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLeftHanded = false;
  SettingsProvider _settingsProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _isLeftHanded = _settingsProvider.isLeftHanded;
    //setState(() {});
  }

  void saveHand(bool value) {
    _settingsProvider.isLefHanded(value);
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: ListView(
        children: <Widget>[
          buildSettingsCard(),
        ],
      ),
    );
  }

  Widget buildSettingsCard() {
    var detailStyle = TextStyle(color: Colors.white);

    return ListBody(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListTileTheme(
            style: ListTileStyle.list,
            child: ListTile(
              title: Text("Gestures"),
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(.5),
          child: Column(
            children: <Widget>[
              buildListItem("switch to left hand", detailStyle),
            ],
          ),
        ),
        Divider(
          height: 30,
        )
      ],
    );
  }

  ListTile buildListItem(label, TextStyle detailStyle) {
    return ListTile(
      title: Text(
        label,
        style: detailStyle,
      ),
      trailing: Switch(
        onChanged: saveHand,
        value: _isLeftHanded,
      ),
    );
  }
}
