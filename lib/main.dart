import 'package:flutter/material.dart';
import 'package:flutter_app_chat_firebase/MyHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {


    //Salva os dados
//  Firestore.instance.collection("teste").document("teste").setData({"teste" : "teste"});
    //Pega os dados
//    DocumentSnapshot snapshot = await Firestore.instance.collection("teste").document("teste").get();
  //  print(snapshot.data);


  //pega todos os dados
  /*QuerySnapshot snapshot = await Firestore.instance.collection("teste").getDocuments();

  for(DocumentSnapshot snap in snapshot.documents){

    print(snap);

  }
  */


  //lista em tempo real os dados
  /*
  Firestore.instance.collection("teste").snapshots().listen((snapshot){


    for(DocumentSnapshot doc in snapshot.documents){
      print(doc.data);
    }


  });

  */

  runApp(MaterialApp(home: MyHomePage()));

}
