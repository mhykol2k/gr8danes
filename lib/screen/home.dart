import 'package:flutter/material.dart';
import '../screen/product_item/product_item_screen.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return ProductItemScreen();
  }
}