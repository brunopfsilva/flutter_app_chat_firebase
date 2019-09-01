import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      primarySwatch: Colors.red,
      accentColor: Colors.orange,
    );

    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? KIOstheme
          : Defaultheme,
      home: ChatScreen(),
    );
  }

}

final googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;


Future<Null>_ensureLoggedIn() async {

  GoogleSignInAccount user = googleSignIn.currentUser;

  if(user == null)
    user = await googleSignIn.signInSilently();
  if(user == null)
    user = await googleSignIn.signIn();
  if(await _auth.currentUser() == null){
    GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: credentials.accessToken,
      idToken: credentials.idToken,
    );

    //usuario firebase obtido
   // FirebaseUser firebaseUser =  (await _auth.signInWithCredential(credential)) as FirebaseUser;
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    print(user.displayName);



    /*FirebaseUser user = await _auth.signInWithGoogle(
          accessToken: credentials.accessToken, idToken: credentials.idToken); */


  }




}



_handleSubmitted(String text) async{

  await _ensureLoggedIn();
  _sendMenssage(text: text);

}

void _sendMenssage({String text,String imgUrl}) {

  //adiciona novo documento no firebase
  Firestore.instance.collection("mensagem").add(
    {

      "text": text,
      "imgUrl": imgUrl,
      "senderName": googleSignIn.currentUser.displayName,
      "senderPhotoUrl": googleSignIn.currentUser.photoUrl,

    }
  );

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
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("mensagem").snapshots(),
                  builder: (context,snapshot){
                    //lista declarada acima para que funcione
                    List r = snapshot.data.documents.reversed.toList();
                    switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return ListView.builder(
                        reverse: true,
                        itemCount: r.length,
                        itemBuilder: (context,index){
                          return ChatMessage(r[index].data);
                        },
                      );
                  }
              }),
            ),
            Divider(height: 1.0,),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: TextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposer = false;
  final _textController = TextEditingController();

  void _reset(){

    setState(() {
      _textController.clear();
      _isComposer = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
              )
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child:
                  IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (String text) {
                  setState(() {
                    _isComposer = text.length > 0;
                  });
                },
                onSubmitted: (text){
                  _handleSubmitted(text);
                  _reset();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text("Enviar"),
                      onPressed: _isComposer ? () {
                        _handleSubmitted(_textController.text);
                        _reset();
                      } : null,
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposer ? () {
                        _handleSubmitted(_textController.text);
                        _reset();
                      } : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {

  Map<String,dynamic>data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  data["senderPhotoUrl"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["senderName"],
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data["imgUrl"] != null ? Image.network(data["imgUrl"],width: 201) :
                  Text(data["text"]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
