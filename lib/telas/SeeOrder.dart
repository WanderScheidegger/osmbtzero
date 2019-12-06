import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Ordem.dart';

class SeeOrder extends StatefulWidget {
  Ordem ordem;
  SeeOrder(this.ordem);

  @override
  _SeeOrderState createState() => _SeeOrderState();
}

class _SeeOrderState extends State<SeeOrder> {

  static Firestore db = Firestore.instance;
  static String numero;
  var dados;

  //padrão de TextStyle
  _textStyle14() {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: 14,
      color: Color(0xff9E0616),
    );
  }

  //padrão de TextStyle
  _textStyle12() {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: 12,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "OSM nº " + widget.ordem.nun_osm,
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
              Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
            },
          ),
          backgroundColor: Color(0xffEE162D),
        ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffB5B6B3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      //textos da ordem
                      Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 10),
                        child: Text(
                          "LOCAL DA MANUTENÇÃO",
                          style: _textStyle14(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "DATA DA PROGRAMAÇÃO: " + widget.ordem.data_prog,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "AGRUPAMENTO: " + widget.ordem.agrupamento,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "TRAFO: " + widget.ordem.trafo,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "ENDEREÇO: " + widget.ordem.endereco,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "MEDIDOR: " + widget.ordem.medidor,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "COORDENADA X: " + widget.ordem.coordX,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "COORDENADA Y: " + widget.ordem.coordY,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "NET: " + widget.ordem.net,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "TIPO DE MANUTENÇÃO: " + widget.ordem.tipMan,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "PRIORIDADE: " + widget.ordem.prioridade,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "EQUIPE: " + widget.ordem.equipe,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "CS: " + widget.ordem.cs,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "OBSERV.: " + widget.ordem.obs,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
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
