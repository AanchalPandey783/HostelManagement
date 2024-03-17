import 'package:minor_proj/data/types/usersdata.dart';
import 'package:minor_proj/user persona/end_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../data/local/localdb.dart';

class UserProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  UserModel? _user;

  void setUser() async {
    final UserServices _userServicse = UserServices();
    final user = FirebaseAuth.instance.currentUser;
    var userModel = await _userServicse.getUserById(user!.uid);
    _user = userModel;
    notifyListeners();
  }

  UserModel? get user => _user;
}
