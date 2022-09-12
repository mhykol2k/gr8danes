import 'package:flutter/material.dart';
import 'package:gr8danes/api/httpCall.dart';
import 'package:gr8danes/api/httpReturn.dart';
import 'package:gr8danes/models/order_submission/order_submission.dart';
import 'package:gr8danes/models/user.dart';
import 'package:gr8danes/widget/ftext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_item.dart';
import '../models/order.dart';
import './httpCall.dart';
import './api_user.dart';
import 'api_product_item.dart';
import 'api_order.dart';
import './api_environment.dart';

class API with ChangeNotifier {
  Environment get activeEnvironment => ApiEnvironment(this).activeEnvironment;
  User? get currentUser => ApiUser(this).currentUser;
  void saveEnvironment(Environment e) =>
      ApiEnvironment(this).saveEnvironment(e);

  double get getTip => ApiOrder(this).getTip;
  void setTip(double tip) => ApiOrder(this).setTip(tip);

  List<Payee> get getPayees => ApiOrder(this).getPayees;
  void togglePaymentMethod(Payee payee) {
    ApiOrder(this).togglePaymentMethod(payee);
    notifyListeners();
  }

  void splitPayments(Payee payee) {
    ApiOrder(this).splitCosts(payee);
    notifyListeners();
  }

  late HttpCall httpCall;
  bool _initialized = false;
  bool get initialized => _initialized;
  int _selectedIndex = 0;
  String? _connectionIssue = 'Welcome To Gr8Danes';
  bool _connected = true;
  bool _editMode = false;

  bool get editMode => _editMode;

  String? currentCategory;
  void setCurrentCategory(String category) {
    currentCategory = category;
    notifyListeners();
  }

  void toggleEditMode() {
    bool mode = currentOrder!.editMode;
    _editMode =
        !mode; /* Overall edit mode is enabled so only render the current order */
    mode = !mode;
    currentOrder!.editMode = mode;
    notifyListeners();
  }

  void setOrderName(String orderName) {
    if (orderName == "<") {
      currentOrder!.changeOrderName = "";
      notifyListeners();
      return;
    }

    String orderNameCurrent = currentOrder!.orderName + orderName;
    currentOrder!.changeOrderName = orderNameCurrent;
    notifyListeners();
  }

  void setCurrentOrder(Order order) {
    ApiOrder(this).setCurrentOrder(order);
    notifyListeners();
  }

  void addToOrder(Order? currentOrder, ProductItem productItem) {
    if (currentOrder != null) {
      ApiOrder(this).addProduct(currentOrder, productItem);
      notifyListeners();
    }
  }

  void createOrder() {
    ApiOrder(this).createOrder();
    setCurrentOrder(orders.last);
    notifyListeners();
  }

  void completeOrder(BuildContext context, Order order,
      OrderSubmission orderSubmission) async {
    printOrder(order, orderSubmission);

    final HttpReturn httpReturn = await httpCall.postData(
      context,
      '/order',
      orderSubmission.toJson(),
    );
    // Need to read the response body header to ensure successful API submission
    if (httpReturn.error == 0) ApiOrder(this).clearOrder();
    // Navigator.pop(context);
    notifyListeners();
  }

  void printOrder(Order order, OrderSubmission? orderSubmission) {
    ApiOrder(this).printOrder(order, orderSubmission);
    notifyListeners();
  }

  void clearOrder() {
    if (_editMode == true) return;
    ApiOrder(this).clearOrder();
    notifyListeners();
  }

  void removeProductFromOrder(ProductItem productItem) {
    ApiOrder(this).removeProductFromOrder(productItem);
    notifyListeners();
  }

  List<Order> get orders => ApiOrder(this).orders;
  Order? get currentOrder => ApiOrder(this).currentOrder;
  List<ProductItem> get productItems => ApiProductItem(this).productItems;
  List<User> get users => ApiUser(this).users;

  set setConnectionIssue(String connectionIssue) =>
      _connectionIssue = connectionIssue;

  void getUsers() => ApiUser(this).getUsers();
  void getProductItems() => ApiProductItem(this).getProductItems();

/**********/

  void clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('localSiteGuid');
    setIndex(0);
    ApiProductItem(this).clearProductItems();
  }

  void clearSiteDependantData() async {
    setIndex(0);
  }

  int get selectedIndex => _selectedIndex;
  bool get connected => _connected;
  String? get connectionIssue => _connectionIssue;

  setCurrentUser(User user) {
    ApiUser(this).setCurrentUser(user);
    notifyListeners();
  }

  signOut() {
    ApiUser(this).signOut();
    notifyListeners();
  }

  setConnectionStatus(bool connectionStatus) {
    _connected = connectionStatus;
    notifyListeners();
  }

  API(Environment activeEnvironment, User? user) {
    ApiEnvironment(this).setEnvironment(activeEnvironment);
    if (user != null) ApiUser(this).setCurrentUser(user);
    httpCall = HttpCall(
      activeEnvironment,
      setConnectionStatus,
    );
  }

  API.updateData() {
    updateData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() {
    updateData();
  }

  void updateData() async {
    await ApiProductItem(this).getProductItems();
    //ApiUser(this).getUsers();
    //ApiOrder(this).getOrders();

    _initialized = true;
    notifyListeners();
  }

  void reconnect() {
    //Need to something more sophisticated here - like do an http request
    // and await successful response before setting _connected to true
    // as the UI updates immediately giving the impression of a connection
    _connected = true;
    _selectedIndex = 0;
    notifyListeners();
  }

  void setIndex(int _index) {
    // tinyVibrate();
    _selectedIndex = _index;
    notifyListeners();
  }

  /// GET CALLS ///

  void loginAttempt(BuildContext context, User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', user.toJson().toString());
    setCurrentUser(user);
    init();
  }
}