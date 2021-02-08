import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/screens/category.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/MyCart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<List<ProductData>> _getAllPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http
        .get(SEARCHPRODUCT + search, headers: {"Authorization": token});
    Products products = Products.fromJson(json.decode(response.body));
    return products.data;
  }

  String search = '';
  bool s = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(builder: (context, pro, child) {
      return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .95,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          s = true;
                        });
                      },
                      onChanged: (val) {
                        setState(() {
                          search = val;
                        });
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: grey,
                              ),
                              onPressed: () => Navigator.of(context).pop()),

                          // suffixIcon: s == true
                          //     ? IconButton(
                          //         icon: Icon(Icons.cancel),
                          //         onPressed: () => Navigator.pop(context))
                          //     : null,
                          // suffix: Text('₹' + pro.tprice.toStringAsFixed(0)),
                          // suffixStyle: TextStyle(color: black),
                          suffixIconConstraints:
                              BoxConstraints.tightFor(width: 60),
                          suffixIcon: Stack(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: black,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    changeScreenRepacement(context, Checkout());
                                  }),
                              Positioned(
                                // top: 0,
                                bottom: -5,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                      '₹' + pro.subtotal.toStringAsFixed(0)),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 15,
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
                          hintText: 'Search for Products',
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: _getAllPosts(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 20,
                            // color: Colors.black12,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Search result : " +
                                        snapshot.data.length.toString() +
                                        " items",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _listofitems(snapshot.data, context, true)
                      ],
                    );
                  }
                })
          ],
        ),
      )));
    });
  }
}

_listofitems(List<ProductData> products, BuildContext context, bool add) {
  return Container(
    height: MediaQuery.of(context).size.height - 150,
    // color: Colors.white30,
    child: ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            // height: 150,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 115,
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
                                          listen: true)
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
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  // height: 150,
                  width: MediaQuery.of(context).size.width - 150,

                  child: GestureDetector(
                      onTap: () {
                            return showDialog(
                                context: context,
                                builder: (ctx) => SimpleDialog(
                                      children: [
                                        DescPro(
                                          products: products[index],
                                        )
                                      ],
                                    ));
                          },
                                      child: Container(
                      // color: grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index].title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          products[index].size.length == 0
                              ? Container()
                              : AutoSizeText(
                                  products[index].size.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: grey),
                                ),

                          products[index].description.length == 0
                              ? Container()
                              : AutoSizeText(
                                  products[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: grey),
                                ),
                          // Text(
                          //   "₹" + products[index].sellingPrice.toString(),
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          RichText(
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            text: TextSpan(
                              children: <TextSpan>[
                                // TextSpan(
                                //   text: products[index].title + "\n",
                                //   style: TextStyle(
                                //     color: black,
                                //   ),
                                // ),
                                // TextSpan(
                                //   text: products[index].size.toString() + "\n",
                                //   style: TextStyle(
                                //     color: black,
                                //   ),
                                // ),
                                // TextSpan(
                                //   text: "${products[index].description} \n",
                                //   style: TextStyle(
                                //     color: grey,
                                //   ),
                                // ),
                                TextSpan(
                                  text: "₹" +
                                      products[index].sellingPrice.toString(),
                                  style: TextStyle(
                                    color: black,
                                  ),
                                ),
                               
                                           products[index].mrp ==
                                                   products[index].sellingPrice
                                                ? TextSpan()
                                                : TextSpan(
                                                    text: " ₹" +
                                                       products[index].mrp
                                                            .toString() +
                                                        "\t",
                                                    style: TextStyle(
                                                        color: grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough)),
                                            products[index].mrp ==
                                                   products[index].sellingPrice
                                                ? TextSpan()
                                                : TextSpan(
                                                    text:
                                                        "${(((products[index].mrp - products[index].sellingPrice) / products[index].mrp) * 100).toStringAsFixed(0)}% OFF",
                                                    style: TextStyle(
                                                        color: green,
                                                        fontWeight:
                                                            FontWeight.bold)),
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
