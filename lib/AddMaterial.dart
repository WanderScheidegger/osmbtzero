import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddMaterial extends StatefulWidget {
  @override
  _AddMaterialState createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {


  TextEditingController _controllerMedidor = TextEditingController();
  TextEditingController _controllerCpu = TextEditingController();
  TextEditingController _controllerCpuCP = TextEditingController();
  TextEditingController _controllerRadio = TextEditingController();
  TextEditingController _controllerDisplay = TextEditingController();
  TextEditingController _controllerSensorIp = TextEditingController();
  TextEditingController _controllerCp = TextEditingController();
  TextEditingController _controllerRemota = TextEditingController();
  TextEditingController _controllerSsn = TextEditingController();
  TextEditingController _controllerMaterial = TextEditingController();
  String _equipe = "Escolha a equipe";
  var _cs = 0.0;
  var _ramal = 0.0;
  var _caboip = 0.0;
  var _conectorp = 0.0;
  var _conectorc = 0.0;
  var _caboarmado = 0.0;
  var _terminaltubular = 0.0;
  var _sealtube = 0.0;
  var _blindagem = 0.0;
  var _estrangulador = 0.0;
  var _cabocobre = 0.0;
  var _placaele = 0.0;
  var _rele = 0.0;
  var _alca = 0.0;
  var _cintab = 0.0;

  var _quantidades;

  ProgressDialog pr;

  String _textoMateriais = "RAMAL:0\n"
      "CABO IP:0\n"
      "CONECTOR PERFURANTE:0\n"
      "CS:0\n"
      "CABO ARMADO:0\n"
      "CONECTOR CUNHA:0\n"
      "TERMINAL TUBULAR:0\n"
      "SEAL TUBE:0\n"
      "BLINDAGEM TRAFO:0\n"
      "ESTRANGULADOR:0\n"
      "CABO COBRE:0\n"
      "PLACA ELETRÔNICA NG:0\n"
      "RELÉ:0\n"
      "ALÇA:0\n"
      "CINTA BAP-3:0";


  Future<void> scanBarcodeNormal(String campo) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#9E0616", "Cancela", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Falha ao capturar a plataforma.';
    }

    if (!mounted) return;
    switch (campo){
      case "medidor":
        setState(() {
          _controllerMedidor.text = barcodeScanRes;
        });
        break;
      case "CPU":
        setState(() {
          _controllerCpu.text = barcodeScanRes;
        });
        break;
      case "Radio":
        setState(() {
          _controllerRadio.text = barcodeScanRes;
        });
        break;
      case "Display":
        setState(() {
          _controllerDisplay.text = barcodeScanRes;
        });
        break;
      case "Sensorip":
        setState(() {
          _controllerSensorIp.text = barcodeScanRes;
        });
        break;
      case "CP":
        setState(() {
          _controllerCp.text = barcodeScanRes;
        });
        break;
      case "Remota":
        setState(() {
          _controllerRemota.text = barcodeScanRes;
        });
        break;
      case "Cpucp":
        setState(() {
          _controllerCpuCP.text = barcodeScanRes;
        });
        break;
      case "Ssn":
        setState(() {
          _controllerSsn.text = barcodeScanRes;
        });
        break;
    }

  }

  _tratarString(string) {

    var quantidades = string.split("\n");
    Map<String, dynamic> materiais = Map();
    for (var i in quantidades) {
      var sp = i.split(":");
      print("dados " + sp.toString());
      materiais[sp[0]] = double.parse(sp[1]);
    }
    return materiais;
  }

  _atribuiQuant() {

    setState(() {
      _quantidades = _tratarString(_controllerMaterial.text);
    });

    Firestore db = Firestore.instance;
    db
        .collection("materiais_atribuidos")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print("DDDDD: " + f.data.toString());
        if (f.documentID == _equipe) {
          setState(() {
            _cs = f.data['cs'] + _quantidades['CS'];
            _ramal = f.data['ramal'] + _quantidades['RAMAL'];
            _caboip = f.data['caboip'] + _quantidades['CABO IP'];
            _conectorp =
                f.data['conectorp'] + _quantidades['CONECTOR PERFURANTE'];
            _conectorc = f.data['conectorc'] + _quantidades['CONECTOR CUNHA'];
            _caboarmado = f.data['caboarmado'] + _quantidades['CABO ARMADO'];
            _terminaltubular =
                f.data['terminaltubular'] + _quantidades['TERMINAL TUBULAR'];
            _sealtube = f.data['sealtube'] + _quantidades['SEAL TUBE'];
            _blindagem =
                f.data['blindagem'] + _quantidades['BLINDAGEM TRAFO'];
            _estrangulador =
                f.data['estrangulador'] + _quantidades['ESTRANGULADOR'];
            _cabocobre = f.data['cabocobre'] + _quantidades['CABO COBRE'];
            _placaele =
                f.data['placaele'] + _quantidades['PLACA ELETRÔNICA NG'];
            _rele = f.data['rele'] + _quantidades['RELÉ'];
            _alca = f.data['alca'] + _quantidades['ALÇA'];
            _cintab = f.data['cintab'] + _quantidades['CINTA BAP-3'];
          });


        }

      });

      var dados = {
        "cs": _cs,
        "ramal": _ramal,
        "caboip": _caboip,
        "conectorp": _conectorp,
        "conectorc": _conectorc,
        "caboarmado": _caboarmado,
        "terminaltubular": _terminaltubular,
        "sealtube": _sealtube,
        "blindagem": _blindagem,
        "estrangulador": _estrangulador,
        "cabocobre": _cabocobre,
        "placaele": _placaele,
        "rele": _rele,
        "alca": _alca,
        "cintab": _cintab
      };

      db
          .collection("materiais_atribuidos")
          .document(_equipe)
          .setData(dados)
          .then((onValue) {
        //salvando os equipamentos

        if (_controllerMedidor.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document("medidores")
              .setData({_controllerMedidor.text: _controllerMedidor.text});
        }
        if (_controllerCpu.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document("cpus")
              .setData({_controllerCpu.text: _controllerCpu.text});
        }
        if (_controllerCpuCP.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document("cpuscp")
              .setData({_controllerCpuCP.text: _controllerCpuCP.text});
        }
        if (_controllerCp.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document('cps')
              .setData({_controllerCp.text: _controllerCp.text});
        }
        if (_controllerSsn.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document('ssns')
              .setData({_controllerSsn.text: _controllerSsn.text});
        }
        if (_controllerRemota.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document('remotas')
              .setData({_controllerRemota.text: _controllerRemota.text});
        }
        if (_controllerSensorIp.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document('sensoresip')
              .setData({_controllerSensorIp.text: _controllerSensorIp.text});
        }
        if (_controllerDisplay.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document('displays')
              .setData({_controllerDisplay.text: _controllerDisplay.text});
        }
        if (_controllerRadio.text.isNotEmpty) {
          db
              .collection("Equipe" + _equipe)
              .document('radios')
              .setData({_controllerRadio.text: _controllerRadio.text});
        }

        pr.hide();
        _displayDialog(context, "Dados salvos com sucesso!");


      }).timeout(Duration(seconds: 10), onTimeout: (){
        print("timeou equipamentos");
        pr.hide();
      });



    }).timeout(Duration(seconds: 10), onTimeout: (){
      print("timeou materiais");
      pr.hide();
    });

  }

  //ALERT DIALOG
  _displayDialogCancel(BuildContext context, mensagem) async {
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

  //ALERT DIALOG
  _displayDialog(BuildContext context, mensagem) async {
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
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/admcim", (_) => false);
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

  Widget _insertTextField(controller, hint, size) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        style: _textStyle(size),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
          filled: true,
          fillColor: Color(0xffB5B6B3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          if (_equipe == "Escolha a equipe"){
            return AlertDialog(
              elevation: 10,
              title: Text(
                "Erro de preenchimento. Preencha a equipe e tente novamente.",
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
          }else {
            return AlertDialog(
              title: Text(
                "Tem certeza que deseja atribuir o material?",
                style: _textStyle(12.0),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Enviar'),
                  onPressed: () {
                    _atribuiQuant();
                    Navigator.of(context).pop();
                    pr = new ProgressDialog(context,
                        type: ProgressDialogType.Normal,
                        isDismissible: true,
                        showLogs: true);
                    pr.style(
                      message: 'Salvando os dados...',
                      borderRadius: 10.0,
                      backgroundColor: Colors.white,
                      progressWidget: CircularProgressIndicator(),
                      elevation: 10.0,
                      insetAnimCurve: Curves.easeInOut,
                      messageTextStyle: _textStyle(14.0),

                    );
                    pr.show();
                  },
                ),
                FlatButton(
                  child: Text('Revisar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        });
  }

  @override
  void initState() {
    setState(() {
      _controllerMaterial.text = _textoMateriais;
      //_tratarString(_textoMateriais);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Atribuir Material",
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
        padding: EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Escolha a equipe de envio do material",
                    style: _textStyle(18.0),
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
                      _equipe,
                      style: _textStyle(14.0),
                    ),
                    items: <String>['1', '2', "3", "4"].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: _textStyle(16.0),
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
                  child: Text(
                  "EQUIPAMENTOS",
                  style: _textStyle(14.0),
                  textAlign: TextAlign.center,
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerMedidor, "Medidor", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("medidor");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerCpu, "CPU", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("CPU");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerRadio, "Rádio", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("Radio");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerDisplay, "Display", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("Display");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerSensorIp, "Sensor IP", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("Sensorip");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerCp, "CP", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("CP");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerRemota, "Remota", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("Remota");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerCpuCP, "Cpu CP", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("Cpucp");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Color(0xffB5B6B3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 210,
                          child: _insertTextField(_controllerSsn, "SSN", 13.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          child: Image.asset("images/barcode2.png",
                              width: 60, height: 60),
                          onTap: (){
                            scanBarcodeNormal("Ssn");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "MATERIAIS",
                    style: _textStyle(14.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerMaterial,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: _textStyle(13.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: _textoMateriais,
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
                        "Atribuir",
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
                        _displayDialog_Ok(context);
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
