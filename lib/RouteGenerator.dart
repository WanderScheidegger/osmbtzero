import 'package:flutter/material.dart';
import 'package:osmbtzero/AddMaterial.dart';
import 'package:osmbtzero/AdmCim.dart';
import 'package:osmbtzero/Cadastro.dart';
import 'package:osmbtzero/FinalizaNota.dart';
import 'package:osmbtzero/Home.dart';
import 'package:osmbtzero/IniciaNota.dart';
import 'package:osmbtzero/ModificaUsuario.dart';
import 'package:osmbtzero/telas/LoadPage.dart';
import 'package:osmbtzero/telas/Relatorio.dart';
import 'package:osmbtzero/telas/SeeOrder.dart';
import 'package:osmbtzero/telas/Track.dart';
import 'package:osmbtzero/telas/VisualizarN.dart';
import 'EditaNota.dart';
import 'Login.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/loadpage":
        return MaterialPageRoute(builder: (_) => LoadPage());
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/admcim":
        return MaterialPageRoute(builder: (_) => AdmCim());
      case "/inicianota":
        return MaterialPageRoute(builder: (_) => IniciaNota());
      case "/modificausuario":
        return MaterialPageRoute(builder: (_) => ModificaUsuario(args));
      case "/editanota":
        return MaterialPageRoute(builder: (_) => EditaNota(args));
      case "/finalizanota":
        return MaterialPageRoute(builder: (_) => FinalizaNota(args));
      case "/visualizan":
        return MaterialPageRoute(builder: (_) => VisualizarN(args));
      case "/seeorder":
        return MaterialPageRoute(builder: (_) => SeeOrder(args));
      case "/addmaterial":
        return MaterialPageRoute(builder: (_) => AddMaterial());
      case "/track":
        return MaterialPageRoute(builder: (_) => Track());
      case "/relatorio":
        return MaterialPageRoute(builder: (_) => Relatorio());
    }

  }

}