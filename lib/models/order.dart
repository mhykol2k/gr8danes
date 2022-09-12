import 'package:flutter/foundation.dart';
import 'package:gr8danes/models/product_item.dart';

class Payee with ChangeNotifier {
  late int payeeID;
  bool active;
  double amount = 0;
  String paymentMethod = "Card";
  Payee({required this.payeeID, required this.active});

  void togglePaymentMethod() {
    if (paymentMethod == "Cash") {
      paymentMethod = "Card";
    } else {
      paymentMethod = "Cash";
    }
  }
}

class Order with ChangeNotifier {
  late int orderID;
  String orderName = '';
  bool editMode = false;
  List<ProductItem> orderItems = [];
  String? idempotencyKey;
  double _tips = 0;
  List<Payee> _payees = [
    Payee(payeeID: 1, active: false),
    Payee(payeeID: 2, active: false),
    Payee(payeeID: 3, active: false),
    Payee(payeeID: 4, active: false),
    Payee(payeeID: 5, active: false),
  ];

  void splitCosts(Payee payee, Order currentOrder) {
    double orderTotal = currentOrder.orderTotal + currentOrder.getTips;
    double payeeAmount = orderTotal / payee.payeeID;
    payeeAmount = double.parse(payeeAmount.toStringAsFixed(2));
    _payees.forEach((element) {
      if (element.payeeID <= payee.payeeID) {
        element.active = true;
        if (element.payeeID == payee.payeeID) {
          element.amount = orderTotal;
        } else {
          element.amount = payeeAmount;
        }
        orderTotal = orderTotal - payeeAmount;
      } else {
        element.active = false;
        element.amount = 0;
      }
    });
  }

  List<Payee> get getPayees => _payees;
  void togglePaymentMethod(Payee payee) {
    payee.togglePaymentMethod();
  }

  Order({required this.orderID, required this.idempotencyKey});

  void set changeOrderName(String newOrderName) {
    orderName = newOrderName;
  }

  void set setEditMode(bool mode) {
    editMode = mode;
  }

  void setTips(double tips) {
    _tips = tips;
    notifyListeners();
  }

  double get getTips {
    return _tips;
  }

  double get orderTotal {
    double currentOrderTotal = 0;
    List<ProductItem> items = this.reducedOrderItems();
    items.forEach((element) {
      currentOrderTotal = currentOrderTotal + (element.retailPrice);
    });
    return currentOrderTotal;
  }

  List<ProductItem> reducedOrderItems() {
    final Map orderMap = Map<int, ProductItem>();
    this.orderItems.forEach((item) {
      int key = item.productItemID;
      if (orderMap.containsKey(key)) {
        orderMap[key].quantity += 1;
        orderMap[key].retailPrice = orderMap[key].quantity * item.retailPrice;
      } else {
        orderMap[key] = new ProductItem(
            productItemID: key,
            name: item.name,
            retailPrice: item.retailPrice,
            quantity: 1);
      }
    });

    List<ProductItem> rOrderItems = [];
    rOrderItems = orderMap.entries
        .map((e) => new ProductItem(
              productItemID: e.value.productItemID,
              retailPrice: e.value.retailPrice,
              name: e.value.name,
              quantity: e.value.quantity,
            ))
        .toList();
    return rOrderItems;
  }

  List<ProductItem> reducedOrderItemsPrice() {
    final Map orderMap = Map<int, ProductItem>();
    this.orderItems.forEach((item) {
      int key = item.productItemID;
      if (orderMap.containsKey(key)) {
        orderMap[key].quantity += 1;
        orderMap[key].retailPrice = item.retailPrice;
      } else {
        orderMap[key] = new ProductItem(
            productItemID: key,
            name: item.name,
            retailPrice: item.retailPrice,
            quantity: 1);
      }
    });

    List<ProductItem> rOrderItems = [];
    rOrderItems = orderMap.entries
        .map((e) => new ProductItem(
              productItemID: e.value.productItemID,
              retailPrice: e.value.retailPrice,
              name: e.value.name,
              quantity: e.value.quantity,
            ))
        .toList();
    return rOrderItems;
  }

  Map<String, dynamic> toJson() => {
        'orderItems': orderItems,
      };
}