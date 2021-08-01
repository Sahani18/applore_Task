import 'package:firebase_database/firebase_database.dart';

class Products{
  String _id;
  String _name;
  String _desc;
  String _image;
  String _price;

  Products(this._name,this._desc,this._image,this._price);
  Products.withId(this._id,this._name,this._desc,this._image,this._price);

  String get id => this._id;
  String get name => this._name;
  String get desc => this._desc;
  String get image => this._image;
  String get price=>this._price;

  set name (String name) {
    this._name = name;
  }
  set desc (String desc) {
    this._desc = desc;
  }
  set image (String image) {
    this._image = image;
  }
  set price (String price) {
    this._price = price;
  }

  Products.fromSnapshot(DatabaseReference snapshot){
    this._id = snapshot.key;
    this._name = name;
    this._desc=desc;
    this._image=image;
    this._price=price;
  }

  Map<String,dynamic>toJson(){
    return {
      "name":_name,
      "desc":_desc,
      "image":_image,
      "price":_price
    };
  }
}