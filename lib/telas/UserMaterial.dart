import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMaterial extends StatefulWidget {
  @override
  _UserMaterialState createState() => _UserMaterialState();
}

class _UserMaterialState extends State<UserMaterial> {
  String _isLoading = "";
  String _opcao = "Escolha uma opção";
  static String _equipeLogado = "sem equipe";
  String _atribuidos = "";
  String _equips = "";
  Map<String, dynamic> _equipamentos = Map();

  Widget _visualizaDados() {
    if (_isLoading == "atribuidos") {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffB5B6B3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _atribuidos,
          style: _textStyle(13.0),
          textAlign: TextAlign.left,
        ),
      );
    } else if (_isLoading == "equipamentos") {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffB5B6B3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _equips,
          style: _textStyle(13.0),
          textAlign: TextAlign.left,
        ),
      );
    } else if (_isLoading == "consumidos") {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffB5B6B3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _atribuidos,
          style: _textStyle(13.0),
          textAlign: TextAlign.left,
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  _carregaMateriais(valor) {
    var colecao;
    var setMens;

    if (valor == 1) {
      colecao = "materiais_atribuidos";
      setMens = "atribuidos";
    } else {
      colecao = "materiais_consumidos";
      setMens = "consumidos";
    }

    Firestore db = Firestore.instance;
    db.collection(colecao).document(_equipeLogado).get().then((value) {
      setState(() {
        var ramal = value.data['ramal'];
        var caboip = value.data['caboip'];
        var conectorp = value.data['conectorp'];
        var cs = value.data['cs'];
        var caboarmado = value.data['caboarmado'];
        var conectorc = value.data['conectorc'];
        var terminaltubular = value.data['terminaltubular'];
        var sealtube = value.data['sealtube'];
        var blindagem = value.data['blindagem'];
        var estrangulador = value.data['estrangulador'];
        var cabocobre = value.data['cabocobre'];
        var placaele = value.data['placaele'];
        var rele = value.data['rele'];
        var alca = value.data['alca'];
        var cintab = value.data['cintab'];

        _atribuidos = "RAMAL: $ramal metros.\n"
            "CABO IP: $caboip metros.\n"
            "CONECTOR PERFURANTE: $conectorp unidades.\n"
            "CS: $cs unidades.\n"
            "CABO ARMADO: $caboarmado metros.\n"
            "CONECTOR CUNHA: $conectorc unidades.\n"
            "TERMINAL TUBULAR: $terminaltubular unidades.\n"
            "SEAL TUBE: $sealtube unidades.\n"
            "BLINDAGEM TRAFO: $blindagem unidades.\n"
            "ESTRANGULADOR: $estrangulador unidades.\n"
            "CABO COBRE: $cabocobre metros.\n"
            "PLACA ELETRÔNICA NG: $placaele unidades.\n"
            "RELÉ: $rele unidades.\n"
            "ALÇA: $alca unidades.\n"
            "CINTA BAP-3: $cintab unidades.";

        setState(() {
          _isLoading = setMens;
        });

        if (setMens=="atribuidos"){
          if (ramal<50 || caboip<50 || conectorp<5 || conectorc<5 || cs<1 || cabocobre<30 || caboarmado<50 || terminaltubular<5
          || sealtube<5 || blindagem<3 || estrangulador<5 || placaele<2 || rele<5 || alca<5 || cintab<5){
            _displayAlert(context, "Alguns materiais estão em baixa quantidade no estoque. "
                "Solicite mais material ao seu administrador.");

          }

        }

      });
    });
  }

  //ALERT DIALOG
  _displayAlert(BuildContext context, mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              mensagem,
              style: _textStyle(14.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _carregarEquipamentos() {
    setState(() {
      _equips = "";
    });

    Firestore db = Firestore.instance;
    db
        .collection("Equipe" + _equipeLogado)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        _equipamentos[f.documentID.toString()] = f.data.values.toString();
        setState(() {
          _equips = _equips +
              f.documentID.toString().toUpperCase() +
              " :" +
              f.data.values.toString() +
              "\n";
        });
      });
      setState(() {
        _isLoading = "equipamentos";
      });
    });
  }

  _verificaEquipe() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq==""){
      eq = prefs.getString("equipe");
    }

    setState(() {
      _equipeLogado = eq;
    });
  }

  @override
  void initState() {
    _verificaEquipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Container(
                  padding:
                      EdgeInsets.only(bottom: 20, top: 20, right: 5, left: 5),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Escolha abaixo a opção que deseja listar",
                    style: _textStyle(14.0),
                    textAlign: TextAlign.center,
                  ),
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
                    _opcao,
                    style: _textStyle(14.0),
                  ),
                  items: <String>[
                    'Materiais consumidos',
                    'Materiais atribuídos',
                    "Equipamentos"
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: _textStyle(14.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _opcao = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _visualizaDados(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: RaisedButton(
                    child: Text(
                      "Listar",
                      style: TextStyle(
                        fontFamily: "EDP Preon",
                        fontSize: 15,
                        color: Color(0xffffffff),
                      ),
                    ),
                    color: Color(0xffEE162D),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (_opcao == 'Materiais atribuídos') {
                        _carregaMateriais(1);
                      } else if (_opcao == 'Materiais consumidos') {
                        _carregaMateriais(2);
                      } else if (_opcao == 'Equipamentos') {
                        _carregarEquipamentos();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
