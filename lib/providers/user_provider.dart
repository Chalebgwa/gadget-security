import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends BaseProvider {
  Future<Client?> fetchUser(String field, String value) async {
    QuerySnapshot<Map<String,dynamic>> shot = await firestore
        .collection("users")
        .where(
          field,
          isEqualTo: value,
        )
        .get();

    var docs = shot.docs;

    if (docs.length <= 0) {
      return null;
    }

    return Client.fromMap(docs.first.data());
  }
  
  @override
  void initializePreferences() {
    SharedPreferences.getInstance().then((prefs) {
      preferences = prefs;
    });
  }
}
