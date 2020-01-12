import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/payment_service.dart';
import 'package:gsec/views/commerce/visa.dart';
import 'package:provider/provider.dart';

class Donate extends StatefulWidget {
  const Donate({Key key}) : super(key: key);

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {


  PayService _payService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _payService = Provider.of<PayService>(context);
  }


  void navigateToVisa() {
    var route = MaterialPageRoute(builder: (_) => Visa());
    Navigator.push(context, route);
  }

  Widget _buildPayOption(
      String title, IconData icon, VoidCallback action, Color color) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(.4),
      child: InkWell(
        onTap: action,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: color,
                size: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: Center(
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: <Widget>[
            _buildPayOption(
                'Visa', FontAwesomeIcons.ccVisa, _payService.pay, Colors.blue),
            _buildPayOption(
                'PayPal', FontAwesomeIcons.paypal, navigateToVisa, Colors.blue),
            _buildPayOption('Crypto', FontAwesomeIcons.bitcoin, navigateToVisa,
                Colors.amberAccent),
          ],
        ),
      ),
    );
  }
}
