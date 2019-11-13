import 'package:admob_flutter/admob_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/views/commerce/advertise_screen.dart';
import 'package:gsec/views/user_info.dart';
import 'package:gsec/views/util/device_info.dart';
import 'package:gsec/widgets/fancy_search.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String adId = "ca-app-pub-8858281741870053~7891966146";
  String barcode = '';
  Auth _auth;
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    Admob.initialize(adId);
    //AdRequest.Builder.addTestDevice("D8C9E14095687B7315CCEE3CA3AFD4EC");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDeviceInfo(BuildContext context) {
    showDialog(
      context: context,
      //barrierDismissible: true,
      builder: (context) {
        return DeviceInfo();
      },
    );
  }

  void navigateToScanner(BuildContext context) async {
    try {
      barcode = await BarcodeScanner.scan();
      User user = await _auth.GetUserBySsn(barcode);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserInfo(
            user: user,
          ),
        ),
      );
    } on Exception {
      Fluttertoast.showToast(msg: "error");
    }
  }

  void navigateToDonate(BuildContext context) {
    Navigator.pushNamed(context, "/donate");
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context);
    

    return Page(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FancySearch(
          controller: _controller,
          onPressed: (String value) async {
            User user = await _auth.searchDeviceById(value);
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserInfo(
                    user: user,
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: AdmobBanner(
                adSize: AdmobBannerSize.LARGE_BANNER,
                adUnitId: BannerAd.testAdUnitId,
                onBannerCreated: (c) {
                  print("BANNER CREATED");
                },
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: <Widget>[
                DashCard(
                  label: "Device info",
                  icon: Icons.info,
                  ontap: () {
                    showDeviceInfo(context);
                  },
                ),
                DashCard(
                  label: "Scan device",
                  icon: Icons.camera,
                  ontap: () {
                    navigateToScanner(context);
                  },
                ),
                DashCard(
                  label: "Donate",
                  icon: FontAwesomeIcons.donate,
                  ontap: () {
                    navigateToDonate(context);
                  },
                ),
                DashCard(
                  label: "Advertise",
                  icon: FontAwesomeIcons.ad,
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Advertiser(),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashCard extends StatelessWidget {
  final String label;
  final VoidCallback ontap;
  final IconData icon;

  const DashCard({
    Key key,
    this.label,
    this.ontap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          highlightColor: Colors.red,
          splashColor: Colors.yellow,
          onTap: ontap,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
