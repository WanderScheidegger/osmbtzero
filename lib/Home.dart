import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Ordem.dart';
import 'package:osmbtzero/telas/Aexecutar.dart';
import 'package:osmbtzero/telas/EmExecucao.dart';
import 'package:osmbtzero/telas/Executadas.dart';
import 'package:osmbtzero/telas/UserMaterial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> itensMenu = ["Logout", "Mapa", "ADM"];
  TextEditingController _dialogController = TextEditingController();
  String _textoAalerta = "Digite a senha de Administrador";
  Ordem ordem = Ordem();
  String _equipeLogado = "sem equipe";


  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "ADM":
        _displayDialog(context);
        break;
      case "Mapa":
        Navigator.pushNamedAndRemoveUntil(context, "/rota", (_) => false);
        break;
      case "Logout":
        _deslogarUsuario();
        break;

    }
  }

  //ALERT DIALOG
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_textoAalerta),
            content: TextField(
              controller: _dialogController,
              obscureText: true,
              decoration: InputDecoration(hintText: ""),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Entrar'),
                onPressed: () {
                  _admLogin();
                },
              ),
              FlatButton(
                child: Text('Cancela'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _admLogin() {
    String senhaADM = _dialogController.text;
    if (senhaADM == "edpES") {
      setState(() {
        _dialogController.text = "";
      });
      Navigator.pushReplacementNamed(context, "/admcim");
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado == null) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    }
  }

  _adicionarListenerLocalizacao() async{

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high,
        timeInterval: 60000,
    );
    geolocator.getPositionStream( locationOptions )
        .listen((Position position){

      Firestore db = Firestore.instance;
      db.collection("localiza").document(_equipeLogado).
      updateData({"latitude": position.latitude, "longitude": position.longitude,
        "time": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' - ', H, ':', nn]).toString()})
          .then((onValue){
        print("localizacao atual: " + position.toString());
      });
    });

  }

  _verificaEquipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq == "") {
      eq = prefs.getString("equipe");
    }

    setState(() {
      _equipeLogado = eq;
    });

  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _verificaEquipe();
    _adicionarListenerLocalizacao();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _dialogController.text = "";

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manutenção - OSM",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xffEE162D),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 2,
          indicatorColor: Colors.white,
          labelColor: Color(0xffffffff),
          labelStyle: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 7,
          ),
          //controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.sort,
                size: 30,
              ),
              text: "A executar",
            ),
            Tab(
              icon: Icon(
                Icons.timer,
                size: 30,
              ),
              text: "Em execução",
            ),
            Tab(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              text: "Executadas",
            ),
            Tab(
              icon: Icon(
                Icons.work,
                size: 30,
              ),
              text: "Material",
            ),

          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Aexecutar(),
          EmExecucao(),
          Executadas(),
          UserMaterial(),
        ],
      ),
    );
  }
}
