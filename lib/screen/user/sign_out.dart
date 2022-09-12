import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gr8danes/api/api.dart';
import '../../widget/ftext.dart';

//ignore: must_be_immutable
class SignOut extends StatelessWidget with ChangeNotifier {
  SignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSettings("Sign Out"),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.read<API>().signOut(),
                child: H1("Confirm Signout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}