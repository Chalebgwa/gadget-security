import 'package:admob_flutter/admob_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
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
  bool _searchActive = false;
  DeviceProvider _deviceProvider;

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
    _deviceProvider = Provider.of<DeviceProvider>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void searchBySSN(String ssn) async {
    User user = await _auth.searchDeviceById(ssn);
    if (user != null) {
      showOwnerInfo(user);
    } else {
      Fluttertoast.showToast(msg: 'Owner not found');
    }
  }

  Widget _buildUserAvatar(User user) {
    return CachedNetworkImage(
      key: Key("myImage"),
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: 40,
        backgroundImage: imageProvider,
      ),
      imageUrl: user?.imageUrl ??
          "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  void showAlertDialogOnOkCallback(User user, Widget child) {
    AwesomeDialog(
      context: context,
      body: child,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.INFO,
      customHeader: _buildUserAvatar(user),

      //btnOkIcon: Icons.check_circle,
      //btnOkColor: Colors.green.shade900,
      //btnOkOnPress: onOkPress,
    ).show();
  }

  void showDeviceInfo(BuildContext context) {
    User user = _deviceProvider.owner;
    showAlertDialogOnOkCallback(
      user,
      DeviceInfo(),
    );
  }

  void showOwnerInfo(User user) {
    showAlertDialogOnOkCallback(
      user,
      Text('')
    );
  }

  void navigateToScanner(BuildContext context) async {
    try {
      barcode = await BarcodeScanner.scan();
      User user = await _auth.GetUserBySsn(barcode);
      if (user != null) {
        showOwnerInfo(user);
      } else {
        Fluttertoast.showToast(msg: "User not found");
      }
    } on Exception {
      Fluttertoast.showToast(msg: "scanning failed");
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
        resizeToAvoidBottomInset: true,
        primary: true,
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(10),
                color: Theme.of(context).primaryColor.withOpacity(.4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdmobBanner(
                    listener: (AdmobAdEvent e, _) {
                      if (e == AdmobAdEvent.loaded) {}
                    },
                    adSize: AdmobBannerSize.LARGE_BANNER,
                    adUnitId: BannerAd.testAdUnitId,
                    onBannerCreated: (c) {},
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: TextField(
                  onChanged: (value) {
                    if (value.length > 0) {
                      setState(() {
                        _searchActive = true;
                      });
                    } else {
                      setState(() {
                        _searchActive = false;
                      });
                    }
                  },
                  controller: _controller,
                  onSubmitted: (value) {
                    if (_searchActive) {
                      searchBySSN(value);
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      height: 40,
                      width: 20,
                      child: FlatButton(
                        highlightColor: Colors.purple,
                        child: Icon(
                          FontAwesomeIcons.search,
                          color: _searchActive
                              ? Colors.purple
                              : Theme.of(context).accentColor,
                        ),
                        onPressed: _searchActive
                            ? () {
                                searchBySSN(_controller.text);
                              }
                            : null,
                      ),
                    ),
                    hintText: 'Serial Number',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor.withOpacity(.3)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      //borderRadius: BorderRadius.circular(40),
                    ),
                    fillColor: Theme.of(context).primaryColor,
                    filled: true,
                  ),
                ),
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
                  label: "Premium",
                  icon: FontAwesomeIcons.moneyBill,
                  ontap: true
                      ? null
                      : () {
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
        color: Theme.of(context).primaryColor.withOpacity(.4),
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
                  color: Theme.of(context).accentColor,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
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
