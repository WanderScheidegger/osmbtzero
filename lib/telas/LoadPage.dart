import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadPage extends StatefulWidget {
  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {


  _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    auth.currentUser().then((onValue){
      //busca a equipe do usuário logado
      Firestore.instance
          .collection('usuarios')
          .document(onValue.uid)
          .get()
          .then((snapshot) {

        //salva a equipe do usuario em arquivo
        var equipe = snapshot.data['equipe'].toString();

        prefs.setString("equipe", equipe).then((onValue){

          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
            });
          });

        });
      });

    }).timeout(Duration(seconds: 10), onTimeout: () {

      _displayDialog_NOk(context);
    });
  }

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              "Ocorreu um erro de conexão com a internet. "
                  "A maioria das funcionalidades do aplicativo dependem de conexão "
                  "com a internet.",
              style: _textStyle(14.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (_) => false);
                },
              ),
            ],
          );
        });
  }

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Image.asset("images/animacao.gif",
                    width: 250, height: 250),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
