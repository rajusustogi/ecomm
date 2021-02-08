import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/MyCart.dart';
import 'package:grocery/widgets/SearchProducts.dart';
import 'package:paging/paging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShopByCategory extends StatefulWidget {
  final int id;
  final String cat;
  const ShopByCategory({this.id, this.cat});
  @override
  _ShopByCategoryState createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  Future<List<ProductData>> pageData(int previousCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(
        PRODUCTS +
            widget.id.toString() +
            "/?limit=10&offset=${previousCount + 10}",
        headers: {"authorization": token});
    print("Pagination" + response.body);
    if (response.statusCode == 200) {
      Products p = Products.fromJson(json.decode(response.body));

      return p.data;
    } else {
      List<ProductData> p = [];
      return p;
    }
  }

  bool fav = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(
      builder: (context, pro, child) {
        return Scaffold(
          appBar: AppBar(
            title: AutoSizeText(widget.cat.toUpperCase()),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => changeScreen(context, SearchProduct())),
              Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 5),
                child: Stack(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: white,
                          size: 30,
                        ),
                        onPressed: () async {
                          changeScreenRepacement(context, Checkout());
                        }),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text('₹' + pro.subtotal.toStringAsFixed(0)),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
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
              ),
            ],
          ),
          body: Pagination(
            pageBuilder: (currentListSize) => pageData(currentListSize - 10),
            itemBuilder: (index, ProductData products) {
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
                              products.imageUrl,
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
                                            .isFav(products)
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
                                              .isFav(products)
                                          ? Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .unfavProduct(products)
                                          : Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .addToFav(products);
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
                                          products: products,
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
                                  products.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                products.size.length == 0
                                    ? Container()
                                    : AutoSizeText(
                                        products.size.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: grey),
                                      ),

                                products.description.length == 0
                                    ? Container()
                                    : AutoSizeText(
                                        products.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: grey),
                                      ),
                                products.composition == null ||
                                        products.composition.length == 0
                                    ? Container()
                                    : AutoSizeText(
                                        products.composition,
                                        maxLines: 5,
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
                                                 products.sellingPrice
                                                      .toString(),
                                              style: TextStyle(
                                                color: black,
                                              ),
                                            ),
                                           products.mrp ==
                                                   products.sellingPrice
                                                ? TextSpan()
                                                : TextSpan(
                                                    text: " ₹" +
                                                       products.mrp
                                                            .toString() +
                                                        "\t",
                                                    style: TextStyle(
                                                        color: grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough)),
                                            products.mrp ==
                                                   products.sellingPrice
                                                ? TextSpan()
                                                : TextSpan(
                                                    text:
                                                        "${(((products.mrp - products.sellingPrice) / products.mrp) * 100).toStringAsFixed(0)}% OFF",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Provider.of<ProductModel>(context,
                                                      listen: false)
                                                  .getQuanity(products.id) ==
                                              0
                                          ? Container()
                                          : InkWell(
                                              onTap: () async {
                                                Provider.of<ProductModel>(
                                                        context,
                                                        listen: false)
                                                    .removeItem(products);
                                                await addToCart(
                                                    products.id,
                                                    Provider.of<ProductModel>(
                                                            context,
                                                            listen: false)
                                                        .getQuanity(
                                                            products.id));
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                color: blue,
                                              ),
                                            ),
                                      Provider.of<ProductModel>(context,
                                                      listen: false)
                                                  .getQuanity(products.id) ==
                                              0
                                          ? Text(
                                              'ADD',
                                              style: TextStyle(color: blue),
                                            )
                                          : Text(
                                              Provider.of<ProductModel>(context,
                                                      listen: false)
                                                  .getQuanity(products.id)
                                                  .toString(),
                                              style: TextStyle(color: blue),
                                            ),
                                      InkWell(
                                        onTap: () async {
                                          Provider.of<ProductModel>(context,
                                                  listen: false)
                                              .addTaskInList(products);
                                          await addToCart(
                                              products.id,
                                              Provider.of<ProductModel>(context,
                                                      listen: false)
                                                  .getQuanity(products.id));
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
      },
    );
  }
}

class DescPro extends StatefulWidget {
  final ProductData products;
  DescPro({Key key, this.products}) : super(key: key);

  @override
  _DescProState createState() => _DescProState();
}

class _DescProState extends State<DescPro> {
  TextEditingController qty;
  @override
  void initState() {
    updateQty();
    super.initState();
  }

  updateQty() {
    qty = new TextEditingController(
        text: Provider.of<ProductModel>(context, listen: false)
            .getQuanity(widget.products.id)
            .toString());
  }

  inputQty() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: grey,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    return showDialog(
                      context: context,
                      builder: (ctx) => SimpleDialog(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              widget.products.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.products.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
               widget.products.offPercentage>0?  Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      widget.products.offPercentage.toStringAsFixed(1) +
                          " % OFF",
                      style: TextStyle(color: green),
                    )):Container()
              ]),
            ),

            SizedBox(height: 5),
            Center(
              child: Text(
                widget.products.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 5),
            widget.products.description.length == 0
                ? Container()
                : Center(
                    child: AutoSizeText(
                      widget.products.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: grey),
                    ),
                  ),

            SizedBox(height: 5),
            widget.products.size.length == 0
                ? Container()
                : AutoSizeText(
                    "Pack :  " + widget.products.size.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // style: TextStyle(color: grey),
                  ),

            SizedBox(height: 5),
            AutoSizeText(
              "MRP:  ₹" + widget.products.mrp.toString(),
              // maxLines: 2,
              overflow: TextOverflow.ellipsis,
              // style: TextStyle(color: grey),
            ),

            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "Best Price :  ₹" + widget.products.sellingPrice.toString(),
                  // maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  // style: TextStyle(color: grey),
                ),
                SizedBox(width: 5),
                // Container(
                //     height: 30,
                //     width: 70,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: Colors.blueAccent)),
                //     child: Center(
                //       child: TextFormField(
                //         controller: qty,
                //         decoration: InputDecoration(
                //             border: InputBorder.none,
                //             icon: Icon(Icons.edit)),
                //       ),
                //     )),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 30,
                  width: 90,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: blue)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Provider.of<ProductModel>(context, listen: false)
                                  .getQuanity(widget.products.id) ==
                              0
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                Provider.of<ProductModel>(context,
                                        listen: false)
                                    .removeItem(widget.products);
                                await addToCart(
                                    widget.products.id,
                                    Provider.of<ProductModel>(context,
                                            listen: false)
                                        .getQuanity(widget.products.id));
                                setState(() {
                                  updateQty();
                                });
                              },
                              child: Icon(
                                Icons.remove,
                                color: blue,
                              ),
                            ),
                      Provider.of<ProductModel>(context, listen: false)
                                  .getQuanity(widget.products.id) ==
                              0
                          ? Text(
                              'ADD',
                              style: TextStyle(color: blue),
                            )
                          : Container(
                              width: 30,
                              child: Center(
                                child: TextFormField(
                                  controller: qty,
                                  keyboardType: TextInputType.number,
                                  onChanged: (txt) async {
                                    Provider.of<ProductModel>(context,
                                            listen: false)
                                        .inputAdd(widget.products,
                                            int.parse(qty.text));

                                    await addToCart(
                              widget.products.id,
                              Provider.of<ProductModel>(context, listen: false)
                                  .getQuanity(widget.products.id));
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                      InkWell(
                        onTap: () async {
                          Provider.of<ProductModel>(context, listen: false)
                              .addTaskInList(widget.products);
                          await addToCart(
                              widget.products.id,
                              Provider.of<ProductModel>(context, listen: false)
                                  .getQuanity(widget.products.id));
                          setState(() {
                            updateQty();
                          });
                        },
                        child: Icon(
                          Icons.add,
                          color: blue,
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),

            SizedBox(height: 5),
            widget.products.composition == null ||
                    widget.products.composition.length == 0
                ? Container()
                : AutoSizeText(
                    "Salt Composition: \n" + widget.products.composition,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    // style: TextStyle(color: grey),
                  ),
              SizedBox(height: 15),
            widget.products.about == null ||
                    widget.products.about.length == 0
                ? Container()
                : AutoSizeText(
                    "About This Product: \n" + widget.products.about,
                    // maxLines: 10,
                    // overflow: TextOverflow.ellipsis,
                    // style: TextStyle(color: grey),
                  ),
            // Text(
            //   "₹" + products[index].sellingPrice.toString(),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            // RichText(
            //   maxLines: 1,
            //   textAlign: TextAlign.left,
            //   overflow: TextOverflow.ellipsis,
            //   softWrap: true,
            //   text: TextSpan(
            //     children: <TextSpan>[
            //       TextSpan(
            //         text: "₹" + widget.products.sellingPrice.toString(),
            //         style: TextStyle(
            //           color: black,
            //         ),
            //       ),
            //       TextSpan(
            //           text: " ₹" + widget.products.mrp.toString() + "\t",
            //           style: TextStyle(
            //               color: grey, decoration: TextDecoration.lineThrough)),
            //       TextSpan(
            //           text:
            //               "${widget.products.offPercentage.toStringAsFixed(0)}% OFF",
            //           style:
            //               TextStyle(color: green, fontWeight: FontWeight.bold)),
            //     ],
            //   ),
            // ),
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //         height: 30,
            //         width: 70,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             border: Border.all(color: Colors.blueAccent)),
            //         child: Center(
            //           child: TextFormField(
            //             controller: qty,
            //             decoration: InputDecoration(
            //                 border: InputBorder.none,
            //                 icon: Icon(Icons.edit)),
            //           ),
            //         )),
            //     SizedBox(
            //       width: 5,
            //     ),
            //     Container(
            //       height: 30,
            //       width: 75,
            //       decoration: BoxDecoration(
            //           color: white,
            //           borderRadius: BorderRadius.circular(8),
            //           border: Border.all(color: blue)),
            //       child: Center(
            //           child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: <Widget>[
            //           Provider.of<ProductModel>(context, listen: false)
            //                       .getQuanity(widget.products.id) ==
            //                   0
            //               ? Container()
            //               : InkWell(
            //                   onTap: () async {
            //                     Provider.of<ProductModel>(context,
            //                             listen: false)
            //                         .removeItem(widget.products);
            //                     await addToCart(
            //                         widget.products.id,
            //                         Provider.of<ProductModel>(context,
            //                                 listen: false)
            //                             .getQuanity(widget.products.id));
            //                     setState(() {
            //                       updateQty();
            //                     });
            //                   },
            //                   child: Icon(
            //                     Icons.remove,
            //                     color: blue,
            //                   ),
            //                 ),
            //           Provider.of<ProductModel>(context, listen: false)
            //                       .getQuanity(widget.products.id) ==
            //                   0
            //               ? Text(
            //                   'ADD',
            //                   style: TextStyle(color: blue),
            //                 )
            //               : Text(
            //                   Provider.of<ProductModel>(context, listen: false)
            //                       .getQuanity(widget.products.id)
            //                       .toString(),
            //                   style: TextStyle(color: blue),
            //                 ),
            //           InkWell(
            //             onTap: () async {
            //               Provider.of<ProductModel>(context, listen: false)
            //                   .addTaskInList(widget.products);
            //               await addToCart(
            //                   widget.products.id,
            //                   Provider.of<ProductModel>(context, listen: false)
            //                       .getQuanity(widget.products.id));
            //               setState(() {
            //                 updateQty();
            //               });
            //             },
            //             child: Icon(
            //               Icons.add,
            //               color: blue,
            //             ),
            //           ),
            //         ],
            //       )),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
