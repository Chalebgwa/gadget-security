import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/authentication/sign_in.dart';
import 'package:gsec/pages/device_info.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/pages/settings.dart';
import 'package:gsec/pages/forms/device_registration.dart';
import 'package:gsec/widgets/dashcard.dart';
import 'package:gsec/widgets/fancy_drawer.dart';
import 'package:gsec/widgets/nm_box.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Dashboard({super.key});
  void turnPage(BuildContext context, int page) {
    switch (page) {
      case 2:
        // TODO: Navigate to trading/selling page
        break;
      case 3:
        // Navigate to device registration
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DeviceRegistrationPage(),
          ),
        );
        break;
    }
  }

  void scan(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _QRScannerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _topColor = Colors.grey.shade200;

    return Consumer<Auth>(
      builder: (context, auth, child) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            endDrawer: const FancyDrawer(),
            backgroundColor: _topColor,
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/back.jpg"), 
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.7),
                  ),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const Expanded(child: SizedBox()),
                              if (auth.currentUser == null) ...[
                                TopButton(
                                  icon: FontAwesomeIcons.lock,
                                  label: "Sign In",
                                  onTap: () {
                                    var route = animateRoute(
                                      context: context,
                                      page: SignIn(),
                                    );
                                    Navigator.push(context, route);
                                  },
                                ),
                              ] else ...[
                                TopButton(
                                  icon: FontAwesomeIcons.user,
                                  label: auth.currentUser!.name,
                                  onTap: () {
                                    // TODO: Navigate to profile
                                  },
                                ),
                                TopButton(
                                  icon: FontAwesomeIcons.signOutAlt,
                                  label: "Sign Out",
                                  onTap: () => auth.signOut(),
                                ),
                              ],
                              TopButton(
                                icon: FontAwesomeIcons.bars,
                                label: "Menu",
                                onTap: () {
                                  _scaffoldKey.currentState?.openEndDrawer();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: SizedBox(
                        height: 230,
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: const TextSpan(
                            text: "Welcome to\n",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: "Gadget Security\n",
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: "'Reinvented Protection'",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Search Device Owner",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: const Icon(FontAwesomeIcons.magnifyingGlass),
                                  onPressed: () {
                                    // TODO: Implement search functionality
                                  },
                                ),
                              ),
                              focusColor: Colors.purple,
                              hoverColor: Colors.red,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(39),
                                gapPadding: 30,
                              ),
                              fillColor: Colors.white.withOpacity(.4),
                              filled: true,
                              hintText: "Search",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      onPressed: () {
                                        var route = animateRoute(
                                          context: context,
                                          page: DeviceInfo(),
                                        );
                                        Navigator.push(context, route);
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            "Device Info",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      onPressed: () {
                                        scan(context);
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Text("Scan QR code"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Add device registration button if user is signed in
                        if (auth.currentUser != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const DeviceRegistrationPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_circle),
                                label: const Text(
                                  "Register New Device",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildHeader(Color _topColor, BuildContext context) {
    return Container(
      decoration: nMbox.copyWith(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: Colors.purple[200],
      ),
      //color: Colors.purple,
      child: Column(
        children: <Widget>[
          Container(
            //color: _topColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 32),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Gadget Security",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.lock_open,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      var route = animateRoute(
                        context: context,
                        page: SignIn(),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                  IconButton(
                    icon: Hero(
                      tag: "settingsIcon",
                      child: Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onPressed: () {
                      var route = animateRoute(
                        page: Settings(),
                        context: context,
                      );
                      Navigator.push(
                        context,
                        route,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TopButton(
                      icon: Icons.camera,
                      label: "Scan",
                      onTap: () {
                        scan(context);
                      }),
                  TopButton(
                    icon: Icons.perm_device_information,
                    label: "Device Info",
                    onTap: () {
                      var route = animateRoute(
                        page: DeviceInfo(),
                        context: context,
                      );
                      Navigator.push(
                        context,
                        route,
                      );
                    },
                  ),
                          TopButton(
                            icon: FontAwesomeIcons.exchangeAlt,
                            label: "Sell",
                            lock: true,
                            onTap: () {
                              turnPage(context, 2);
                            },
                          ),
                          TopButton(
                            icon: Icons.add,
                            label: "New Device",
                            lock: true,
                            onTap: () {
                              turnPage(context, 3);
                            },
                          ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern QR Scanner implementation using mobile_scanner
class _QRScannerPage extends StatefulWidget {
  @override
  State<_QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<_QRScannerPage> {
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (!isScanning) return;
          
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            setState(() {
              isScanning = false;
            });
            
            // Show result and go back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Scanned: ${code ?? "Unknown"}'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            );
            
            // Auto-return after 2 seconds
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        },
      ),
    );
  }
}
