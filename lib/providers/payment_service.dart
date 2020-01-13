import 'package:gsec/providers/base_provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PayService extends BaseProvider {
  
  PayService(){
    init();
  }
  
  void init() {
    InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-O639H-fnac2eN6_j2UmxGA');
  }

  void pay() {
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _onCardNonceSucess,
      onCardEntryCancel: _onCardEntryCancel,
    );
  }

  void _onCardNonceSucess(CardDetails result) {
    print(result.nonce);

    InAppPayments.completeCardEntry(onCardEntryComplete: _cardEntryComplete);
  }

  void _onCardEntryCancel() {}

  void _cardEntryComplete() {}
}
