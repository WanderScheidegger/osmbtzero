import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Ordem.dart';

class EditaNota extends StatefulWidget {
  Ordem ordem;
  EditaNota(this.ordem);

  @override
  _EditaNotaState createState() => _EditaNotaState();
}

class _EditaNotaState extends State<EditaNota> {

  Ordem ordensrecebidas = Ordem();

  TextEditingController _controllerDataProg = TextEditingController();
  TextEditingController _controllerAgrupamento = TextEditingController();
  TextEditingController _controllerTrafo = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerMedidor = TextEditingController();
  TextEditingController _controllerCoordX = TextEditingController();
  TextEditingController _controllerCoordY = TextEditingController();
  TextEditingController _controllerNet = TextEditingController();
  TextEditingController _controllerCs = TextEditingController();
  TextEditingController _controllerObs = TextEditingController();
  String _tipoManutencao = "";
  String _prioridade = "";
  String _equipe = "";
  String _uidcriador ;
  String _dataEmissao;
  String _num_osm;
  String _emailUserLogado;
  String _inicio = "";
  String _status;


  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    setState(() {
      _emailUserLogado = usuarioLogado.email.toString();
    });
  }

  _editaOrdem(){

    Firestore db = Firestore.instance;

    ordensrecebidas.emissao = _dataEmissao;
    ordensrecebidas.nun_osm = _num_osm;
    ordensrecebidas.data_prog = _controllerDataProg.text;
    ordensrecebidas.agrupamento = _controllerAgrupamento.text;
    ordensrecebidas.trafo = _controllerTrafo.text;
    ordensrecebidas.endereco = _controllerEndereco.text;
    ordensrecebidas.medidor = _controllerMedidor.text;
    ordensrecebidas.coordX = _controllerCoordX.text;
    ordensrecebidas.coordY = _controllerCoordY.text;
    ordensrecebidas.net = _controllerNet.text;
    ordensrecebidas.tipMan = _tipoManutencao;
    ordensrecebidas.prioridade = _prioridade;
    ordensrecebidas.cs = _controllerCs.text;
    ordensrecebidas.equipe = _equipe;
    ordensrecebidas.obs = _controllerObs.text;
    ordensrecebidas.uidcriador = _uidcriador;
    ordensrecebidas.uidmod =  _emailUserLogado;
    ordensrecebidas.status = _status;
    ordensrecebidas.inicio = _inicio;

    db.collection("ordens").document(_num_osm).setData(ordensrecebidas.toMap()).
    then((onValue){
      _displayDialog_Ok(context, "Dados alterados com sucesso");
    }).
    catchError((onError){
      _displayDialog_Ok(context, onError.toString());
    });

  }

  //padrão de TextStyle
  _textStyle12() {
    return TextStyle(
      fontFamily: "EDPPreon",
      fontSize: 12,
      color: Color(0xff9E0616),
    );
  }

  _textStyle11() {
    return TextStyle(
      fontFamily: "EDPPreon",
      fontSize: 11,
      color: Color(0xff9E0616),
    );
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

  _testaVazios(){
    if (widget.ordem.status != "Atribuída" && widget.ordem.status != ""){
      setState(() {
        _status = widget.ordem.status;
      });
    }else{
      setState(() {
        _status = "Atribuída";
      });
    }
    if (_prioridade == ""){
      setState(() {
        _prioridade = widget.ordem.prioridade;
      });
    }
    if(_equipe == ""){
      setState(() {
        _equipe = widget.ordem.equipe;
      });
    }
    if(_tipoManutencao == ""){
      setState(() {
        _tipoManutencao = widget.ordem.tipMan;
      });
    }
    if(_inicio == ""){
      setState(() {
        _inicio = widget.ordem.inicio;
      });
    }
    if (_controllerDataProg.text == null || _controllerDataProg.text == ""){
      setState(() {
        _controllerDataProg.text = widget.ordem.data_prog;
      });
    }
    if (_controllerAgrupamento.text == null || _controllerAgrupamento.text == ""){
      setState(() {
        _controllerAgrupamento.text = widget.ordem.agrupamento;
      });
    }
    if (_controllerTrafo.text == null || _controllerTrafo.text == ""){
      setState(() {
        _controllerTrafo.text = widget.ordem.trafo;
      });
    }
    if (_controllerEndereco.text == null || _controllerEndereco.text == ""){
      setState(() {
        _controllerEndereco.text = widget.ordem.endereco;
      });
    }
    if (_controllerMedidor.text == null || _controllerMedidor.text == ""){
      setState(() {
        _controllerMedidor.text = widget.ordem.medidor;
      });
    }
    if (_controllerCoordX.text == null || _controllerCoordX.text == ""){
      _controllerCoordX.text = widget.ordem.coordX;
    }
    if (_controllerCoordY.text == null || _controllerCoordY.text == ""){
      setState(() {
        _controllerCoordY.text = widget.ordem.coordY;
      });
    }
    if (_controllerNet.text == null || _controllerNet.text == ""){
      setState(() {
        _controllerNet.text = widget.ordem.net;
      });
    }
    if (_controllerCs.text == null || _controllerCs.text == ""){
      setState(() {
        _controllerCs.text = widget.ordem.cs;
      });
    }
    if (_controllerObs.text == null || _controllerObs.text == ""){
      setState(() {
        _controllerObs.text = widget.ordem.obs;
      });
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar OSM nº " + widget.ordem.nun_osm,
          style: TextStyle(
            fontFamily: "EDPPreon",
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
        padding: EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Data da programação",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.data_prog,
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
                    "Agrupamento",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.agrupamento,
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
                    "Trafo",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.trafo,
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
                    "Endereço",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.endereco,
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
                    "Medidor",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.medidor,
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
                    "Coordenada X",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.coordX,
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
                    "Coordenada Y",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.coordY,
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
                    "NET",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.net,
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
                    "Tipo de manutenção",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      widget.ordem.tipMan,
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
                        widget.ordem.tipMan = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Prioridade",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      widget.ordem.prioridade,
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
                        widget.ordem.prioridade = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Equipe",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    elevation: 15,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    hint: Text(
                      widget.ordem.equipe,
                      style: _textStyle11(),
                    ),
                    items: <String>['1', '2', "3", "4"].map((String value) {
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
                        widget.ordem.equipe = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "CS",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.cs,
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
                    "Observações",
                    style: _textStyle12(),
                    textAlign: TextAlign.left,
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
                      hintText: widget.ordem.obs,
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
                        "Editar",
                        style: TextStyle(
                          fontFamily: "EDPPreon",
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
                        _testaVazios();
                        setState(() {
                          _num_osm = widget.ordem.nun_osm;
                          _uidcriador = widget.ordem.uidcriador;
                          _dataEmissao = widget.ordem.emissao;
                        });
                        _editaOrdem();
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
