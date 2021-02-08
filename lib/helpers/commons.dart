import 'package:flutter/material.dart';

const Color red = Colors.red;
const Color green = Colors.green;
const Color black = Colors.black;
const Color blue = Colors.blue;
const Color amber = Colors.amber;
const Color white = Colors.white;
const Color purple = Colors.purple;
const Color pink = Colors.pink;
const Color grey = Colors.grey;
Color pcolor = Colors.blue;


const URL = "http://ec2-15-207-22-80.ap-south-1.compute.amazonaws.com:3000";

// End Points: =>

//USER
const LOGIN= URL+"/login";// (post api) (body: {emailOrPhone: string, password: string}),
const ME= URL+"/me";// (get api to view my details)(h eaders: auth toke)
const UPDATEMYPROFILE= URL+"/me";// (put api to update details)(auth token) (body: {name, email, mobile_no, alternate_no, password, address, landmark, state, pincode, latitude, longitude})
const DELETEME= URL+"/me" ;//(delete api to delete my profile) (auth token)

//PRODUCT
const PRODUCTCATEGORY = URL+"/productCategories" ;//(get api to view product categories) (auth token)
const PRODUCTS= URL+"/products/" ;//(get api to view products of a category) (auth token)
const SEARCHPRODUCT= URL+"/products?query=" ;//(get api to search product) (auth token) (isme agar query nhi bhejoge to saare products show ho jaayenge)
const TRENDING= URL+"/trending-products" ;//(get api to view rending products) (auth token)

//CART
const MYCART= URL+"/my-cart";// (get api to view my cart) (auth token)
const ADDTOCART= URL+"/add-to-cart" ;//(put api to add products)( auth token) (body: {product_id, no_of_units})
const EMPTYCART= URL+"/empty-cart" ;//(delete api to empty caart) (auth token)

//FAVORITES
const ADDTOFAV= URL+"/add-to-favorites/";// (put api) (token)
const REMOVEFAV= URL+"/remove-favorites/" ;//(put api) (token)
const EMPTYFAV= URL+"/empty-favorites" ;//(put api) (token)
const GETFAV= URL+"/favorites";// (get api) (token)


//ORDER
const CREATEORDER= URL+"/orders";// (post api) (token) (body: {cart_id, amount :string(compulasry); latitude, longitude: string (not necessary)})
const GETORDERS= URL+"/orders";// (get api) (token) (view current orders)
const HISTORY= URL+"/history" ;//(get api) (token) (view previous orders)
const UPDATEORDER= URL+"/orders/(+orderId)" ;//(put api to update order) (token) (body: {payment_status, order_status})
