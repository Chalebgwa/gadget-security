import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/views/profile/doc_scanner.dart';
import 'package:provider/provider.dart';

// device classes

class AddDevice extends StatefulWidget {
  final DeviceProvider deviceProvider;

  AddDevice({Key key, this.deviceProvider}) : super(key: key);

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  DeviceProvider _deviceProvider;
  Map<String, String> _details;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceProvider = Provider.of<DeviceProvider>(context);
    _details = _deviceProvider.details;
  }

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Page(
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          staggeredTiles: _staggeredTiles,
          children: [
            Tile(
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.blueGrey,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('DEVICE'),
                          ),
                          Text('INFO')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_details['identifier']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_details['name']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_details['model']),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Tile(
              form: _LaptopForm(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.laptop,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Laptop'),
                  )
                ],
              ),
            ),
            Tile(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.mobileAlt,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Mobile'),
                  )
                ],
              ),
            ),
            Tile(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.tv,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('TV/Monitor'),
                  )
                ],
              ),
            ),
            Tile(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.plus,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Other'),
                  )
                ],
              ),
            )
          ],
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final Widget child;
  final Widget form;

  const Tile({Key key, this.child, this.form}) : super(key: key);

  void _showForm(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: form,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(.5),
      child: InkWell(
        onTap: () {
          _showForm(context);
        },
        child: child ?? Container(),
      ),
    );
  }
}

class _LaptopForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          children: <Widget>[
            FlatButton(
                child: Text("SCAN RECIEPT"),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (c) => DocScanner()));
                }),
            TextFormField(),
            TextFormField(),
            TextFormField(),
            SizedBox(
              width: double.maxFinite,
              child: RaisedButton(
                child: Text('save'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
