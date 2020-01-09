import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/Ordem.dart';

class VisualizarNadm extends StatefulWidget {
  Ordem ordem;
  VisualizarNadm(this.ordem);


  @override
  _VisualizarNadmState createState() => _VisualizarNadmState();
}

class _VisualizarNadmState extends State<VisualizarNadm> {
  static Firestore db = Firestore.instance;
  static String numero;
  var dados;
  bool _isLoading = false;
  String nota = "";
  var titles = [];

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

  Widget _nota() {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: Color(0xffB5B6B3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                "DESCRIÇÃO DAS ATIVIDADES REALIZADAS",
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 14,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "REALIZAÇÃO: " + dados['data_realiza'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 12,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "INÍCIO: " + dados['inicio'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "TÉRMINO: " + dados['termino'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "STATUS DE EXECUÇÃO: " + dados['status_exec'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "TEMPO DE ATEND.: " + dados['tempo_atend'] + " minutos",
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "MEDIDOR INST.: " + dados['medidor_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "POSIÇÃO INST.: " + dados['posicao_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "LEITURA INST.: " + dados['leitura_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "MEDIDOR RET.: " + dados['medidor_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "POSIÇÃO RET.: " + dados['posicao_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "LEITURA RET.: " + dados['leitura_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "CPU INST.: " + dados['cpu_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "CPU RET.: " + dados['cpu_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "CPU de CP INST.: " + dados['cpu_cp_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "CPU de CP RET.: " + dados['cpu_cp_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "RADIO INST.: " + dados['radio_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "RADIO RET.: " + dados['radio_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "DISPLAY INST.: " + dados['display_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "DISPLAY RET.: " + dados['display_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "SENSOR IP INST.: " + dados['ip_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "SENSOR IP RET.: " + dados['ip_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "CP INST.: " + dados['cp_inst'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "CP RET.: " + dados['cp_ret'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Número de Clandestinas: " + dados['num_clandestinas'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Observ.: " + dados['obs'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Materiais.: " + dados['materiais'],
                style: TextStyle(
                  fontFamily: "EDP Preon",
                  fontSize: 11,
                  color: Color(0xff9E0616),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );
    }

    return RaisedButton(
        child: Text(
          "Carregar OSM nº " + numero,
          style: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 17,
            color: Color(0xffffffff),
          ),
        ),
        color: Color(0xffEE162D),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          _buscarNota();
        });
  }

  _buscarNota() async {
    db.collection("notas").document(numero).snapshots().listen((dataON) {
      dataON.data.forEach((String id, dynamic value){
        if (value != ""){
          nota = nota + id + ": " + value + "\n";
        }
      });
      setState(() {
        print("NOTA: " + nota);
        dados = dataON.data;
      });
      _isLoading = true;
    });

  }

  @override
  void initState() {
    setState(() {
      numero = widget.ordem.nun_osm;
    });
    super.initState();
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
                          "OBSERVAÇÕES: " + widget.ordem.obs,
                          style: _textStyle12(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: _nota(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
