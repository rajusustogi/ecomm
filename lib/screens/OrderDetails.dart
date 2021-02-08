import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/OrderModel.dart';

class OrderDetails extends StatefulWidget {
  final dynamic order;
  final Color color;
  final String type;
  const OrderDetails({Key key, this.order, this.color, this.type}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<Products> list = [];
  @override
  void initState() {
    list = widget.type=='pending'? widget.order.pendingProducts + widget.order.products :widget.order.products;
    super.initState();
  }

  getAmount(List<Products> pro) {
    dynamic total = 0;
    for (var i in pro) {
      total = total + i.noOfUnits * i.rate;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body:widget.type=='pending'? DefaultTabController(
        length: 3,
        child: Container(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'Order Id: ${widget.order.orderId}\nDelivery Date: ${widget.order.expectedDate}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    color: black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                TabBar(
                  labelColor: black,
                  tabs: [
                    Tab(
                      child: Stack(
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
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green,
                                        offset: Offset(1, 1),
                                        blurRadius: 2)
                                  ]),
                              child: Center(
                                child: Text(
                                  widget.order.products.length.toString(),
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Stack(
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
                                  color: green,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green,
                                        offset: Offset(1, 1),
                                        blurRadius: 2)
                                  ]),
                              child: Center(
                                child: Text(
                                  widget.order.completeProducts.length
                                      .toString(),
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
                    Tab(
                      child: Stack(
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
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.red,
                                        offset: Offset(1, 1),
                                        blurRadius: 2)
                                  ]),
                              child: Center(
                                child: Text(
                                  widget.order.pendingProducts.length
                                      .toString(),
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
                Container(
                  height: size.height * 0.7,
                  child: TabBarView(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.7,
                        child: ListView.builder(
                          itemCount: widget.order.products.length,
                          itemBuilder: (BuildContext context, int index) {
                            String code = widget.order.products[index].noOfUnits
                                .toString();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5),
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          child: Image.network(
                                            widget.order.products[index]
                                                .imageUrl,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 120,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            .5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              maxLines: 5,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: widget
                                                            .order
                                                            .products[index]
                                                            .title +
                                                        "\n",
                                                    style: TextStyle(
                                                      color: black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.order.products[index].manufacturer}\n",
                                                    style: TextStyle(
                                                      color: grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.order.products[index].packSize}\n",
                                                    style: TextStyle(
                                                      color: grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "₹" +
                                                        widget
                                                            .order
                                                            .products[index]
                                                            .rate
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " ₹" +
                                                          widget
                                                              .order
                                                              .products[index]
                                                              .mrp
                                                              .toString() +
                                                          "\t",
                                                      style: TextStyle(
                                                          color: grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.order.products
                                                      .contains(widget.order
                                                          .products[index]) ==
                                                  true
                                              ? green
                                              : amber),
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.order.products[index].noOfUnits
                                            .toString(),
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: size.height * 0.7,
                        child: ListView.builder(
                          itemCount: widget.order.completeProducts.length,
                          itemBuilder: (BuildContext context, int index) {
                            String code = widget
                                .order.completeProducts[index].noOfUnits
                                .toString();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5),
                              child: Container(
                                height: 100,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: widget.color,
                                //         blurRadius: 5.0,
                                //       ),
                                //     ],
                                //     color: white),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 80,
                                          child: Image.network(
                                            widget
                                                .order
                                                .completeProducts[index]
                                                .imageUrl,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 140,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            .5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              maxLines: 5,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: widget
                                                            .order
                                                            .completeProducts[
                                                                index]
                                                            .title +
                                                        "\n",
                                                    style: TextStyle(
                                                      color: black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.order.completeProducts[index].manufacturer}\n",
                                                    style: TextStyle(
                                                      color: grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.order.completeProducts[index].packSize}\n",
                                                    style: TextStyle(
                                                      color: grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "₹" +
                                                        widget
                                                            .order
                                                            .completeProducts[
                                                                index]
                                                            .rate
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " ₹" +
                                                          widget
                                                              .order
                                                              .completeProducts[
                                                                  index]
                                                              .mrp
                                                              .toString() +
                                                          "\t",
                                                      style: TextStyle(
                                                          color: grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.order.completeProducts
                                                      .contains(widget.order
                                                              .completeProducts[
                                                          index]) ==
                                                  true
                                              ? green
                                              : amber),
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.order.completeProducts[index]
                                            .noOfUnits
                                            .toString(),
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: size.height * 0.7,
                        child: ListView.builder(
                          itemCount: widget.order.pendingProducts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5),
                              child: Container(
                                height: 80,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: widget.color,
                                //         blurRadius: 5.0,
                                //       ),
                                //     ],
                                //     color: white),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          child: Image.network(
                                            widget.order.pendingProducts[index]
                                                .imageUrl,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              maxLines: 5,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: widget
                                                            .order
                                                            .pendingProducts[
                                                                index]
                                                            .title +
                                                        "\n",
                                                    style: TextStyle(
                                                      color: black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.order.pendingProducts[index].manufacturer}\n",
                                                    style: TextStyle(
                                                      color: grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.order.pendingProducts[index].packSize}\n",
                                                    style: TextStyle(
                                                      color: grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "₹" +
                                                        widget
                                                            .order
                                                            .pendingProducts[
                                                                index]
                                                            .rate
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " ₹" +
                                                          widget
                                                              .order
                                                              .pendingProducts[
                                                                  index]
                                                              .mrp
                                                              .toString() +
                                                          "\t",
                                                      style: TextStyle(
                                                          color: grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.order.products.contains(
                                                      widget.order
                                                              .pendingProducts[
                                                          index]) ==
                                                  true
                                              ? green
                                              : amber),
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.order.pendingProducts[index]
                                            .noOfUnits
                                            .toString(),
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ): ListView.separated(
        separatorBuilder: (contex, index) {
          return SizedBox(
            height: 10,
          );
        },
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                decoration: BoxDecoration(color: white, boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: widget.color,
                      offset: Offset(1, 1),
                      spreadRadius: 2)
                ]),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'OrderId: ${widget.order.orderId}\nDelivery Date: ${widget.order.deliveryDate}',
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                        widget.order.orderStatus == 'pending'
                            ? Text('OTP: ${widget.order.deliveryCode}',
                                style: TextStyle(
                                    color: blue, fontWeight: FontWeight.bold))
                            : Text('')
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(right: 5),
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
                                        color: widget.color,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: widget.color,
                                              offset: Offset(1, 1),
                                              blurRadius: 2)
                                        ]),
                                    child: Center(
                                      child: Text(
                                        widget.order.products.length
                                            .toString(),
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
                            Text("₹" +
                                getAmount(widget.order.products)
                                    .toString())
                          ],
                        ),
                      ),
                trailing:      widget.order.orderStatus ==
                                                'delivered'
                                            ? Text(
                                                '${widget.order.deliveryMan}\n${widget.order.deliveryCharge}')
                                            : Text('')
                    )
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Image.network(
                            list[index - 1].imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RichText(
                            maxLines: 5,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: list[index - 1].title + "\n",
                                  style: TextStyle(
                                    color: black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${list[index - 1].manufacturer}\n",
                                  style: TextStyle(
                                    color: grey,
                                  ),
                                ),
                                TextSpan(
                                  text: "${list[index - 1].packSize}\n",
                                  style: TextStyle(
                                    color: grey,
                                  ),
                                ),
                                TextSpan(
                                  text: "₹" + list[index - 1].rate.toString(),
                                  style: TextStyle(
                                    color: black,
                                  ),
                                ),
                                TextSpan(
                                    text: " ₹" +
                                        list[index - 1].mrp.toString() +
                                        "\t",
                                    style: TextStyle(
                                        color: grey,
                                        decoration:
                                            TextDecoration.lineThrough)),
                                // TextSpan(
                                //     text:
                                //         "${ widget.order.products[index].offPercentage.toStringAsFixed(0)}% OFF",
                                //     style: TextStyle(
                                //         color: green,
                                //         fontWeight:
                                //             FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              widget.color),
                      alignment: Alignment.center,
                      child: Text(
                        list[index - 1].noOfUnits.toString(),
                        style: TextStyle(
                            color: white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
