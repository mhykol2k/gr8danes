import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gr8danes/api/shared_preferences.dart';
import 'package:gr8danes/models/user.dart';
import 'package:gr8danes/screen/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'screen/home.dart';
import 'api/api.dart';
import 'widget/ftext.dart';
import 'dart:convert' as convert;

late final API api;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await retrieveEnvironment().then((environment) {
    retrieveUser().then((user) {
      api = API(environment, user);
      api.init();
      startApp();
    });
  });
}

void startApp() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => api,
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<User?> retrieveUser() async {
  await SharedPreferencesRepository.init();

  String currentUser = SharedPreferencesRepository.getString('currentUser');
  // print(currentUser);
  if (currentUser != '') {
    var json = convert.jsonDecode(currentUser);
    User user = User.fromJson(json);
    return user;
  } else
    return null;
}

Future<Environment> retrieveEnvironment() async {
  await SharedPreferencesRepository.init();

  String localEnvironment =
      SharedPreferencesRepository.getString('environment');

  switch (localEnvironment) {
    case 'Environment.DEVELOPMENT':
      return Environment.DEVELOPMENT;
    case 'Environment.TESTING':
      return Environment.TESTING;
    case 'Environment.PRODUCTION':
      return Environment.PRODUCTION;
  }
  if (kDebugMode) {
    return Environment.DEVELOPMENT;
  } else {
    return Environment.TESTING;
  }
}

class MyApp extends StatefulWidget with ChangeNotifier {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int _selectedIndex;
  late bool _connected;
  late String? _connectionIssue;

  @override
  void initState() {
    context.read<API>().getProductItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onItemTapped(int index) {
    context.read<API>().setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    _connected = context.watch<API>().connected;
    _connectionIssue = context.watch<API>().connectionIssue;

    if (context.watch<API>().currentUser == null) {
      return LoginScreen();
    }

    if (!context.watch<API>().initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: H1("The Patio")),
        ),
      );
    }

    if (!_connected) {
      return MaterialApp(
        title: 'ERROR',
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () => context.read<API>().reconnect(),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.lightGreen,
                  Colors.greenAccent,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Ftext("$_connectionIssue"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      child: MaterialApp(
        title: 'The Patio',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey.shade100,
            title: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/images/thepatio.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
          ),
          body: Center(
            child: Home(),
          ),
        ),
      ),
    );
  }
}