import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  SystemAccount _user = new SystemAccount();

  SystemAccount get user {
    return this._user;
  }

  set user(SystemAccount u) {
    this._user = u;
    notifyListeners();
  }

  SystemAccount getLoggedUser() {
    return this._user;
  }

  login(SystemAccount userData) async {
    this._user.userGroup = userData.userGroup;
    this._user.verificationToken = userData.verificationToken;
    this._user.isLogged = true;
    this._user.systemaccountId = userData.systemaccountId;
    this._user.cancelAgree = userData.cancelAgree;
    this._user.name = userData.name;
    this._user.lastname = userData.lastname;
    this._user.email = userData.email;
    this._user.rate = userData.rate;

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', user.userGroup);
    prefs.setString('email', user.email);
  }

  setProfile(SystemAccount userData) {
    this.user = userData;
    notifyListeners();
  }

  AcceptCancelation() {
    this.user.cancelAgree = true;
    notifyListeners();
  }

  voteUser(_rate) {
    this.user.rate = _rate;
    notifyListeners();
  }

  logout() async {
    this._user = new SystemAccount();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('role');
    await prefs.remove('currentUser');
	
  }
}
