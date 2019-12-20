import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Relatorio extends StatefulWidget {
  @override
  _RelatorioState createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {

  Map<String, Map<String, dynamic>> notas = Map();

  String _campo = "Campos disponíveis";
  String _equipe = "Escolha uma equipe";

  bool _isVisibleEquiAtrib = false;
  String _textoEquAtrib = "\nEquipamentos (Viaturas)\n";
  String _exibeEquiAtrib = "";

  bool _isVisibleEquiAdm = false;
  String _textoEquiAdm = "\nEquipamentos (ADM)\n";
  String _exibeEquiAdm = "";

  bool _isVisibleMatAtrib = false;
  String _textoMatAtrib = "\nMateriais atribuídos (Viaturas)\n";
  String _exibeMatAtrib = "";

  bool _isVisibleMatCons = false;
  String _textoMatCons = "\nMateriais consumidos (Viaturas)\n";
  String _exibeMatCons = "";

  bool _isVisibleMatConsForMon = false;
  String _textoMatConsForMon = "\nPesquisa por período\n";
  String _exibeMatConsForMon = "";


  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  _carregarEquipamentos() {
    Firestore db = Firestore.instance;

    _exibeEquiAtrib = "\nEQUIPE 1 \n \n";
    db.collection("Equipe1").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {

          _exibeEquiAtrib = _exibeEquiAtrib +
              f.documentID.toString().toUpperCase() +
              " :" +
              f.data.values.toString() +
              "\n";
      });

      _exibeEquiAtrib = _exibeEquiAtrib + "\nEQUIPE 2 \n \n";
      db.collection("Equipe2").getDocuments().then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {

            _exibeEquiAtrib = _exibeEquiAtrib +
                f.documentID.toString().toUpperCase() +
                " :" +
                f.data.values.toString() +
                "\n";
        });

        _exibeEquiAtrib = _exibeEquiAtrib + "\nEQUIPE 3 \n \n";
        db.collection("Equipe3").getDocuments().then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {

            _exibeEquiAtrib = _exibeEquiAtrib +
                f.documentID.toString().toUpperCase() +
                " :" +
                f.data.values.toString() +
                "\n";
          });

          setState(() {
            _exibeEquiAtrib = _exibeEquiAtrib;
          });
        });//then3
      });//then2
    });//then 1
  }

  _carregarEquipamentosAdm() {
    Firestore db = Firestore.instance;

    _exibeEquiAdm = "\nADM \n \n";
    db.collection("adm").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {

        _exibeEquiAdm = _exibeEquiAdm +
            f.documentID.toString().toUpperCase() +
            " :" +
            f.data.values.toString() +
            "\n";
      });
      setState(() {
        _exibeEquiAdm = _exibeEquiAdm;
      });
    });//then 1
  }

  _carregarmateriaisAtr() {
    Firestore db = Firestore.instance;
    Map<String, dynamic> materiais = Map();
    materiais['blindagem'] = 0.0;
    materiais['caboarmado'] = 0.0;
    materiais['estrangulador'] = 0.0;
    materiais['cabocobre'] = 0.0;
    materiais['alca'] = 0.0;
    materiais['conectorc'] = 0.0;
    materiais['caboip'] = 0.0;
    materiais['cintab'] = 0.0;
    materiais['sealtube'] = 0.0;
    materiais['terminaltubular'] = 0.0;
    materiais['conectorp'] = 0.0;
    materiais['cs'] = 0.0;
    materiais['placaele'] = 0.0;
    materiais['rele'] = 0.0;
    materiais['ramal'] = 0.0;

    db.collection("materiais_atribuidos").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var equipe = f.documentID.toString();

        materiais['blindagem'] += f.data['blindagem'];
        materiais['caboarmado'] += f.data['caboarmado'];
        materiais['estrangulador'] += f.data['estrangulador'];
        materiais['cabocobre'] += f.data['cabocobre'];
        materiais['alca'] += f.data['alca'];
        materiais['conectorc'] += f.data['conectorc'];
        materiais['caboip'] += f.data['caboip'];
        materiais['cintab'] += f.data['cintab'];
        materiais['sealtube'] += f.data['sealtube'];
        materiais['terminaltubular'] += f.data['terminaltubular'];
        materiais['conectorp'] += f.data['conectorp'];
        materiais['cs'] += f.data['cs'];
        materiais['placaele'] += f.data['placaele'];
        materiais['rele'] += f.data['rele'];
        materiais['ramal'] += f.data['ramal'];

        _exibeMatAtrib = _exibeMatAtrib + "\nEQUIPE $equipe \n \n";

        f.data.forEach((String id, dynamic valor){

          _exibeMatAtrib = _exibeMatAtrib +
          id + ": " + valor.toString() + "\n";
        });
      });

      _exibeMatAtrib = _exibeMatAtrib + "\nTOTAIS \n \n";
      materiais.forEach((String id, dynamic valor){
        _exibeMatAtrib = _exibeMatAtrib +
            id + ": " + valor.toString() + "\n";
      });

      setState(() {
        _exibeMatAtrib = _exibeMatAtrib;
      });
      print(materiais.toString());
    });//then 1

  }

  _carregarmateriaisCons() {
    Firestore db = Firestore.instance;

    Map<String, dynamic> materiais = Map();
    materiais['blindagem'] = 0.0;
    materiais['caboarmado'] = 0.0;
    materiais['estrangulador'] = 0.0;
    materiais['cabocobre'] = 0.0;
    materiais['alca'] = 0.0;
    materiais['conectorc'] = 0.0;
    materiais['caboip'] = 0.0;
    materiais['cintab'] = 0.0;
    materiais['sealtube'] = 0.0;
    materiais['terminaltubular'] = 0.0;
    materiais['conectorp'] = 0.0;
    materiais['cs'] = 0.0;
    materiais['placaele'] = 0.0;
    materiais['rele'] = 0.0;
    materiais['ramal'] = 0.0;

    db.collection("materiais_consumidos").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var equipe = f.documentID.toString();
        materiais['blindagem'] += f.data['blindagem'];
        materiais['caboarmado'] += f.data['caboarmado'];
        materiais['estrangulador'] += f.data['estrangulador'];
        materiais['cabocobre'] += f.data['cabocobre'];
        materiais['alca'] += f.data['alca'];
        materiais['conectorc'] += f.data['conectorc'];
        materiais['caboip'] += f.data['caboip'];
        materiais['cintab'] += f.data['cintab'];
        materiais['sealtube'] += f.data['sealtube'];
        materiais['terminaltubular'] += f.data['terminaltubular'];
        materiais['conectorp'] += f.data['conectorp'];
        materiais['cs'] += f.data['cs'];
        materiais['placaele'] += f.data['placaele'];
        materiais['rele'] += f.data['rele'];
        materiais['ramal'] += f.data['ramal'];

        _exibeMatCons = _exibeMatCons + "\nEQUIPE $equipe \n \n";
        f.data.forEach((String id, dynamic valor){
          _exibeMatCons = _exibeMatCons +
              id + ": " + valor.toString() + "\n";
        });
      });

      _exibeMatCons = _exibeMatCons + "\nTOTAIS \n \n";
      materiais.forEach((String id, dynamic valor){
        _exibeMatCons = _exibeMatCons +
            id + ": " + valor.toString() + "\n";
      });

      setState(() {
        _exibeMatCons = _exibeMatCons;
      });
    });//then 1
  }

  _carregarmateriaisConsForMon(initial_data, final_data, campo) {





  }

  _carregaNotas() async{
    Firestore db = Firestore.instance;
    db.collection("notas").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        notas[f.documentID]=f.data;

      });
      setState(() {
        notas = notas;
      });

    });//then 1
  }

  @override
  void initState() {
    _carregaNotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Relatórios",
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/admcim", (_) => false);
          },
        ),
        backgroundColor: Color(0xffEE162D),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "\n Escolha uma opção de Relatório",
                  style: _textStyle(16.0),
                  textAlign: TextAlign.left,
                ),
              ),
              //-----------------------Equipamentos viaturas -------------------
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoEquAtrib,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleEquiAtrib = !_isVisibleEquiAtrib;
                          _exibeEquiAtrib = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleEquiAtrib,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeEquiAtrib,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 13,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                color: Color(0xffEE162D),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  _carregarEquipamentos();
                                }),
                          ),
                        ],
                      ),
                    ),

                    //------------------ Equipamentos Adm-----------------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoEquiAdm,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleEquiAdm = !_isVisibleEquiAdm;
                          _exibeEquiAdm = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleEquiAdm,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeEquiAdm,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 13,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                color: Color(0xffEE162D),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  _carregarEquipamentosAdm();
                                }),
                          ),
                        ],
                      ),
                    ),
                    //------------------ Materiais Atribuídos-------------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoMatAtrib,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleMatAtrib = !_isVisibleMatAtrib;
                          _exibeMatAtrib = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleMatAtrib,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeMatAtrib,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 13,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                color: Color(0xffEE162D),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  _carregarmateriaisAtr();
                                }),
                          ),
                        ],
                      ),
                    ),
                    //------------------ Materiais Consumidos-------------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoMatCons,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleMatCons = !_isVisibleMatCons;
                          _exibeMatCons = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleMatCons,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeMatCons,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 13,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                color: Color(0xffEE162D),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  _carregarmateriaisCons();
                                }),
                          ),
                        ],
                      ),
                    ),
                    //-------------- Materiais Consumidos por mês --------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoMatConsForMon,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleMatConsForMon = !_isVisibleMatConsForMon;
                          _exibeMatConsForMon = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleMatConsForMon,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeMatConsForMon,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Escolha os campos abaixo...",
                              style: _textStyle(13.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: DropdownButton<String>(
                              elevation: 15,
                              iconSize: 30,
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                              ),
                              hint: Text(
                                _campo,
                                style: _textStyle(13.0),
                              ),
                              items: <String>["Materiais", "medidores instalados", "Medidores retirados",
                                "CPUs instalados", "CPUs retirados",
                                "Rádios instalados", "Rádios retirados", "Display instalados", "Display retirados",
                                "Sensores IP instalados", "Sensores IP retirados", "CPs instalados", "CPs retirados",
                                "Remotas instaladas", "Remotas retiradas", "Cpus de CP instaladas",
                                "Cpus de CP retiradas", "Sim Cards instalados", "Sim Cards retirados",
                                "Tempo médio de atendimento", ]
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: _textStyle(13.0),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _campo = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: DropdownButton<String>(
                              elevation: 15,
                              iconSize: 30,
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                              ),
                              hint: Text(
                                _equipe,
                                style: _textStyle(13.0),
                              ),
                              items: <String>["Equipe 1", "Equipe 2", "Equipe 3", "Todas"]
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: _textStyle(13.0),
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
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
                                    fontSize: 13,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                color: Color(0xffEE162D),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  //_carregarmateriaisConsForMon(inicio, fim, campo);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
