import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/products.dart';
import 'package:grocery/provider/addcart.dart';
import 'package:grocery/screens/home.dart';
import 'package:grocery/widgets/address.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  Checkout({Key key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  getcart() async {
    MyCart c = await myCart();
    print(c.data.deliveryCharge);
    setState(() {
      deliveryCharge = c.data.deliveryCharge;
    });
  }

  @override
  void initState() {
    super.initState();
    getcart();
  }

  dynamic deliveryCharge = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  changeScreenRepacement(context, HomePage());
                },
                icon: Icon(Icons.arrow_back),
                color: Theme.of(context).hintColor,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Cart",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .merge(TextStyle(letterSpacing: 1.3)),
              ),
            ),
            body: Consumer<ProductModel>(builder: (context, pro, child) {
              return pro.getProductList().length == 0
                  ? Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Image.asset(
                          'images/emptycart.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 150),
                          padding: EdgeInsets.only(bottom: 15),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      Icons.shopping_cart,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      "Shoppin cart",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    subtitle: Text(
                                      "Checkout",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: pro.getProductList().length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 15);
                                  },
                                  itemBuilder: (context, index) {
                                    return CartItemWidget(
                                      cart: pro.getProductList()[index],
                                      onDismissed: () async {
                                        dynamic product =
                                            pro.getProductList()[index];
                                        pro.removeProduct(product);
                                        await addToCart(product.id, "0");
                                      },
                                      increment: () async {
                                        int id = pro.getProductList()[index].id;
                                        pro.addTaskInList(
                                            pro.getProductList()[index]);
                                        await addToCart(id, pro.getQuanity(id));
                                      },
                                      decrement: () async {
                                        int id = pro.getProductList()[index].id;
                                        pro.removeItem(
                                            pro.getProductList()[index]);
                                        await addToCart(id, pro.getQuanity(id));
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.15),
                                      offset: Offset(0, -2),
                                      blurRadius: 5.0)
                                ]),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Subtotal",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                      Text(
                                        "₹" + pro.subtotal.toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Delivery Fees",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      Text(
                                        '+₹$deliveryCharge',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Discount',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      Text(
                                        "-₹" + pro.discount.toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        "₹" +
                                            (pro.tprice + deliveryCharge)
                                                .toStringAsFixed(1),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Stack(
                                    fit: StackFit.loose,
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: FlatButton(
                                          onPressed: () => changeScreen(
                                              context,
                                              Address(
                                                  deliveryCharge:
                                                      deliveryCharge)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: green,
                                          shape: StadiumBorder(),
                                          child: Text(
                                            "checkout",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
            })));
  }
}

class CartItemWidget extends StatefulWidget {
  final ProductData cart;
  final VoidCallback increment;
  final VoidCallback decrement;
  final VoidCallback onDismissed;

  CartItemWidget(
      {Key key, this.cart, this.increment, this.decrement, this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id.toString()),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  widget.cart.imageUrl,
                  height: 90,
                  width: 90,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.cart.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            widget.cart.size,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            widget.cart.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "Qty " +
                                Provider.of<ProductModel>(context,
                                        listen: false)
                                    .getQuanity(widget.cart.id)
                                    .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            widget.increment();
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        Text(
                          "₹" + widget.cart.sellingPrice.toStringAsFixed(1),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.decrement();
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
