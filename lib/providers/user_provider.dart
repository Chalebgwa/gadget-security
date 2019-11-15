import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/base_provider.dart';

class UserProvider extends BaseProvider {
  Future<User> fetchUser(String field, String value) async {
    DocumentSnapshot shot = (
      await firestore
            .collection("users")
            .where(
              field,
              isEqualTo: value,
            )
            .getDocuments())
        .documents[0];
    return User.fromMap(shot.data);
  }
}
