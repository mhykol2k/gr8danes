import 'package:flutter/material.dart';
import 'package:gr8danes/api/api.dart';
import 'package:gr8danes/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'httpReturn.dart';

extension ApiUser on API {
  static User? _currentUser;
  static List<User> _users = [];
  User? get currentUser => _currentUser;
  List<User> get users => _users;

  String getUserName(String userGuid) {
    List<User> users =
        this.users.where((element) => element.userGuid == userGuid).toList();
    if (users.length == 0) return "?";
    return users[0].userName ?? "?";
  }

  Future<void> getUsers() async {
    final HttpReturn result = await httpCall.getData('get/users');
    if (result.error == 0 && result.json != "[]") {
      _users = result.json.map<User>((jR) => User.fromJson(jR)).toList();
    } else {
      this.setConnectionIssue = "Problem Retrieving Users";
    }
  }

  void createUser(BuildContext context, User newUser) async {
    final HttpReturn _ =
        await httpCall.postData(context, 'post/createUser', newUser.toJsonN());
    getUsers();
  }

  void clearUsers() {
    _users = [];
  }

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  Future<void> loginAttempt(BuildContext context, User user) async {
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
    _currentUser = null;
  }
}