import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api.dart';
import '../widget/ftext.dart';

//ignore: must_be_immutable
class EnvironmentScreen extends StatelessWidget with ChangeNotifier {
  EnvironmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Environment',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopAllRoutesButton(),
        ],
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Container(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EnvironmentChangerButton(
                  context, "DEV", Environment.DEVELOPMENT, Colors.green),
              EnvironmentChangerButton(
                  context, "TEST", Environment.TESTING, Colors.blue),
              EnvironmentChangerButton(
                  context, "PROD", Environment.PRODUCTION, Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton EnvironmentChangerButton(
      BuildContext context, String text, Environment e, Color c) {
    return FloatingActionButton(
      child: H3(text),
      backgroundColor: c,
      onPressed: () {
        context.read<API>().saveEnvironment(e);
        Navigator.pop(context);
      },
    );
  }
}