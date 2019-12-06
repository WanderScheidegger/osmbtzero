import 'package:flutter/material.dart';
import 'package:osmbtzero/Login.dart';
import 'package:osmbtzero/RouteGenerator.dart';

void main(){

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Colors.white,
      accentColor: Color(0xffEE162D),
    ),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));

}

