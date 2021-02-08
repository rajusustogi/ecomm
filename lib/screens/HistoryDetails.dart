import 'dart:convert';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/History.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/OrderModel.dart';
import 'package:grocery/screens/OrderDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryDetails extends StatefulWidget {
  HistoryDetails({Key key}) : super(key: key);

  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  List<DeliveredOrders> list;
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
        return red;
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
      // MyOrders orders = MyOrders.fromJson(json.decode(response.body));
      Delivered history = Delivered.fromJson(json.decode(res.body));

      setState(() {
        list = history.data.reversed.toList();
      });
    } else {
      print('failed');
      return false;
    }
  }

  bool fav = false;
  @override
  Widget build(BuildContext context) {
    var height = AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              height,
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
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                              onTap: () => changeScreen(
                                  context,
                                  OrderDetails(
                                    order: list[index],
                                    type: 'complete',
                                    color: getColors(list[index]),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 150,
                                  decoration:
                                      BoxDecoration(color: white, boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        color: getColors(list[index]),
                                        offset: Offset(1, 1),
                                        spreadRadius: 2)
                                  ]),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        trailing: Column(
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
                                                              offset:
                                                                  Offset(1, 1),
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
                                                getAmount(list[index].products)
                                                    .toString())
                                          ],
                                        ),
                                        leading: Text(
                                          'OrderId: ${list[index].orderId}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                          'Delivery Date: ${DateFormat('dd-MM-yy').format(DateTime.parse(list[index].deliveryDate))}, ${DateFormat.jm().format(DateTime.parse(list[index].createdAt))}',
                                          overflow: TextOverflow.ellipsis),
                                      Text(
                                        'Delivered by: ${list[index].deliveryMan}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                          'Delivery Charge: ₹${list[index].deliveryCharge}',
                                          overflow: TextOverflow.ellipsis),
                                      Text(
                                          'Total Amount: ₹${list[index].amount}',
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }),
        ),
      ),
    );
  }
}
