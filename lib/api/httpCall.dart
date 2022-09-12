import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:gr8danes/widget/ftext.dart';
import 'package:provider/src/provider.dart';
import 'dart:convert' as convert;
import 'api.dart';
import 'httpReturn.dart';

const defaultDevelopmentServer = "black:8081";

class HttpCall with ChangeNotifier {
  String serverName = 'https://gr8danes.uk/api/sales';
  final Environment environment;
  final Function setConnectionStatus;

  HttpCall(this.environment, this.setConnectionStatus) {
    // serverName = _getServerName(environment);
  }

  changeEnvironment(Environment e) {
    // serverName = _getServerName(e);
  }

  static String _getServerName(Environment e) {
    switch (e) {
      case Environment.DEVELOPMENT:
        return (defaultDevelopmentServer);
      case Environment.TESTING:
        return (defaultDevelopmentServer);
      case Environment.PRODUCTION:
        return (defaultDevelopmentServer);
      default:
        return (defaultDevelopmentServer);
    }
  }

  /// GET CALL ///
  Future<HttpReturn> getData(String endPoint) async {
    var url = Uri.https(
      // serverName,
      'www.gr8danes.uk',
      '/api/sales/products',
    );
    print(url);
    // return HttpReturn(1, convert.jsonDecode("[]"));
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setConnectionStatus(true);
        var json = convert.jsonDecode(response.body);
        return HttpReturn(0, json);
      } else {
        setConnectionStatus(false);
        print('Request failed with status: ${response.statusCode}.');
        return HttpReturn(1, convert.jsonDecode("[]"));
      }
    } catch (xxx) {
      print(xxx.toString());
      setConnectionStatus(false);
      return HttpReturn(1, convert.jsonDecode("[]"));
    }
  }

  /// DELETE CALL ///
  Future<HttpReturn> deleteData(String endPoint) async {
    var url = Uri.http(
      serverName,
      '/$endPoint',
    );
    print(url);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setConnectionStatus(true);
        var json = convert.jsonDecode(response.body);
        return HttpReturn(0, json);
      } else {
        setConnectionStatus(false);
        print('Request failed with status: ${response.statusCode}.');
        return HttpReturn(1, convert.jsonDecode("[]"));
      }
    } catch (_) {
      setConnectionStatus(false);
      print('NO CONNECTION');
      return HttpReturn(1, convert.jsonDecode("[]"));
    }
  }

  /// PUT CALL ///
  Future<HttpReturn> putData(String endPoint) async {
    var url = Uri.http(
      serverName,
      '/$endPoint',
    );
    print(url);
    try {
      var response = await http.put(url);
      String x = response.statusCode.toString();
      print("RESPONSE CODE=========$x");

      if (response.statusCode == 200) {
        setConnectionStatus(true);
        var json = convert.jsonDecode(response.body);
        return HttpReturn(0, json);
      }

      if (response.statusCode == 405) {
        print(url);
        setConnectionStatus(false);
        print('Request failed with status: ${response.statusCode}.');
        return HttpReturn(1, convert.jsonDecode("[]"));
      }
      if (response.statusCode == 404) {
        print(url);
        setConnectionStatus(false);
        print('Request failed with status: ${response.statusCode}.');
        return HttpReturn(1, convert.jsonDecode("[]"));
      }
    } on HttpException catch (error) {
      print(error.message);
      setConnectionStatus(false);
      print('HHTTTPTP');
      return HttpReturn(1, convert.jsonDecode("[]"));
    }

    setConnectionStatus(false);
    print('Request failed');
    return HttpReturn(1, convert.jsonDecode("[]"));
  }

  /// POST CALL ///
  ///
  Future<HttpReturn> postData(
      BuildContext context, String endPoint, Map<String, dynamic>? data) async {
    var url = Uri.https(
      'www.gr8danes.uk',
      '/api/sales/order',
    );
    print(url);
    String str = json.encode(data);
    print(str);
    // return HttpReturn(0, json);
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: str,
      );
      String x = response.statusCode.toString();

      print("RESPONSE CODE=========$x");

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     duration: Duration(seconds: 2),
        //     content: Text('Order Successfully Submitted', textScaleFactor: 1.5),
        //   ),
        // );
        // context.read<API>().clearOrder();
        setConnectionStatus(true);
        var json = convert.jsonDecode(response.body);
        return HttpReturn(0, json);
      }
      if (response.statusCode == 301) {
        setConnectionStatus(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2("CONNECTION ERROR"),
                  H3(endPoint),
                  Text("Please check your internet connection"),
                ],
              ),
            ),
          ),
        );

        return HttpReturn(1, response.body);
      }
      if (response.statusCode == 502) {
        setConnectionStatus(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2("CONNECTION ERROR"),
                  H3(endPoint),
                  Text("Please check your internet connection"),
                ],
              ),
            ),
          ),
        );

        return HttpReturn(1, response.body);
      }
      if (response.statusCode == 415) {
        setConnectionStatus(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2("CONNECTION ERROR ${response.statusCode}"),
                  H3(endPoint),
                  Text("Please check your internet connection"),
                ],
              ),
            ),
          ),
        );

        return HttpReturn(1, response.body);
      }
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2("ERROR"),
                  H3(endPoint),
                  Text(response.body, textScaleFactor: 1.0),
                ],
              ),
            ),
          ),
        );

        print(url);
        setConnectionStatus(true);
        print('Request failed with status: ${response.statusCode}.');
        print(response.body);

        return HttpReturn(1, response.body);
      }
      if (response.statusCode == 405) {
        print(url);
        setConnectionStatus(false);
        print('Request failed with status: ${response.statusCode}.');
        return HttpReturn(1, convert.jsonDecode("[]"));
      }
      if (response.statusCode == 404) {
        print(url);
        setConnectionStatus(false);
        print('Request failed with status: ${response.statusCode}.');
        return HttpReturn(1, convert.jsonDecode("[]"));
      }
    } on HttpException catch (error) {
      print(error.message);
      setConnectionStatus(false);
      print('HHTTTPTP');
      return HttpReturn(1, convert.jsonDecode("[]"));
    }

    setConnectionStatus(false);
    print('Request failed');
    return HttpReturn(1, convert.jsonDecode("[]"));
  }
}