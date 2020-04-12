import 'package:flutter/material.dart';
import 'package:gsec/provider/payments.dart';
import 'package:provider/provider.dart';

class PaymentsView extends StatefulWidget {
  PaymentsView({Key key}) : super(key: key);

  @override
  _PaymentsViewState createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  Payments _paymentProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _paymentProvider = Provider.of<Payments>(context);
    _paymentProvider.initSquarePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     
    );
  }
}
