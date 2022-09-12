import 'package:flutter/material.dart';
import 'package:gr8danes/models/order.dart';
import 'package:gr8danes/screen/orders/orders.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import '../../widget/ftext.dart';
import '../../models/product_item.dart';

//ignore: must_be_immutable
class ProductItemScreen extends StatelessWidget with ChangeNotifier {
  late List<ProductItem> _productItems;

  ProductItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _productItems = context.watch<API>().productItems;

    return Scaffold(
      body: Row(
        children: [
          _productItems.length > 0 ? Categories(context) : SizedBox(),
          _productItems.length > 0 ? Products(context) : SizedBox(),
          Expanded(
            child: ViewOrders(context),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.grey.shade100,
        child: TextButton(
          onPressed: () {},
          child: H3("Development VERSION"),
        ),
      ),
    );
  }

  Widget Categories(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _updateProductItems(context),
              child: ListView.builder(
                itemCount: _productItems.length,
                itemBuilder: (context, index) {
                  if (index == 0) return ProductTile(context, index);
                  if (_productItems[index - 1].category !=
                      _productItems[index].category)
                    return ProductTile(context, index);
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Products(BuildContext context) {
    String? currentCategory = context.watch<API>().currentCategory;
    List<ProductItem> products =
        _productItems.where((f) => f.category == currentCategory).toList();
    ;
    return Container(
      color: Colors.grey.shade100,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _updateProductItems(context),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductItemTile(
                      context, index, products, currentCategory);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ProductTile(BuildContext context, int index) {
    return Container(
      decoration: new BoxDecoration(
        border: Border(right: BorderSide(width: 0.3, color: Colors.grey.shade100)),
      ),
      child: ListTile(
        onTap: () => context
            .read<API>()
            .setCurrentCategory(_productItems[index].category!),
        title: H2(
          '${_productItems[index].category}',
        ),
      ),
    );
  }

  Widget ProductItemTile(BuildContext context, int index,
      List<ProductItem> products, String? category) {
    Order? currentOrder = context.watch<API>().currentOrder;
    return Container(
      decoration: new BoxDecoration(
        border: Border(right: BorderSide(width: 0.3, color: Colors.grey.shade100)),
      ),
      child: ListTile(
        onTap: () =>
            context.read<API>().addToOrder(currentOrder, products[index]),
        title: H2(
          '${products[index].name}',
        ),
        trailing: H2('£${products[index].retailPrice.toStringAsFixed(2)}'),
      ),
    );
  }

  Future<void> _updateProductItems(BuildContext context) async {
    context.read<API>().getProductItems();
  }

  // selectSite(BuildContext context, ProductItem productItem) {
  //   context.read<API>().setCurrentCategory(productItem.category!);
  // }
}