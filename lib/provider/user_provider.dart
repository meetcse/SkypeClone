import 'package:flutter/cupertino.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  User _user;

  FirebaseRepository _firebaseRepository = FirebaseRepository();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _firebaseRepository.getUserDetails();

    _user = user;
    notifyListeners();
  }
}
