import 'dart:convert';

import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:localstorage/localstorage.dart';

class StorageHelper {
  LocalStorage storage = new LocalStorage('localstorage_app.json');

  setUserData(userData) async {
    try {
      await this.storage.setItem('userData', userData);
    } catch (e) {
      return null;
    }
  }

  Future<SystemAccount> getUserData() async {
    try {
      var value = await storage.getItem('userData');
      //print(value);

      if (value != null) {
        SystemAccount user = new SystemAccount(
            email: value['email'],
            userGroup: value['userGroup'],
            verificationToken: ['verificationToken'],
            isLogged: value['isLogged']);
        return user;
      }
      return new SystemAccount(
          email: '', isLogged: false, userGroup: '', verificationToken: '');
    } catch (e) {
      return new SystemAccount(
          email: '', isLogged: false, userGroup: '', verificationToken: '');
    }
  }

  void setRol(SystemAccount userData) {
    try {
      //print(jsonEncode(userData.toJson()).toString());
      this.storage.setItem('role', jsonEncode(userData.toJson()));
    } catch (e) {
      return null;
    }
  }

  getRol() async {
    try {
      var value = await storage.getItem('role');
      if (value != null) {
        return value;
      }
    } catch (e) {
      return null;
    }
  }

  void removeRol() {
    try {
      storage.deleteItem('role');
    } catch (e) {
      return null;
    }
  }

  void setToken(SystemAccount userData) async {
    try {
      await storage.setItem('token', userData.verificationToken);
    } catch (e) {
      return null;
    }
  }

  getToken() async {
    try {
      var value = await storage.getItem('token');
      if (value != null) {
        return value;
      }
    } catch (e) {
      return null;
    }
  }

  void removeToken() async {
    try {
      await storage.deleteItem('token');
    } catch (e) {
      return null;
    }
  }

  void removeUserData() {
    try {
      storage.deleteItem('token');
      storage.deleteItem('role');
    } catch (e) {
      return null;
    }
  }

  void clearStorage() async {
    try {
      await storage.clear();
    } catch (e) {
      return null;
    }
  }
}

class SharedPrefences {}
