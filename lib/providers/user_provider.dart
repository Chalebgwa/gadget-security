import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/base_provider.dart';

class UserProvider extends BaseProvider {
  Future<User> fetchUser(String field, String value) async {
    QuerySnapshot shot = await firestore
        .collection("users")
        .where(
          field,
          isEqualTo: value,
        )
        .getDocuments();

    var docs = shot.documents;

    if (docs.length <= 0) {
      return null;
    }
    
    return User.fromMap(docs[0].data);
  }
}
