import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/products.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Trending extends StatefulWidget {
  Trending({Key key}) : super(key: key);

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  List<ProductData> products = [];

  Future<void> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(TRENDING, headers: {"authorization": token});
    print(response.body);
    if (response.statusCode == 200) {
      Products p = Products.fromJson(json.decode(response.body));
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

  bool fav = false;
  @override
  Widget build(BuildContext context) {
    return products.length == 0
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 170,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    width: 160,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 120,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
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
        : Container(
            height: 190,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              // padding: EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 170,
                    width: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(children: [
                          Container(
                            height: 100,
                            width: 160,
                            color: Colors.transparent,
                            child: Image.network(
                              products[index].imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: white),
                                child: IconButton(
                                    enableFeedback: true,
                                    icon: Provider.of<ProductModel>(context,
                                                listen: false)
                                            .isFav(products[index])
                                        ? Icon(
                                            Icons.favorite,
                                            color: red,
                                            size: 25,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            color: red,
                                            size: 25,
                                          ),
                                    onPressed: () {
                                      Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .isFav(products[index])
                                          ? Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .unfavProduct(products[index])
                                          : Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .addToFav(products[index]);
                                    }),
                              ))
                        ]),
                        AutoSizeText(
                          products[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          products[index].size.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "₹${products[index].sellingPrice}\t",
                                style: TextStyle(
                                  color: black,
                                ),
                              ),
                              TextSpan(
                                  text: "₹${products[index].mrp} \t",
                                  style: TextStyle(
                                      color: grey,
                                      decoration: TextDecoration.lineThrough)),
                              TextSpan(
                                  text:
                                      "${products[index].offPercentage.toStringAsFixed(0)}% OFF",
                                  style: TextStyle(
                                      color: green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 75,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: blue)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Provider.of<ProductModel>(context, listen: false)
                                          .getQuanity(products[index].id) ==
                                      0
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        
                                        Provider.of<ProductModel>(context,
                                                listen: false)
                                            .removeItem(products[index]);
                                        await addToCart(
                                            products[index].id,
                                            Provider.of<ProductModel>(context,
                                                    listen: false)
                                                .getQuanity(
                                                    products[index].id));
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: blue,
                                      ),
                                    ),
                              Provider.of<ProductModel>(context, listen: false)
                                          .getQuanity(products[index].id) ==
                                      0
                                  ? Text(
                                      'ADD',
                                      style: TextStyle(color: blue),
                                    )
                                  : Text(
                                      Provider.of<ProductModel>(context,
                                              listen: false)
                                          .getQuanity(products[index].id)
                                          .toString(),
                                      style: TextStyle(color: blue),
                                    ),
                              InkWell(
                                onTap: () async {
                                
                                  Provider.of<ProductModel>(context,
                                          listen: false)
                                      .addTaskInList(products[index]);
                                  await addToCart(
                                      products[index].id,
                                      Provider.of<ProductModel>(context,
                                              listen: false)
                                          .getQuanity(products[index].id));
                                },
                                child: Icon(
                                  Icons.add,
                                  color: blue,
                                ),
                              ),
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
