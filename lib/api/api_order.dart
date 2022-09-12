import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:gr8danes/api/api.dart';
import 'package:intl/intl.dart';
import 'package:gr8danes/api/printer.dart';
import 'package:gr8danes/models/order.dart';
import 'package:gr8danes/models/product_item.dart';
import 'package:gr8danes/models/order_submission/order_submission.dart';
import 'package:uuid/uuid.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

extension ApiOrder on API {
  static Order? _currentOrder;
  static List<Order> _orders = [];

  double get getTip => _currentOrder!.getTips;
  void setTip(double tip) {
    _currentOrder!.setTips(tip);
    notifyListeners();
  }

  List<Payee> get getPayees {
    if (_currentOrder == null) return [];
    return _currentOrder!.getPayees;
  }

  void splitCosts(Payee payee) {
    _currentOrder!.splitCosts(payee, _currentOrder!);
  }

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  void togglePaymentMethod(Payee payee) {
    _currentOrder!.togglePaymentMethod(payee);
  }

  void addProduct(Order order, ProductItem productItem) {
    productItem.quantity = 1;
    order.orderItems.add(productItem);
  }

  void setOrderName(String orderName) {
    if (_currentOrder != null) {
      _currentOrder?.changeOrderName = orderName;
    }
  }

/*  void completeOrder(BuildContext context, Order order) async {
    printOrder(order);
    orders.remove(order);
    if (orders.length > 0) {
      setCurrentOrder(orders.first);
    } else
      _currentOrder = null;
    final HttpReturn _ =
        await httpCall.postData(context, 'post/createOrder', order.toJson());
  }
*/
  void printOrder(Order order, OrderSubmission? orderSubmission) async {
    Printer printer = Printer();
    if (await printer.connectPrinter() == 0) {
      return null;
    }
    List<ProductItem> rItems = order.reducedOrderItems();

    final ByteData data =
        await rootBundle.load('assets/images/thepatio_receipt.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image? image = decodeImage(bytes);
    printer.print.image(image!);

    printer.print.feed(1);
    printer.print.text("Table/Name: " + order.orderName,
        styles: PosStyles(align: PosAlign.center));
    printer.print.feed(1);

    printer.print
        .text('Great Danes', styles: PosStyles(align: PosAlign.center));
    printer.print
        .text('Frinton On Sea', styles: PosStyles(align: PosAlign.center));
    printer.print
        .text('Tel: 01255 852285', styles: PosStyles(align: PosAlign.center));
    printer.print.text('Web: www.gr8danes.uk',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.print.hr();

    printer.print.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    rItems.forEach((orderItem) {
      double itemPrice = orderItem.retailPrice;
      if (orderItem.quantity != null) {
        itemPrice = orderItem.retailPrice / orderItem.quantity!;
      }

      printer.print.row([
        PosColumn(text: orderItem.quantity!.toString(), width: 1),
        PosColumn(text: orderItem.name.toString(), width: 7),
        PosColumn(
            text: "£" + itemPrice.toStringAsFixed(2),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: "£" + (orderItem.retailPrice).toStringAsFixed(2),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });

    printer.print.hr();
    double currentOrderTotal = order.orderTotal;

    if (orderSubmission != null) {
      currentOrderTotal += double.parse(orderSubmission.tips!);
      currentOrderTotal += double.parse(orderSubmission.delivery!);
      printer.print.row([
        PosColumn(
            text: 'TIPS',
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
        PosColumn(
            text: "£" + double.parse(orderSubmission.tips!).toStringAsFixed(2),
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
      ]);
      printer.print.row([
        PosColumn(
            text: 'DELIVERY',
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
        PosColumn(
            text: "£" +
                double.parse(orderSubmission.delivery!).toStringAsFixed(2),
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
      ]);
    }

    printer.print.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: "£" + currentOrderTotal.toStringAsFixed(2),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    printer.print.hr(ch: '=', linesAfter: 1);

    // printer.print.row([
    //   PosColumn(
    //       text: 'Cash',
    //       width: 8,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(
    //       text: '£0.00',
    //       width: 4,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);
    // printer.print.row([
    //   PosColumn(
    //       text: 'Change',
    //       width: 8,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    //   PosColumn(
    //       text: '£0.00',
    //       width: 4,
    //       styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    // ]);

    printer.print.feed(2);
    printer.print.text('Mange Tak!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.print.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());

    //   printer.print.image(img);
    // } catch (e) {
    //   print(e);
    // }

    // Print QR Code using native function
    // printer.print.qrcode('example.com');

    printer.print.feed(1);
    printer.print.cut();
    printer.disconnect();
  }

  void setCurrentOrder(Order order) {
    _currentOrder = order;
  }

  void clearOrder() {
    _orders.remove(currentOrder);
    if (_orders.length > 0) {
      _currentOrder = _orders.last;
    } else
      _currentOrder = null;
  }

  // void longVibrate() async {
  //   if (!UniversalPlatform.isDesktop) {
  //     bool? v = await Vibration.hasVibrator();
  //     try {
  //       if (v == true) {
  //         Vibration.vibrate(duration: 200);
  //       }
  //     } catch (_) {}
  //   }
  // }

  // void tinyVibrate() async {
  //   if (!UniversalPlatform.isDesktop) {
  //     bool? v = await Vibration.hasVibrator();
  //     try {
  //       if (v == true) {
  //         Vibration.vibrate(duration: 50);
  //       }
  //     } catch (_) {}
  //   }
  // }

  void createOrder() {
    int newOrderNumber = 1;
    if (orders.length > 0) {
      newOrderNumber = orders.map((e) => e.orderID).toList().reduce(max) + 1;
    }
    var uuid = Uuid();
    var idempotencyKey = uuid.v1();
    orders.add(new Order(
      orderID: newOrderNumber,
      idempotencyKey: idempotencyKey.toString(),
    ));
  }

  void removeProductFromOrder(ProductItem productItem) {
    // _currentOrder!.orderItems.remove(productItem);
    List<ProductItem> items = _currentOrder!.orderItems;
    ProductItem? x;
    items.forEach((element) {
      if (element.productItemID == productItem.productItemID) {
        x = element;
      }
    });
    if (x != null) {
      _currentOrder!.orderItems.remove(x);
    }
  }
}