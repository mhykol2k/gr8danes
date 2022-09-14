import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gr8danes/api/api.dart';
import 'package:gr8danes/models/order_submission/order_submission.dart';
import 'package:gr8danes/models/product_item.dart';
import 'package:gr8danes/widget/ftext.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
class CheckMeOut extends StatelessWidget with ChangeNotifier {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    double currentOrderTotal = 0;
    List<ProductItem> rItems =
        context.watch<API>().currentOrder!.reducedOrderItems();

    rItems.forEach((element) {
      currentOrderTotal = currentOrderTotal + (element.retailPrice);
    });
    int rLength = rItems.length;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: H1(
                          "Bar Tab: ${context.watch<API>().currentOrder!.orderName}"),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemCount: rLength,
                          itemBuilder: (context, index) {
                            return OrderTile(context, index, rItems[index]);
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Align(
                        alignment: Alignment.centerRight,
                        child: H1(
                          "Total : £" + currentOrderTotal.toStringAsFixed(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          child: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: 340,
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: H1("Payment Details"),
                  ),
                  if (context.watch<API>().currentOrder != null)
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Container OrderTile(BuildContext context, int index, ProductItem orderItem) {
  double itemPrice = orderItem.retailPrice;
  if (orderItem.quantity != null) {
    itemPrice = orderItem.retailPrice / orderItem.quantity!;
  }
  return Container(
    decoration: new BoxDecoration(
      border: Border(right: BorderSide(width: 0.3, color: Colors.black)),
    ),
    child: ListTile(
      onLongPress: () => context.read<API>().removeProductFromOrder(orderItem),
      title: Align(
        alignment: Alignment.centerRight,
        child: H2(
          '${orderItem.name}',
        ),
      ),
      leading: H2(
          "Qty:${orderItem.quantity.toString()} (£${itemPrice.toStringAsFixed(2)})"),
      trailing: H2('£${(orderItem.retailPrice).toStringAsFixed(2)}'),
    ),
  );
}


class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    // String value = newValue.text;

    // if (value.contains(".") &&
    //     value.substring(value.indexOf(".") + 1).length > decimalRange) {
    //   truncated = oldValue.text;
    //   newSelection = oldValue.selection;
    // } else if (value == ".") {
    //   truncated = "0.";

    //   newSelection = newValue.selection.copyWith(
    //     baseOffset: math.min(truncated.length, truncated.length + 1),
    //     extentOffset: math.min(truncated.length, truncated.length + 1),
    //   );
    // }

    return TextEditingValue(
      text: double.parse(truncated).toStringAsFixed(2),
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

// ignore: must_be_immutable
class MoneyField extends StatelessWidget with ChangeNotifier {
  int paymentNumber;
  double orderTotal;
  List<String> paymentTypes = ["Cash", "Card"];

  MoneyField({
    required this.paymentNumber,
    required this.orderTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: FormBuilderDropdown(
            name: "paymentMethod${paymentNumber.toString()}",
            initialValue: "Card",
            items: paymentTypes
                .map((paymentType) => DropdownMenuItem(
                    value: paymentType, child: H3(paymentType)))
                .toList(),
          ),
        ),
        Spacer(flex: 4),
        Flexible(
          flex: 5,
          child: FormBuilderTextField(
            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            name: 'amount${paymentNumber.toString()}',
            autofocus: false,
            initialValue:
                paymentNumber == 1 ? orderTotal.toStringAsFixed(2) : "0",
            textAlign: TextAlign.right,
            autocorrect: false,
            //keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "(Enter Value)",
              fillColor: Colors.white70,
            ),
            // validator: (value) {

            //   return null;
            // },
          ),
        ),
      ],
    );
  }
}