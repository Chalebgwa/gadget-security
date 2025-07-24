import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences? preferences;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
}
