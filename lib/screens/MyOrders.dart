import 'dart:convert';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/screens/OrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/OrderModel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List<OrderData> list;
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getAmount(List<Products> pro) {
    dynamic total = 0;
    for (var i in pro) {
      total = total + i.noOfUnits * i.rate;
    }
    return total;
  }

  getColors(dynamic order) {
    switch (order.orderStatus) {
      case 'cancelled':
        return red;

        break;
      case 'pending':
        return amber;

        break;
      case 'delivered':
        return green;

        break;
      default:
        return green;
    }
  }

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(GETORDERS, headers: {
      "Authorization": token,
    });
    var res = await http.get(HISTORY, headers: {
      "Authorization": token,
    });
    print('Response status: ${response.body}');
    if (response.statusCode == 200 && res.statusCode == 200) {
      MyOrders orders = MyOrders.fromJson(json.decode(response.body));
      setState(() {
        list = orders.data;
      });
    } else {
      print('failed');
      return false;
    }
  }

  bool fav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height -
            (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top),
        child: list == null
            ? Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              )
            : list.length == 0
                ? Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Image.asset(
                        'images/emptycart.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(list[index].id.toString()),
                        confirmDismiss: (DismissDirection dismiss) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      'To cancel this order please contact the admin'),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text('okay'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                              onTap: () => changeScreen(
                                  context,
                                  OrderDetails(
                                    order: list[index],
                                    type: 'pending',
                                    color: getColors(list[index]),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 160,
                                  decoration:
                                      BoxDecoration(color: white, boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        color: getColors(list[index]),
                                        offset: Offset(1, 1),
                                        spreadRadius: 2)
                                  ]),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: <Widget>[

                                      //   ],
                                      // ),
                                      ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Text(
                                            'OrderId: ${list[index].orderId}',
                                            style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Text(
                                              'OTP: ${list[index].deliveryCode}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: blue,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Text(
                                          "Delivery Date: ${DateFormat('dd-MM-yy').format(DateTime.parse(list[index].expectedDate))}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "Delivery Charge:₹${list[index].deliveryCharge}",
                                          style: TextStyle(
                                              color: blue,
                                              fontWeight: FontWeight.bold)),
                                      ListTile(
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.shopping_cart,
                                                    // color: white,
                                                    size: 35,
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 15,
                                                      width: 18,
                                                      decoration: BoxDecoration(
                                                          color: white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                offset: Offset(
                                                                    1, 1),
                                                                blurRadius: 2)
                                                          ]),
                                                      child: Center(
                                                        child: Text(
                                                          list[index]
                                                              .products
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text("₹" +
                                                  getAmount(
                                                          list[index].products)
                                                      .toStringAsFixed(1))
                                            ],
                                          ),
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.shopping_cart,
                                                    // color: white,
                                                    size: 35,
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 15,
                                                      width: 18,
                                                      decoration: BoxDecoration(
                                                          color: red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .redAccent,
                                                                offset: Offset(
                                                                    1, 1),
                                                                blurRadius: 2)
                                                          ]),
                                                      child: Center(
                                                        child: Text(
                                                          list[index]
                                                              .pendingProducts
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text("₹" +
                                                  getAmount(list[index]
                                                          .pendingProducts)
                                                      .toStringAsFixed(1))
                                            ],
                                          ),
                                        ),
                                        trailing: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Stack(
                                                children: <Widget>[
                                                  // Icon(
                                                  //   Icons
                                                  //       .shopping_cart,
                                                  //   // color: white,
                                                  //   size: 35,
                                                  // ),
                                                  Container(
                                                      height: 35,
                                                      width: 50,
                                                      child: Image.asset(
                                                        'images/bill.jpeg',
                                                        fit: BoxFit.contain,
                                                      )),
                                                  Positioned(
                                                    top: 0,
                                                    right: 6,
                                                    child: Container(
                                                      height: 15,
                                                      width: 18,
                                                      decoration: BoxDecoration(
                                                          color: green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .lightGreen,
                                                                offset: Offset(
                                                                    2, 2),
                                                                blurRadius: 3)
                                                          ]),
                                                      child: Center(
                                                        child: Text(
                                                          list[index]
                                                              .completeProducts
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text("₹" +
                                                  (getAmount(list[index]
                                                              .completeProducts) +
                                                          list[index]
                                                              .deliveryCharge)
                                                      .toStringAsFixed(1))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      );
                    }),
      ),
    );
  }
}
