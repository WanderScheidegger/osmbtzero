import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osmbtzero/model/Ordem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Aexecutar extends StatefulWidget {
  @override
  _AexecutarState createState() => _AexecutarState();
}

class _AexecutarState extends State<Aexecutar> {
  static Firestore db = Firestore.instance;
  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;


  //ALERT DIALOG
  static _displayDialog_Ok(BuildContext context, item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Tem certeza que deseja iniciar o deslocamento?",
              style: TextStyle(
                fontFamily: "EDP Preon",
                fontSize: 12,
                color: Color(0xff9E0616),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Iniciar'),
                onPressed: () {
                  DateTime time = Timestamp.now().toDate();
                  String _timeInicio = formatDate(
                      time, [dd, '/', mm, '/', yyyy, ' - ', H, ':', nn]);
                  db
                      .collection("ordens")
                      .document(item['numero_ordem'])
                      .updateData(
                          {'status': 'Em execução', 'inicio': _timeInicio});

                  Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high
                  ).then((Position position){
                    Navigator.of(context).pop();
                    _displayMapsOption(context, item, position.latitude, position.longitude);
                  }).timeout(Duration(seconds: 5), onTimeout: () {
                    Navigator.of(context).pop();
                    _displayMapsOption(context, item, -20.2109753,-40.2701441);
                  });
                },
              ),
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //ALERT DIALOG
  static _displayMapsOption(BuildContext context, item, lat, long) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Deseja abrir o Maps com uma sugestão de rota?",
              style: TextStyle(
                fontFamily: "EDP Preon",
                fontSize: 12,
                color: Color(0xff9E0616),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Abrir rota'),
                onPressed: () {
                  launch(
                      "https://www.google.com.br/maps/dir/$lat,$long/" +
                          item['coordenada_x'] +
                          "," +
                          item['coordenada_y']);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  StreamBuilder stream = StreamBuilder(
      stream: db
          .collection("ordens")
          .where('status', isEqualTo: "Atribuída")
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Expanded(
              child: Text(
                "Você não tem conexão com a internet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 12,
                  color: Color(0xff9E0616),
                ),
              ),
            );
          case ConnectionState.waiting:
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Carregando as ordens...",
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 12,
                      color: Color(0xff9E0616),
                    ),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (querySnapshot.documents.length == 0) {
              return Card(
                elevation: 8,
                color: Color(0xffB5B6B3),
                borderOnForeground: true,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Você não tem ordens a executar ou houve um erro no carregamento. "
                        "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 12,
                          color: Color(0xff9E0616),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, indice) => Divider(
                          color: Color(0xff9E0616),
                          thickness: 0.2,
                        ),
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {

                      //Recupara as ordens
                      List<DocumentSnapshot> ordens = querySnapshot.documents
                          .where((snapshot) =>
                              snapshot.data['equipe'] == _equipeLogado)
                          .toList();

                      if (ordens.length != 0){
                        DocumentSnapshot item = ordens[indice];

                        Ordem ordem = Ordem();

                        ordem.emissao = item['emissao'];
                        ordem.nun_osm = item['numero_ordem'];
                        ordem.data_prog = item['data_programacao'];
                        ordem.agrupamento = item['agrupamento'];
                        ordem.trafo = item['trafo'];
                        ordem.endereco = item['endereco'];
                        ordem.medidor = item['medidor'];
                        ordem.coordX = item['coordenada_x'];
                        ordem.coordY = item['coordenada_y'];
                        ordem.net = item['net'];
                        ordem.tipMan = item['tipo_manutencao'];
                        ordem.prioridade = item['prioridade'];
                        ordem.cs = item['cs'];
                        ordem.equipe = item['equipe'];
                        ordem.obs = item['observacoes'];
                        ordem.uidcriador = item['uidcriador'];
                        ordem.uidmod = "";
                        ordem.status = "Atribuída";
                        ordem.inicio = item['inicio'];


                        return Card(
                          elevation: 8,
                          color: Color(0xffB5B6B3),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "OSM: " + item['numero_ordem'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                                subtitle: Text(
                                  item['agrupamento'] +
                                      " \n" +
                                      "Prog.: " +
                                      item['data_programacao'] +
                                      "\n" +
                                      "Equipe: " +
                                      item['equipe'] +
                                      "\n" +
                                      "Tipo: " +
                                      item['tipo_manutencao'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                                trailing: Text(
                                  "Prioridade: " +
                                      item['prioridade'] +
                                      "\n" +
                                      "Sit: " +
                                      item['status'],
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 10,
                                    color: Color(0xffEE162D),
                                  ),
                                ),
                              ),
                              ButtonTheme.bar(
                                child: ButtonBar(
                                  children: <Widget>[
                                    RaisedButton(
                                        child: Text(
                                          "Visualizar",
                                          style: TextStyle(
                                            fontFamily: "EDP Preon",
                                            fontSize: 9,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        color: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, "/seeorder",
                                              arguments: ordem);
                                        }),
                                    RaisedButton(
                                        child: Text(
                                          "Iniciar deslocamento",
                                          style: TextStyle(
                                            fontFamily: "EDP Preon",
                                            fontSize: 9,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          _displayDialog_Ok(context, item);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }else {

                        return Card(
                          elevation: 8,
                          color: Color(0xffB5B6B3),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Você não tem ordens a executar ou houve um erro no carregamento. "
                                      "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              );
            }
            break;
        }
      });

  _verificaEquipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq == "") {
      eq = prefs.getString("equipe");
    }

    setState(() {
      _equipeLogado = eq;
    });
    if (_equipeLogado == "Adm" || _equipeLogado == "sem equipe") {
      setState(() {
        _isSemEquipe = false;
      });
    }else{
      setState(() {
        _isSemEquipe = true;
      });
    }
  }


  @override
  void initState() {
    _verificaEquipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: _isSemEquipe,
            child: stream,
            replacement: Card(
              elevation: 8,
              color: Color(0xffB5B6B3),
              borderOnForeground: true,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Você ainda não foi atribuído a uma equipe. Por favor, entre em contato com a administração.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: 12,
                        color: Color(0xff9E0616),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
