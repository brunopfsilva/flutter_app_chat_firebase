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

 /* Firestore.instance.collection("teste").snapshots().listen((snapshot){


    for(DocumentSnapshot doc in snapshot.documents){
      print(doc.data);
    }

    if(snapshot.documents.length.toInt() >3){

    }



  });
*/


 runApp(myHome());


}

class myHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


   final ThemeData KIOstheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
   );

   final ThemeData Defaultheme = ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orange[400],
   );


    return MaterialApp(
     title: "Chat App",
     debugShowCheckedModeBanner: false,
     theme: Theme.of(context).platform == TargetPlatform.iOS ?
     KIOstheme : Defaultheme,
     home: ChatScreen(),
    );
  }



}


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat Area"),
          centerTitle: true,
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0 : 4.0,
        ),
        body: Column(),
      ),

    );
  }
}

