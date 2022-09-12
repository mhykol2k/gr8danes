import 'package:flutter/material.dart';
import 'package:gr8danes/api/api.dart';
import 'package:gr8danes/models/order.dart';
import 'package:gr8danes/models/product_item.dart';
import 'httpReturn.dart';

extension ApiProductItem on API {
  static List<ProductItem> _productItems = [];
  static String? _currentCategory;
  static List<Order> _orders = [];

  List<ProductItem> get productItems => _productItems;
  String? get currentSite => _currentCategory;

  Future<void> getProductItems() async {
    httpCall.getData('get/api_products').then((result) {
      if (result.error == 0 && result.json != "[]") {
        _productItems = result.json
            .map<ProductItem>((jR) => ProductItem.fromJson(jR))
            .toList();
      } else {
        this.setConnectionIssue = "Problem Retrieving Product Items";
      }
    });
  }

  void createProductItem(BuildContext context, ProductItem newSite) async {
    final HttpReturn _ =
        await httpCall.postData(context, 'post/createSite', newSite.toJson());
    getProductItems();
  }

  void clearProductItems() {
    _productItems = [];
  }

  void setCategory(ProductItem selectedProductItem) async {
    _currentCategory = selectedProductItem.category;
  }

  void clearCategory() {
    _currentCategory = null;
  }
}