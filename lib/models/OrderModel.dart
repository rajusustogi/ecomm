import 'package:equatable/equatable.dart';

class MyOrders {
  List<OrderData> data;

  MyOrders({this.data});

  MyOrders.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<OrderData>();
      json['data'].forEach((v) {
        data.add(new OrderData.fromJson(v));
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

class OrderData {
  int id;
  dynamic orderId;
  dynamic userId;
  dynamic cartId;
  List<Products> products;
  dynamic amount;
  dynamic deliveryCharge;
  String deliveryAddress;
  dynamic employeeId;
  String deliveryCode;
  String paymentStatus;
  String orderStatus;
  List<Products> pendingProducts;
  List<Products> completeProducts;
  String expectedDate;
  dynamic invoiceUrl;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  OrderData({
    this.id,
    this.orderId,
    this.userId,
    this.cartId,
    this.products,
    this.amount,
    this.deliveryCharge,
    this.deliveryAddress,
    this.employeeId,
    this.deliveryCode,
    this.paymentStatus,
    this.orderStatus,
    this.pendingProducts,
    this.expectedDate,
    this.invoiceUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    cartId = json['cart_id'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    amount = json['amount'];
    deliveryCharge = json['delivery_charge'];
    deliveryAddress = json['delivery_address'];
    employeeId = json['employee_id'];
    deliveryCode = json['delivery_code'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    if (json['pending_products'] != null) {
      completeProducts = new List<Products>();
      json['pending_products'].forEach((v) {
        completeProducts.add(new Products.fromJson(v));
      });
    }
    if (json['completed_products'] != null) {
      pendingProducts = new List<Products>();
      json['completed_products'].forEach((v) {
        pendingProducts.add(new Products.fromJson(v));
      });
    }
    expectedDate = json['expected_date'];
    invoiceUrl = json['invoice_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['cart_id'] = this.cartId;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['amount'] = this.amount;
    data['delivery_charge'] = this.deliveryCharge;
    data['delivery_address'] = this.deliveryAddress;
    data['employee_id'] = this.employeeId;
    data['delivery_code'] = this.deliveryCode;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    if (this.pendingProducts != null) {
      data['pending_products'] =
          this.pendingProducts.map((v) => v.toJson()).toList();
    }
    data['expected_date'] = this.expectedDate;
    data['invoice_url'] = this.invoiceUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;

    return data;
  }
}

class Products extends Equatable {
  dynamic productId;
  int noOfUnits;
  String manufacturer;
  dynamic rate;
  String packSize;
  String title;
  String imageUrl;
  dynamic mrp;

  Products(
      {this.productId,
      this.noOfUnits,
      this.manufacturer,
      this.rate,
      this.packSize,
      this.title,
      this.imageUrl,
      this.mrp});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    noOfUnits = json['no_of_units'];
    manufacturer = json['manufacturer'];
    rate = json['rate'];
    packSize = json['pack_size'];
    title = json['title'];
    imageUrl = json['image_url'];
    mrp = json['mrp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['no_of_units'] = this.noOfUnits;
    data['manufacturer'] = this.manufacturer;
    data['rate'] = this.rate;
    data['pack_size'] = this.packSize;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['mrp'] = this.mrp;
    return data;
  }

  @override
  List<Object> get props => [productId];
}
