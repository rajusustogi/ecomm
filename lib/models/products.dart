import 'package:equatable/equatable.dart';

class ProductCategory {
  List<ProductCategoryData> data;

  ProductCategory({this.data});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductCategoryData>();
      json['data'].forEach((v) {
        data.add(new ProductCategoryData.fromJson(v));
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

class ProductCategoryData {
  int id;
  String title;
  String slug;
  String imageUrl;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  ProductCategoryData(
      {this.id,
      this.title,
      this.slug,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProductCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}



class Products {
  List<ProductData> data;

  Products({this.data});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductData>();
      json['data'].forEach((v) {
        data.add(new ProductData.fromJson(v));
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

class ProductData extends Equatable {
  int id;
  String title;
  String slug;
  String imageUrl;
  String description;
  String composition;
  String size;
  dynamic categoryId;
  dynamic mrp;
  dynamic about;
  dynamic offPercentage;
  dynamic offAmount;
  dynamic sellingPrice;
  bool isTrending;
  bool isActive;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  ProductData(
      {this.id,
      this.title,
      this.slug,
      this.about,
      this.imageUrl,
      this.composition,
      this.description,
      this.categoryId,
      this.size,
      this.mrp,
      this.offPercentage,
      this.offAmount,
      this.sellingPrice,
      this.isTrending,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    imageUrl = json['image_url'];
    composition = json['composition'];
    description = json['manufacturer'];
    categoryId = json['category_id'];
    mrp = json['mrp'];
    about = json['description'];
    size=json['pack_size'];
    offPercentage = json['off_percentage'];
    offAmount = json['off_amount'];
    sellingPrice = json['selling_price'];
    isTrending = json['is_trending'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    data['manufacturer'] = this.description;
    data['category_id'] = this.categoryId;
    data['mrp'] = this.mrp;
    data['composition'] = this.composition;
    data['off_percentage'] = this.offPercentage;
    data['off_amount'] = this.offAmount;
    data['selling_price'] = this.sellingPrice;
    data['is_trending'] = this.isTrending;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }

  @override
  List<Object> get props => [id];
}
