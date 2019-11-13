
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Advertiser extends StatefulWidget {
  Advertiser({Key key}) : super(key: key);

  _AdvertiserState createState() => _AdvertiserState();
}

class _AdvertiserState extends State<Advertiser> {
  Package startup = Package();
  Package premium = Package();
  Package custom = Package();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    startup.title = "startup";
    startup.description = "perfect from small companies";
    startup.price = "USD60";
    startup.benefits = [
      '7 DAY ADVERTS',
      '5GB STORAGE',
      'EDITABLE ADS',
      'AD LIMIT EXPANSION'
    ];
    startup.color = Colors.blue;

    premium.title = "premium";
    premium.description = "perfect from small companies";
    premium.price = "USD180";
    premium.benefits = [
      '30 DAY ADVERTS',
      '15GB STORAGE',
      'EDITABLE ADS',
      'AD LIMIT EXPANSION'
    ];
    premium.color = Colors.amber;

    custom.title = "custom";
    custom.description = "perfect from small companies";
    custom.price = "USD500";
    custom.benefits = [
      '90 DAY ADVERTS',
      '25GB STORAGE',
      'EDITABLE ADS',
      'AD LIMIT EXPANSION'
    ];
    custom.color = Colors.grey;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            _buildPackageCard(startup),
            _buildPackageCard(premium),
            _buildPackageCard(custom),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(Package package) {
    return Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: package.color,
              child: ListTile(
                title: Text(package.title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                package.price,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                package.description,
                style: TextStyle(),
                softWrap: true,
              ),
            )
          ]
        ),
      ),
    );
  }
}

class Package {
  String title;
  String price;
  String description;
  List<String> benefits;
  Color color;
}
