import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // static const ID_FIELD = "id";

  static const EMAIL_FIELD = "email";
  static const NAME_FIELD = "name";
  static const HOSTEL_FIELD = "hostel";
  static const ROOM_FIELD = "room";
  static const NUMBER_FIELD = "number";
  static const USER_TYPE_FIELD = "userType";

  late String _email;
  late String _name;
  late String _hostel;
  late String _room;
  late String _userType;
  late String _number;

  // Constructor taking DocumentSnapshot as parameter
  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    _email = data?[EMAIL_FIELD] as String? ?? "";
    _hostel = data?[HOSTEL_FIELD] as String? ?? "";
    _name = data?[NAME_FIELD] as String? ?? "";
    _room = data?[ROOM_FIELD] as String? ?? "";
    _number = data?[NUMBER_FIELD] as String? ?? "";
    _userType = data?[USER_TYPE_FIELD] as String? ?? "Regular";
  }

  // Getters for class fields
  String get email => _email;
  String get name => _name;
  String get hostel => _hostel;
  String get room => _room;
  String get number => _number;
  String get userType => _userType;
}
