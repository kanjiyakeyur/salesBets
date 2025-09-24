// Package imports:
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/applicationVersion/applicationVersion.dart';
import '../../data/models/user/user.dart';
import 'constant.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  Future<void> clearPreferencesData() async {
    await _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  Future<void> setToken(String value) {
    return _sharedPreferences!.setString('token', value);
  }

  Future<void> setUserData(User? user) {
    var userDataString = jsonEncode((user ?? User()).toJson());
    return _sharedPreferences!.setString('userdata', userDataString);
  }

  Future<User?> getUserData() async {
    try {
      String? jsonString = _sharedPreferences?.getString('userdata');
      if (jsonString == null) return null; // Return null if no data found

      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return User.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserName(String userName) async {
    try {
      User? currentUser = await getUserData();
      if (currentUser != null) {
        currentUser.name = userName;
        await setUserData(currentUser);
      }
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  bool isUserAuthenticate() {
    var token = '';
    if (token.isEmpty) {
      return false;
    }
    return true;
  }

  String getToken() {
    try {
      return _sharedPreferences!.getString('token') ?? '';
    } catch (e) {
      return '';
    }
  }


}
