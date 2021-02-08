import 'package:grocery/models/user_model.dart';

import 'OrderModel.dart';

class Delivered {
  List<DeliveredOrders> data;

  Delivered({this.data});

  Delivered.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DeliveredOrders>();
      json['data'].forEach((v) {
        data.add(new DeliveredOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveredOrders {
  int id;
  dynamic orderId;
  dynamic userId;
  List<Products> products;
  dynamic amount;
  dynamic deliveryCharge;
  String deliveryAddress;
  dynamic packagerId;
  String packager;
  dynamic deliveryManId;
  String deliveryMan;
  String paymentStatus;
  String orderStatus;
  String deliveryDate;
  dynamic invoiceUrl;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  User user;

  DeliveredOrders(
      {this.id,
      this.orderId,
      this.userId,
      this.products,
      this.amount,
      this.deliveryCharge,
      this.deliveryAddress,
      this.packagerId,
      this.packager,
      this.deliveryManId,
      this.deliveryMan,
      this.paymentStatus,
      this.orderStatus,
      this.deliveryDate,
      this.invoiceUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user});

  DeliveredOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    amount = json['amount'];
    deliveryCharge = json['delivery_charge'];
    deliveryAddress = json['delivery_address'];
    packagerId = json['packager_id'];
    packager = json['packager'];
    deliveryManId = json['delivery_man_id'];
    deliveryMan = json['delivery_man'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    deliveryDate = json['delivery_date'];
    invoiceUrl = json['invoice_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['amount'] = this.amount;
    data['delivery_charge'] = this.deliveryCharge;
    data['delivery_address'] = this.deliveryAddress;
    data['packager_id'] = this.packagerId;
    data['packager'] = this.packager;
    data['delivery_man_id'] = this.deliveryManId;
    data['delivery_man'] = this.deliveryMan;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['delivery_date'] = this.deliveryDate;
    data['invoice_url'] = this.invoiceUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

