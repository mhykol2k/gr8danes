import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gr8danes/api/api.dart';

enum Environment { PRODUCTION, TESTING, DEVELOPMENT }

PreferredSizeWidget appBarSettings(String title) => AppBar(
      title: H2(
        title,
      ),
      actions: [
        PopAllRoutesButton(),
      ],
      iconTheme: IconThemeData(color: Colors.white),
    );
// ignore: non_constant_identifier_names
Text Ftext(String text) {
  return Text(
    text,
    style: GoogleFonts.lexendDeca(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
  );
}

Text H1(String text) {
  return Text(
    text,
    style: GoogleFonts.lexendDeca(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w900,
      fontSize: 25,
    ),
  );
}

Text H2(String text) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    maxLines: 1,
    style: GoogleFonts.lexendDeca(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
  );
}

Text H3(String text) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    softWrap: false,
    maxLines: 1,
    style: GoogleFonts.aBeeZee(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
  );
}

Text H3red(String text) {
  return Text(
    text,
    style: GoogleFonts.lexendDeca(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 15,
      color: Colors.red,
    ),
  );
}

Text H4(String text) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    softWrap: false,
    maxLines: 1,
    style: GoogleFonts.aBeeZee(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 10,
    ),
  );
}

TextStyle AppFontStyle() {
  return GoogleFonts.lexendDeca(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 17,
  );
}

BoxDecoration msuGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xffffffff),
        Color(0xffffffff),
      ],
    ),
  );
}

BoxDecoration msuGradient2() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xff23ffff),
        Color(0xffffffff),
      ],
    ),
  );
}

BoxDecoration standOutDecoration() {
  return BoxDecoration(
    color: new Color(0x33BBBBBB),
    borderRadius: BorderRadius.circular(20),
  );
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
      primary: Color(0xff165487),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
}

ButtonStyle buttonStyleSmall() {
  return ElevatedButton.styleFrom(
      primary: Color(0xff165487),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold));
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
            transitionDuration: Duration(milliseconds: 200),
            reverseTransitionDuration: Duration(seconds: 200));
}

class NoTransition extends PageRouteBuilder {
  final Widget page;
  NoTransition({required this.page})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
            transitionDuration: Duration(milliseconds: 0),
            reverseTransitionDuration: Duration(seconds: 0));
}

class PopAllRoutesButton extends StatelessWidget with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            context.read<API>().setIndex(0);
            notifyListeners();
          },
          child: Icon(
            Icons.cancel_sharp,
            size: 26.0,
          ),
        ));
  }
}

String? validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern.toString());
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}