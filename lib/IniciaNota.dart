import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'dart:math';

import 'package:osmbtzero/model/Ordem.dart';

class IniciaNota extends StatefulWidget {
  @override
  _IniciaNotaState createState() => _IniciaNotaState();
}

class _IniciaNotaState extends State<IniciaNota> {
  //hints
  String _hintTrafo = "Trafo";
  String _hintAgrupamento = "Agrupamento";
  TextEditingController _controllerDataProg = TextEditingController();
  TextEditingController _controllerAgrupamento = TextEditingController();
  TextEditingController _controllerTrafo = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerMedidor = TextEditingController();
  TextEditingController _controllerCoordX = TextEditingController();
  TextEditingController _controllerCoordY = TextEditingController();
  TextEditingController _controllerNet = TextEditingController();
  String _tipoManutencao = "Tipo de Manutenção";
  String _prioridade = "Prioridade";
  String _equipe = "Equipe";
  TextEditingController _controllerCs = TextEditingController();
  TextEditingController _controllerObs = TextEditingController();
  String _uidcriador;
  String _dataEmissao = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
  String _num_osm = "";
  String _mensagem = "";



  //padrão de TextStyle
  _textStyle14() {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: 14,
      color: Color(0xff9E0616),
    );
  }

  _textStyle11() {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: 11,
      color: Color(0xff9E0616),
    );
  }

  Future _geraOrdem() async {
    //checa o usuario conectado
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String uid = usuarioLogado.uid;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(uid).get();

    var _nomeCriador = snapshot.data["nome"].toString();
    var _sobreNomeCriador = snapshot.data["sobrenome"].toString();

    //salva o criador da nota
    _uidcriador = _nomeCriador + " " + _sobreNomeCriador;

    //--------------------------------------------------------------------------
    //checa o numero da ultima ordem
    Firestore db1 = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db1.collection("ordens").getDocuments().then((value) {
      List<int> listaOrdens = List();
      for (DocumentSnapshot item in value.documents) {
        var dados = item.documentID;

        listaOrdens.add(int.parse(dados));
      }
      var n = listaOrdens.reduce(max) + 1;

      _num_osm = n.toString();

      Ordem ordem = Ordem();
      ordem.emissao = _dataEmissao;
      ordem.nun_osm = _num_osm;
      ordem.data_prog = _controllerDataProg.text;
      ordem.agrupamento = _controllerAgrupamento.text;
      ordem.trafo = _controllerTrafo.text;
      ordem.endereco = _controllerEndereco.text;
      ordem.medidor = _controllerMedidor.text;
      ordem.coordX = _controllerCoordX.text;
      ordem.coordY = _controllerCoordY.text;
      ordem.net = _controllerNet.text;
      ordem.tipMan = _tipoManutencao;
      ordem.prioridade = _prioridade;
      ordem.cs = _controllerCs.text;
      ordem.equipe = _equipe;
      ordem.obs = _controllerObs.text;
      ordem.uidcriador = _uidcriador;
      ordem.uidmod = "";
      ordem.status = "Atribuída";
      ordem.inicio = "";

      Firestore db2 = Firestore.instance;
      db2.collection("ordens").document(_num_osm).setData(ordem.toMap());

      _displayDialog_Ok(
          context, "Ordem criada com sucesso.");
      Navigator.pushReplacementNamed(context, "/admcim");
    }).catchError((error) {
      if (error.toString() == "Bad state: No element") {
        _num_osm = "1";
        _displayDialog_Ok(
            context, "Primeira ordem cadastrada no banco de dados.");
      } else {
        _num_osm = _dataEmissao;
        _displayDialog_Ok(context, "Erro de conexão, NºOSM = zero");
      }

      //Salva os dados da ordem
      //--------------------------------------------------------------------
      Ordem ordem = Ordem();
      ordem.emissao = _dataEmissao;
      ordem.nun_osm = _num_osm;
      ordem.data_prog = _controllerDataProg.text;
      ordem.agrupamento = _controllerAgrupamento.text;
      ordem.trafo = _controllerTrafo.text;
      ordem.endereco = _controllerEndereco.text;
      ordem.medidor = _controllerMedidor.text;
      ordem.coordX = _controllerCoordX.text;
      ordem.coordY = _controllerCoordY.text;
      ordem.net = _controllerNet.text;
      ordem.tipMan = _tipoManutencao;
      ordem.prioridade = _prioridade;
      ordem.cs = _controllerCs.text;
      ordem.equipe = _equipe;
      ordem.obs = _controllerObs.text;
      ordem.uidcriador = _uidcriador;
      ordem.uidmod = "";
      ordem.status = "Atribuída";
      ordem.inicio = "";

      Firestore db2 = Firestore.instance;
      db2
          .collection("ordens")
          .document(_num_osm.split("/")[0])
          .setData(ordem.toMap());
    });
  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context, String _erro) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              _erro,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, "/admcim");
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerar Ordem",
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
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "LOCAL DA MANUTENÇÃO",
                    style: _textStyle14(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerDataProg,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Data de Programação",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerAgrupamento,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: _hintAgrupamento,
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerTrafo,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: _hintTrafo,
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerEndereco,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Endereço",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerMedidor,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Medidor",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerCoordX,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Coordenada X",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerCoordY,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Coordenada Y",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _controllerNet,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "NET",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "DESCRIÇÃO DO SERVIÇO PROGRAMADO",
                    style: _textStyle14(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      _tipoManutencao,
                      style: _textStyle11(),
                    ),
                    items: <String>['Normalizar CS', 'Normalizar IP', "Normalizar medidor", "Religa / ordem",
                      "Inspeção", "Outros"]
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle11(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipoManutencao = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      _prioridade,
                      style: _textStyle11(),
                    ),
                    items:
                        <String>['Alta', 'Média', "Baixa"].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle11(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _prioridade = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerCs,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "CS",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      _equipe,
                      style: _textStyle11(),
                    ),
                    items: <String>['1', '2', '3', '4'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle11(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _equipe = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerObs,
                    keyboardType: TextInputType.text,
                    style: _textStyle11(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Observações",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 15,
                          color: Color(0xffffffff),
                        ),
                      ),
                      color: Color(0xffEE162D),
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        _geraOrdem();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
