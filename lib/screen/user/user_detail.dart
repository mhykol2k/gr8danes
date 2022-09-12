import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../api/api.dart';
import '../../widget/ftext.dart';
import '../../models/user.dart';

//ignore: must_be_immutable
class UserDetail extends StatelessWidget with ChangeNotifier {
  final User user;
  UserDetail({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSettings(user.userName.toString()),
      body: SingleChildScrollView(
        child: Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H1("To Do :"),
                Spacer(),
                H2("Login"),
                H2("Permissions"),
                H2("Email"),
                H2("Details"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}