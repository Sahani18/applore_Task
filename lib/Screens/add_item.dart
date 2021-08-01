import 'package:applore_techno/Modals/product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Modals/product.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String _name = '';
  String _desc = '';
  String _image = "empty";
  String _price = '';
  final ImagePicker picker = ImagePicker();

  saveContact(BuildContext context) async {
    if (_name.isNotEmpty &&
        _desc.isNotEmpty &&
        _image.isNotEmpty &&
        _price.isNotEmpty) {
      Products products =
          Products(this._name, this._desc, this._image, this._price);
      await _databaseReference.push().set(products.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Field Required'),
              content: Text('All fields are required'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    }
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  // showFileSize(int original,int compress) {
  //   showDialog(
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Compressed Image'),
  //           content: Column(
  //             children: [
  //               Text('Original size : $original'),
  //               SizedBox(height: 10,),
  //               Text('Compressed size : $compress'),
  //
  //             ],
  //           ),
  //           actions: [
  //             ElevatedButton(
  //                 onPressed:(){
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('OK')),
  //             ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Cancel')),
  //           ],
  //         );
  //       });
  // }

  Future pickImage() async {
    XFile file = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    String filename = basename(file.path);

    compressImage(file);
    // uploadImage(file, filename);
  }

  void compressImage(XFile file) async {
    final filePath = file.path;
    int data= await file.length();

    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 1000, minHeight: 1000, quality: 70);
    var original= compressedImage.lengthSync();
    print("Compressed ***************** $original");
    print(original);
    print("Original ***************** $data");
    print(data);
   // var compress= file.length();
  //showFileSize(data,original);
    uploadImage(compressedImage, filePath);

  }

  void uploadImage(file, fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    storageReference.putFile(file).whenComplete(() async {
      var downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        _image = downloadUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  this.pickImage();
                },
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      //shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image == "empty"
                              ? AssetImage("assets/logo.png")
                              : NetworkImage(_image)),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                onChanged: (value) {
                  _name = value;
                },
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Product Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                onChanged: (value) {
                  _desc = value;
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _price = value;
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            ElevatedButton(
                onPressed: () {
                  saveContact(context);
                },
                child: Text(
                  'Save ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
