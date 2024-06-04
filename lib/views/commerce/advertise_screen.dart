import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsec/page.dart';

@deprecated
class Advertiser extends StatefulWidget {
  Advertiser({Key key}) : super(key: key);

  _AdvertiserState createState() => _AdvertiserState();
}

class _AdvertiserState extends State<Advertiser> {
  Package startup = Package();
  Package premium = Package();
  Package custom = Package();

  void purchasePackage(Package package) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: <Widget>[
          TextField(),
          TextField(),
        ],
      ),
    );
  }

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
        backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/back3.jpg'), fit: BoxFit.fill)),
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              _buildPackageCard(startup),
              _buildPackageCard(premium),
              _buildPackageCard(custom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(Package package) {
    return Expanded(
      child: Card(
        shape: StadiumBorder(
            side: BorderSide(
                //color: Theme.of(context).accentColor
                )),
        color: Theme.of(context).primaryColor.withOpacity(.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              package.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            for (var text in package.benefits)
              Text(
                text,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            RaisedButton(
              onPressed: () {},
              child: Text("Buy"),
              color: Theme.of(context).primaryColor,
              shape: StadiumBorder(),
            )
          ],
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
