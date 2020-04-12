import 'package:flutter/material.dart';
import 'package:gsec/tokens.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class Payments extends ChangeNotifier {
  Payments() {
    initSquarePayment();
  }

  Future<void> initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(SQUARE_APP_IP);
  }

  void pay() {
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: onCardNonceSucess,
      onCardEntryCancel: onCardEntryCancel,
    );
  }

  onCardEntryCancel() => onCardEntryCancel;

  /** 
        * An event listener to start card entry flow
        */
  Future<void> onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: onCancelCardEntryFlow);
  }

  /**
        * Callback when card entry is cancelled and UI is closed
        */
  void onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  /**
        * Callback when successfully get the card nonce details for processig
        * card entry is still open and waiting for processing card nonce details
        */
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(onCardEntryComplete: onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  /**
        * Callback when the card entry is closed after call 'completeCardEntry'
        */
  void onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
  }

  void onCardNonceSucess(CardDetails result) {}
}
