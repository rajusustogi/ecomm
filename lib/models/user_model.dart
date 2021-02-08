class User {
  String token;
  UserData data;

  User({this.token, this.data});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class UserData {
  int id;
  String name;
  String email;
  String mobileNo;
  String alternateNo;
  String password;
  String address;
  dynamic paddress;
  String landmark;
  String state;
  String pincode;
  int deliveryCharge;
  dynamic latitude;
  dynamic longitude;
  bool isActive;
  String createdAt;
  String updatedAt;

  UserData(
      {this.id,
      this.name,
      this.email,
      this.mobileNo,
      this.alternateNo,
      this.password,
      this.address,
      this.paddress,
      this.landmark,
      this.state,
      this.pincode,
      this.deliveryCharge,
      this.latitude,
      this.longitude,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    alternateNo = json['alternate_no'];
    password = json['password'];
    address = json['address'];
    paddress = json['permanent_address'];
    landmark = json['landmark'];
    state = json['state'];
    pincode = json['pincode'];
    deliveryCharge = json['delivery_charge'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['alternate_no'] = this.alternateNo;
    data['password'] = this.password;
    data['address'] = this.address;
    data['permanent_address']=this.paddress;
    data['landmark'] = this.landmark;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['delivery_charge'] = this.deliveryCharge;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
