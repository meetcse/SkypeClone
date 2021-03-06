import 'package:flutter/cupertino.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user;

  AuthMethods _authMethods = AuthMethods();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _authMethods.getUserDetails();

    _user = user;
    notifyListeners();
  }
}
