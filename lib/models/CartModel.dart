import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/models/products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyCart {
  Data data;
  List<ProductData> extra;

  MyCart({this.data, this.extra});

  MyCart.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['extra'] != null) {
      extra = new List<ProductData>();
      json['extra'].forEach((v) {
        extra.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.extra != null) {
      data['extra'] = this.extra.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  dynamic userId;
  // List<Products> products;
  dynamic amount;
  dynamic deliveryCharge;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  Data(
      {this.id,
      this.userId,
      // this.products,
      this.amount,
      this.deliveryCharge,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    // if (json['products'] != null) {
    //   products = new List<Products>();
    //   json['products'].forEach((v) {
    //     products.add(new Products.fromJson(v));
    //   });
    // }
    amount = json['amount'];
    deliveryCharge = json['delivery_charge'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    // if (this.products != null) {
    //   data['products'] = this.products.map((v) => v.toJson()).toList();
    // }
    data['amount'] = this.amount;
    data['delivery_charge'] = this.deliveryCharge;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

// class Products {
//   int productId;
//   int noOfUnits;
//   int rate;
//   String title;
//   String imageUrl;
//   int mrp;

//   Products(
//       {this.productId,
//       this.noOfUnits,
//       this.rate,
//       this.title,
//       this.imageUrl,
//       this.mrp});

//   Products.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     noOfUnits = json['no_of_units'];
//     rate = json['rate'];
//     title = json['title'];
//     imageUrl = json['image_url'];
//     mrp = json['mrp'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['no_of_units'] = this.noOfUnits;
//     data['rate'] = this.rate;
//     data['title'] = this.title;
//     data['image_url'] = this.imageUrl;
//     data['mrp'] = this.mrp;
//     return data;
//   }
// }

class CartProducts extends Equatable {
  int productId;
  int noOfUnits;
  dynamic baseRate;
  dynamic rate;
  String title;
  String imageUrl;

  CartProducts(
      {this.productId,
      this.noOfUnits,
      this.baseRate,
      this.rate,
      this.title,
      this.imageUrl});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    noOfUnits = json['no_of_units'];
    baseRate = json['base_rate'];
    rate = json['rate'];
    title = json['title'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['no_of_units'] = this.noOfUnits;
    data['base_rate'] = this.baseRate;
    data['rate'] = this.rate;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    return data;
  }

  @override
  List<Object> get props => [productId];
}

class ProductModel extends ChangeNotifier {
  List<ProductData> productlist = [];
  Set<ProductData> favproduct = Set();
  
  List<ProductData> getProductList() {
    print(productlist.toSet().toList().length.toString() + "hello");
    return productlist.toSet().toList();
  }

  List<ProductData> getFav() {
    print(productlist.toSet().toList().length.toString() + "hello");
    return favproduct.toList();
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      var response = await http.get(MYCART, headers: {"Authorization": token});
      var fav = await http.get(GETFAV, headers: {"Authorization": token});
  print(response.body);
      MyCart cartItem = MyCart.fromJson(json.decode(response.body));
      Products favpro = Products.fromJson(json.decode(fav.body));

      productlist.clear();
      favproduct.clear();
      for (int i = 0; i < favpro.data.length; i++) {
        favproduct.add(favpro.data[i]);
        notifyListeners();
      }
      for (int i = 0; i < cartItem.extra.length; i++) {
        productlist.add(cartItem.extra[i]);
        notifyListeners();
      }
    } else {
      print('No Token');
    }
  }

  deleteCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    productlist.clear();
    var response =
        await http.delete(EMPTYCART, headers: {"Authorization": token});
        print(response.body);
    notifyListeners();
  }

  removeItem(ProductData product) {
    productlist.remove(product);
    print('removed len' + productlist.length.toString());
    notifyListeners();
  }

  unfavProduct(ProductData product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    favproduct.removeWhere((p) => p == product);
    notifyListeners();
    var response = await http.put(REMOVEFAV + product.id.toString(),
        headers: {"Authorization": token});
    print(response.body);
  }

  void removeProduct(ProductData product) {
    productlist.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  int getQuanity(int id) => productlist.where((p) => id == p.id).length;
  bool isFav(ProductData product) => favproduct.contains(product);
  clearList() {
    productlist.clear();
    notifyListeners();
  }

  dynamic get tprice => totalprice();
  dynamic get discount => discountamount();
  dynamic get subtotal => subtotalamount();
  dynamic totalprice() {
    dynamic tprice = 0;
    if (productlist.length == 0) {
      tprice = 0;
    } else {
      for (int i = 0; i < productlist.length; i++) {
        tprice += productlist[i].sellingPrice;
      }
    }

    return tprice;
  }

  dynamic subtotalamount() {
    dynamic subtotal = 0;
    if (productlist.length == 0) {
      subtotal = 0;
    } else {
      for (int i = 0; i < productlist.length; i++) {
        subtotal += productlist[i].mrp;
      }
    }
    return subtotal;
  }

  dynamic discountamount() {
    dynamic discount = 0;
    if (productlist.length == 0) {
      discount = 0;
    } else {
      for (int i = 0; i < productlist.length; i++) {
        discount += productlist[i].offAmount;
      }
    }
    return discount;
  }

  addTaskInList(ProductData pro) {
    productlist.add(pro);
    notifyListeners();
  }

  inputAdd(ProductData pro,qty){
    productlist.removeWhere((element) => element.id==pro.id);
    for(int i = 0 ;i<qty;i++){
      productlist.add(pro);
    }
    notifyListeners();
  }

  addToFav(ProductData pro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    favproduct.add(pro);
    notifyListeners();
    var response = await http
        .put(ADDTOFAV + pro.id.toString(), headers: {"Authorization": token});
    print(response.body);
  }
}
