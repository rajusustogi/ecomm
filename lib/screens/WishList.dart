import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:provider/provider.dart';
import 'package:grocery/screens/category.dart';

class WishList extends StatefulWidget {
  WishList({Key key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  bool fav = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ProductModel>(builder: (context, pro, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: MediaQuery.of(context).size.height -
              (AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top),
          child: pro.favproduct.length == 0
              ? Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Image.asset(
                      'images/emptycart.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: pro.favproduct.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                        color: grey,
                        indent: 10,
                      ),
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
                                    pro.getFav()[index].imageUrl,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: white),
                                      child: IconButton(
                                          enableFeedback: true,
                                          icon: Provider.of<ProductModel>(
                                                      context,
                                                      listen: true)
                                                  .isFav(pro.getFav()[index])
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
                                                    .isFav(pro.getFav()[index])
                                                ? Provider.of<ProductModel>(
                                                        context,
                                                        listen: false)
                                                    .unfavProduct(
                                                        pro.getFav()[index])
                                                : Provider.of<ProductModel>(
                                                        context,
                                                        listen: false)
                                                    .addToFav(
                                                        pro.getFav()[index]);
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
                                                products: pro.getFav()[index],
                                              )
                                            ],
                                          ));
                                },
                                child: Container(
                                  // color: grey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pro.getFav()[index].title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      pro.getFav()[index].size.length == 0
                                          ? Container()
                                          : AutoSizeText(
                                              pro
                                                  .getFav()[index]
                                                  .size
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: grey),
                                            ),

                                      pro.getFav()[index].description.length ==
                                              0
                                          ? Container()
                                          : AutoSizeText(
                                              pro.getFav()[index].description,
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
                                                  pro
                                                      .getFav()[index]
                                                      .sellingPrice
                                                      .toString(),
                                              style: TextStyle(
                                                color: black,
                                              ),
                                            ),
                                            pro.getFav()[index].mrp ==
                                                    pro
                                                        .getFav()[index]
                                                        .sellingPrice
                                                ? TextSpan()
                                                : TextSpan(
                                                    text: " ₹" +
                                                        pro
                                                            .getFav()[index]
                                                            .mrp
                                                            .toString() +
                                                        "\t",
                                                    style: TextStyle(
                                                        color: grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough)),
                                            pro.getFav()[index].mrp ==
                                                    pro
                                                        .getFav()[index]
                                                        .sellingPrice
                                                ? TextSpan()
                                                : TextSpan(
                                                    text:
                                                        "${(((pro.getFav()[index].mrp - pro.getFav()[index].sellingPrice) / pro.getFav()[index].mrp) * 100).toStringAsFixed(0)}% OFF",
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(color: blue)),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Provider.of<ProductModel>(context,
                                                            listen: false)
                                                        .getQuanity(pro
                                                            .getFav()[index]
                                                            .id) ==
                                                    0
                                                ? Container()
                                                : InkWell(
                                                    onTap: () async {
                                                      Provider.of<ProductModel>(
                                                              context,
                                                              listen: false)
                                                          .removeItem(pro
                                                              .getFav()[index]);
                                                      await addToCart(
                                                          pro
                                                              .getFav()[index]
                                                              .id,
                                                          Provider.of<ProductModel>(
                                                                  context,
                                                                  listen: false)
                                                              .getQuanity(pro
                                                                  .getFav()[
                                                                      index]
                                                                  .id));
                                                    },
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: blue,
                                                    ),
                                                  ),
                                            Provider.of<ProductModel>(context,
                                                            listen: false)
                                                        .getQuanity(pro
                                                            .getFav()[index]
                                                            .id) ==
                                                    0
                                                ? Text(
                                                    'ADD',
                                                    style:
                                                        TextStyle(color: blue),
                                                  )
                                                : Text(
                                                    Provider.of<ProductModel>(
                                                            context,
                                                            listen: false)
                                                        .getQuanity(pro
                                                            .getFav()[index]
                                                            .id)
                                                        .toString(),
                                                    style:
                                                        TextStyle(color: blue),
                                                  ),
                                            InkWell(
                                              onTap: () async {
                                                Provider.of<ProductModel>(
                                                        context,
                                                        listen: false)
                                                    .addTaskInList(
                                                        pro.getFav()[index]);
                                                await addToCart(
                                                    pro.getFav()[index].id,
                                                    Provider.of<ProductModel>(
                                                            context,
                                                            listen: false)
                                                        .getQuanity(pro
                                                            .getFav()[index]
                                                            .id));
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
                  }),
        ),
      );
    }));
  }
}
