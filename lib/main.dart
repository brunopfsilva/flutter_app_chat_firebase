import 'package:flutter/material.dart';
import 'package:flutter_app_chat_firebase/MyHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {

//  Firestore.instance.collection("teste").document("teste").setData({"teste" : "teste"});

  runApp(MaterialApp(home: MyHomePage()));

}
