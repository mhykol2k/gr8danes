import 'package:gr8danes/models/order.dart';
import 'package:gr8danes/models/product_item.dart';
import 'package:json_annotation/json_annotation.dart';

class OrderPayment {
  String? paymentMethod;
  String? amount;

  OrderPayment({
    this.paymentMethod,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        'PaymentMethod': paymentMethod,
        'Amount': amount,
      };
}

@JsonSerializable()
class OrderSubmission {
  @JsonKey(name: 'SubTotal')
  String? subTotal;
  @JsonKey(name: 'Tips')
  String? tips;
  @JsonKey(name: 'Discount')
  String? discount;
  @JsonKey(name: 'Delivery')
  String? delivery;
  @JsonKey(name: 'Total')
  String? total;
  @JsonKey(name: 'CreatedBy')
  String? createdBy;
  @JsonKey(name: 'OrderNotes')
  String? orderNotes;
  @JsonKey(name: 'OrderItems')
  List<ProductItem> orderItems;
  @JsonKey(name: 'OrderPayments')
  List<OrderPayment> orderPayments;
  @JsonKey(name: 'Email')
  String? email;
  @JsonKey(name: 'IdempotencyKey')
  String? idempotencyKey;

  OrderSubmission({
    this.subTotal,
    this.tips,
    this.discount,
    this.delivery,
    this.total,
    this.createdBy,
    this.orderNotes,
    required this.orderItems,
    required this.orderPayments,
    required this.email,
    required this.idempotencyKey,
  });

  @override
  String toString() {
    return 'OrderSubmission(subTotal: $subTotal, tips: $tips, discount: $discount, delivery: $delivery, total: $total, createdBy: $createdBy, orderNotes: $orderNotes, orderItems: $orderItems, orderPayments: $orderPayments)';
  }

  double totalPayments() {
    double subTotal = 0;
    this.orderPayments.forEach((OrderPayment payment) {
      subTotal += double.parse(payment.amount!);
    });
    return subTotal;
  }

  factory OrderSubmission.fromJson(
    Map<String, dynamic> json,
    Order currentOrder,
  ) {
    double currentOrderTotal = 0;
    currentOrder.orderItems.forEach((element) {
      currentOrderTotal =
          currentOrderTotal + (element.retailPrice * element.quantity!);
    });

    double tips = double.parse(json["tips"]);
    double delivery = double.parse(json["delivery"]);

    double total = currentOrderTotal + tips + delivery;
    List<OrderPayment> orderPayments = [];

    if (double.parse(json['amount1']) != 0) {
      orderPayments.add(OrderPayment(
        paymentMethod: json['paymentMethod1'],
        amount: json["amount1"],
      ));
    }

    if (double.parse(json['amount2']) != 0) {
      orderPayments.add(OrderPayment(
        paymentMethod: json['paymentMethod2'],
        amount: json["amount2"],
      ));
    }

    if (double.parse(json['amount3']) != 0) {
      orderPayments.add(OrderPayment(
        paymentMethod: json['paymentMethod3'],
        amount: json["amount3"],
      ));
    }

    if (double.parse(json['amount4']) != 0) {
      orderPayments.add(OrderPayment(
        paymentMethod: json['paymentMethod4'],
        amount: json["amount4"],
      ));
    }

    if (double.parse(json['amount5']) != 0) {
      orderPayments.add(OrderPayment(
        paymentMethod: json['paymentMethod5'],
        amount: json["amount5"],
      ));
    }
    return OrderSubmission(
      subTotal: currentOrderTotal.toString(),
      tips: json['tips'] as String,
      discount: "0",
      delivery: json['delivery'] as String,
      total: total.toString(),
      createdBy: 'The Patio',
      orderNotes: currentOrder.orderName,
      orderItems: currentOrder.reducedOrderItemsPrice(),
      orderPayments: orderPayments,
      email: 'thepatio@gr8danes.uk',
      idempotencyKey: currentOrder.idempotencyKey,
    );
  }
  Map<String, dynamic> toJson() => {
        'SubTotal': subTotal,
        'Tips': tips,
        'Discount': discount,
        'Delivery': delivery,
        'Total': total,
        'CreatedBy': createdBy,
        'OrderNotes': orderNotes,
        'OrderItems': orderItems,
        'OrderPayments': orderPayments,
        'Email': email,
        'IdempotencyKey': idempotencyKey,
      };
}