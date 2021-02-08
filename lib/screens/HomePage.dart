import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/screens/Category.dart';
import 'package:grocery/screens/Trending.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../helpers/commons.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductCategoryData> products = [];

  bool fav = false;
  Future<Null> _refreshLocalGallery() async {
    await new Future.delayed(new Duration(seconds: 3));
    getProducts();
  }

  Future<void> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response =
        await http.get(PRODUCTCATEGORY, headers: {"authorization": token});
    if (response.statusCode == 200) {
      ProductCategory p = ProductCategory.fromJson(json.decode(response.body));
      setState(() {
        products = p.data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshLocalGallery(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  height: 45,
                  width: double.infinity,
                  color: Colors.deepPurple[200],
                  child: Center(
                      child: Text(
                    'Shop by Category',
                    style: TextStyle(color: white, fontSize: 20),
                  )),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: white),
                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 40,
                      ),
                    ),
                  ),
                )
              ]),
              products.length == 0
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 4
                                          : 3,
                                ),
                                itemBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 80.0,
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                            ),
                                            Container(
                                              width: 80,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0),
                                            ),
                                            Container(
                                              width: 60,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0),
                                            ),
                                            Container(
                                              width: 40.0,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                itemCount: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      addRepaintBoundaries: true,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 4
                            : 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => changeScreen(
                              context,
                              ShopByCategory(
                                id: products[index].id,
                                cat: products[index].title,
                              )),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      products[index].imageUrl,
                                      fit: BoxFit.contain,
                                      height: 80,
                                      width: 80,
                                    )),
                                Text(products[index].title,maxLines: 3,overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              // Cardwidget(),
              Stack(children: [
                Container(
                  height: 45,
                  width: double.infinity,
                  color: Colors.green[200],
                  child: Center(
                      child: Text(
                    'Trending',
                    style: TextStyle(color: white, fontSize: 20),
                  )),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: white),
                        child:
                            Image.asset('images/plan.png', fit: BoxFit.fill)),
                  ),
                )
              ]),
              Trending(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
