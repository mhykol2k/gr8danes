import 'package:flutter/material.dart';
import 'package:gr8danes/api/api.dart';
import 'package:gr8danes/models/order.dart';
import 'package:gr8danes/models/product_item.dart';
import 'package:gr8danes/screen/checkout/checkout.dart';
import 'package:gr8danes/widget/ftext.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Orders extends StatelessWidget with ChangeNotifier {
  Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewOrders(context);
  }
}

Widget ViewOrders(BuildContext context) {
  late List<Order> _orders;
  late List<Payee> _payees;
  _orders = context.watch<API>().orders;
  _payees = context.watch<API>().getPayees;
  Order? currentOrder = context.watch<API>().currentOrder;

  List<ProductItem> _productItems = [];
  if (currentOrder != null) {
    _productItems = List.from(currentOrder.reducedOrderItems());
  }

  double currentOrderTotal = 0;
  if (currentOrder != null) currentOrderTotal = currentOrder.orderTotal;

  double tips = 0;
  if (currentOrder != null) tips = currentOrder.getTips;

  return Container(
    color: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: ScrollPhysics(),
            child: context.watch<API>().editMode == false
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _orders
                        .map((e) => OrderButton(
                            context,
                            e,
                            currentOrder == e
                                ? Colors.blueAccent.shade100
                                : Colors.grey.shade100))
                        .toList(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentOrder != null)
                        OrderButton(
                          context,
                          currentOrder,
                          Colors.blueAccent.shade100,
                        ),
                    ],
                  ),
          ),
          if (context.watch<API>().editMode == false)
            currentOrder != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _productItems.length,
                      itemBuilder: (context, index) {
                        return OrderTile(context, index, _productItems[index]);
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: H1("Currently No orders."),
                    ),
                  ),
          if (context.watch<API>().editMode == false)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    currentOrder != null
                        ? SizedBox(
                            height: 90,
                            width: 90,
                            child: ElevatedButton(
                              onPressed: () {},
                              onLongPress: () {
                                context.read<API>().clearOrder();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red.shade500)),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 60.0,
                              ),
                            ),
                          )
                        : Container(),
                    currentOrder == null
                        ? H1("")
                        : SizedBox(
                            height: 90,
                            width: 180,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckMeOut(),
                                  ),
                                );
                              },
                              onLongPress: () {
                                context
                                    .read<API>()
                                    .printOrder(currentOrder, null);
                              },
                              child: Center(
                                child: H1(
                                    "£${currentOrderTotal.toStringAsFixed(2)}"),
                              ),
                            ),
                          ),
                    if (currentOrder != null)
                      if (1 == 0)
                        SizedBox(
                          height: 90,
                          width: 180,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                            onPressed: () {
                              double x =
                                  context.read<API>().currentOrder!.getTips;
                              context.read<API>().setTip(x + 1);
                            },
                            onLongPress: () {
                              context
                                  .read<API>()
                                  .printOrder(currentOrder, null);
                            },
                            child: Center(
                              child: H1(
                                  "Tips : £${currentOrder.getTips.toStringAsFixed(2)}"),
                            ),
                          ),
                        ),
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<API>().createOrder();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade500)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 60.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    H1("Grand Total: £" +
                        (currentOrderTotal + tips).toStringAsFixed(2))
                  ],
                ),
                if (1 == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _payees
                        .map((payee) => PayeeDetail(context, payee))
                        .toList(),
                  ),
              ],
            ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ),
  );
}

Widget PayeeDetail(BuildContext context, Payee payee) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (payee.active)
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.brown)),
              onPressed: () {},
              child: Center(
                child: H3("£" + payee.amount.toStringAsFixed(2)),
              ),
            ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    payee.active ? Colors.black : Colors.grey)),
            onPressed: () {
              context.read<API>().splitPayments(payee);
            },
            child: Center(
              child: H1(payee.payeeID.toString()),
            ),
          ),
          if (payee.active)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          payee.paymentMethod == "Card"
                              ? Colors.green
                              : Colors.red)),
                  onPressed: () {
                    context.read<API>().togglePaymentMethod(payee);
                  },
                  child: Center(
                    child: H4(payee.paymentMethod),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

Widget OrderButton(BuildContext context, Order order, Color isCurrentOrder) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            context.read<API>().setCurrentOrder(order);
          },
          child: Card(
            child: Container(
              width: 100,
              height: 100,
              color: isCurrentOrder,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  H3(order.orderID.toString() + " " + order.orderName),
                  H2("£" + order.orderTotal.toStringAsFixed(2)),
                  // H3("20:34")
                ],
              ),
            ),
          ),
        ),
        if (isCurrentOrder == Colors.blueAccent.shade100)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<API>().toggleEditMode();
                },
                child: !order.editMode ? H3("Edit") : H3("Save"),
              ),
              if (order.editMode)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AlphaKeyPress(context, "A"),
                        AlphaKeyPress(context, "B"),
                        AlphaKeyPress(context, "C"),
                        AlphaKeyPress(context, "D"),
                        AlphaKeyPress(context, "E"),
                        AlphaKeyPress(context, "F"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AlphaKeyPress(context, "G"),
                        AlphaKeyPress(context, "H"),
                        AlphaKeyPress(context, "I"),
                        AlphaKeyPress(context, "J"),
                        AlphaKeyPress(context, "K"),
                        AlphaKeyPress(context, "L"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AlphaKeyPress(context, "M"),
                        AlphaKeyPress(context, "N"),
                        AlphaKeyPress(context, "O"),
                        AlphaKeyPress(context, "P"),
                        AlphaKeyPress(context, "Q"),
                        AlphaKeyPress(context, "R"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AlphaKeyPress(context, "S"),
                        AlphaKeyPress(context, "T"),
                        AlphaKeyPress(context, "U"),
                        AlphaKeyPress(context, "V"),
                        AlphaKeyPress(context, "W"),
                        AlphaKeyPress(context, "X"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AlphaKeyPress(context, "Y"),
                        AlphaKeyPress(context, "Z"),
                        AlphaKeyPress(context, " "),
                        AlphaKeyPress(context, "<"),
                      ],
                    ),
                  ],
                )
            ],
          )
      ],
    ),
    // child: FloatingActionButton(
    //   backgroundColor: isCurrentOrder,
    //   foregroundColor: Colors.white,
    //   onPressed: () {
    //     context.read<API>().setCurrentOrder(order);
    //   },
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(15.0))),
    //   child: H2(order.orderID.toString()),
    // ),
  );
}

Widget AlphaKeyPress(BuildContext context, String char) => Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: () {
          context.read<API>().setOrderName(char);
        },
        child: H2(char),
      ),
    );