import 'dart:convert';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/screens/MyOrders.dart';
import 'package:grocery/screens/Settings.dart';
import 'package:grocery/screens/WishList.dart';
import 'package:grocery/screens/HomePage.dart';
import 'package:grocery/widgets/SearchProducts.dart';
import 'package:grocery/screens/MyCart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/commons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User res;
  String mob;
  read() async {
    final prefs = await SharedPreferences.getInstance();
    print('response');
    setState(() {
      res = User.fromJson(json.decode(prefs.getString('response')));

      mob = res.data.mobileNo;
      print(prefs.getString('token'));
    });
  }

  DateTime date = DateTime.now();
  int count = 0;
  @override
  void initState() {
    super.initState();
    read();
    // itemCount();
    _navigationController = new CircularBottomNavigationController(selectedPos);
  }

  @override
  void dispose() {
    _navigationController.dispose();

    super.dispose();
  }

  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.blue,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.favorite, "Favorite", red,
        labelStyle: TextStyle(color: black, fontWeight: FontWeight.bold)),
    new TabItem(Icons.shopping_basket, "Orders", purple),
    new TabItem(Icons.info_outline, "More Info  ", amber),
  ]);

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
          print(_navigationController.value);
        });
      },
    );
  }

  Widget bodyContainer() {
    Color selectedColor = tabItems[selectedPos].circleColor;
    Widget slogan;
    switch (selectedPos) {
      case 0:
        slogan = HomeScreen();
        break;
      case 1:
        slogan = WishList();
        break;
      case 2:
        slogan = MyOrder();
        break;
      case 3:
        slogan = Settings();
        break;
      default:
        slogan = HomeScreen();
        break;
    }

    return Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: slogan);
  }

  CircularBottomNavigationController _navigationController;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(builder: (context, pro, child) {
      return Scaffold(
        bottomNavigationBar: SizedBox(
            height: 90,
            child: bottomNav()),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('GetPharma'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: GestureDetector(
                onTap: () => changeScreen(context, SearchProduct()),
                child: Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    decoration: InputDecoration(
                        enabled: false,
                        icon: Icon(
                          Icons.search,
                          color: grey,
                        ),
                        hintText: 'Search for Products',
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: pcolor,
          actions: <Widget>[
            // InkWell(
            //     onTap: () {
            //       changeScreenRepacement(context, Checkout());
            //     },
            //     child: Icon(
            //       Icons.account_balance_wallet,
            //       size: 28,
            //     )),
            Stack(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: white,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  changeScreenRepacement(context, Checkout());
                                }),
                            Positioned(
                              // top: 0,
                              bottom: 0,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                    '₹' + pro.subtotal.toStringAsFixed(0)),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 5,
                              child: Container(
                                height: 15,
                                width: 18,
                                decoration: BoxDecoration(
                                    color: red,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: pink,
                                          offset: Offset(2, 2),
                                          blurRadius: 3)
                                    ]),
                                child: Center(
                                  child: Text(
                                    pro.getProductList().length.toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
          ],
        ),
        body: bodyContainer(),
      );
    });
  }
}
