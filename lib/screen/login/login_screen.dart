import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import '../../widget/ftext.dart';
import '../../models/user.dart';

//ignore: must_be_immutable
class LoginScreen extends StatelessWidget with ChangeNotifier {
  final _formKey = GlobalKey<FormBuilderState>();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormBuilder(
        key: _formKey,
        child: Scaffold(
          body: Center(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/thepatio.jpg',
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                  H1("gr8danes login"),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<API>().loginAttempt(
                                  context,
                                  new User(
                                    userEmail: "james@silverlininggroup.co.uk",
                                    userName: "Mike",
                                    password: "123",
                                  ),
                                );
                          },
                          child: H3("Login"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}