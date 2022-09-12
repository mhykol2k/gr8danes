import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../api/api.dart';
import '../../widget/ftext.dart';
import '../../models/user.dart';

//ignore: must_be_immutable
class UserAdd extends StatelessWidget with ChangeNotifier {
  final _formKey = GlobalKey<FormBuilderState>();
  UserAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSettings("Add User"),
      body: FormBuilder(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: buildForm(context),
          ),
        ),
      ),
    );
  }

  FormBuilder buildForm(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FormBuilderTextField(
                name: 'userName',
                autofocus: true,
                autocorrect: false,
                maxLength: 50,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "User Name",
                    fillColor: Colors.white70),
                validator: (value) {
                  if (value?.length == 0) {
                    return 'Must provide a user name';
                  }
                  return null;
                }),
            FormBuilderTextField(
              name: 'userEmail',
              autofocus: true,
              autocorrect: false,
              maxLength: 50,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Email",
                  fillColor: Colors.white70),
              validator: (value) {
                if (value == null) {
                  return 'Must provide an email';
                }
                String nonNullValue = value;
                if (nonNullValue.length == 0) {
                  return 'Must provide an email';
                }
                if (EmailValidator.validate(value) == false) {
                  return 'Email address is not valid';
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  // Get textfield input value
                  final bool? validationSuccess =
                      _formKey.currentState?.validate();

                  if (validationSuccess!) {
                    //
                    // Save only when validation passed
                    _formKey.currentState?.save();
                    //
                    // Get form data
                    final formData = _formKey.currentState?.value;
                    //
                    // Optional: Show snackbar

                    User newUser = User.fromJson(formData!);
                    // context.read<API>().createUser(context, newUser);
                    Navigator.pop(context);
                  } else {
                    // Get form data
                    final formData = _formKey.currentState?.value;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Validation failed! -> Data: $formData',
                            textScaleFactor: 1.5),
                      ),
                    );
                  }

                  // Optional: unfocus keyboard
                  FocusScope.of(context).unfocus();
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}