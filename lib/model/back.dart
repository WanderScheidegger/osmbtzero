import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Ordem.dart';

class back extends StatefulWidget {
  @override
  _backState createState() => _backState();
}

class _backState extends State<back> {
  static Firestore db = Firestore.instance;

  static String _dataShow = '';
  var _isVisible = true;

  _dataToString(date){
    var datalist = date.toString().split(" ")[0];
    var datas = datalist.split("-");

    return datas[2]+"/"+datas[1]+"/"+datas[0];

  }

  StreamBuilder stream = StreamBuilder(
      stream: db
          .collection("ordens")
          .where('status', isEqualTo: "Finalizada")
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
                  fontFamily: "EDPPreon",
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
                      fontFamily: "EDPPreon",
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
            //print("tamanho" + querySnapshot.documents.length.toString());
            var num = 0;
            if (querySnapshot.documents.length == 0) {
              return Card(
                elevation: 8,
                color: Color(0xffB5B6B3),
                borderOnForeground: true,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Nenhuma ordem finalizada foi programada para esta data.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "EDPPreon",
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
                      snapshot.data['data_programacao'] == _dataShow)
                          .toList();

                      //print("ordens:" + ordens.length.toString());
                      num++;
                      if (ordens.length != 0 && indice<ordens.length){
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

                        //print("indice" + indice.toString());

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
                                    fontFamily: "EDPPreon",
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
                                    fontFamily: "EDPPreon",
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
                                    fontFamily: "EDPPreon",
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
                                            fontFamily: "EDPPreon",
                                            fontSize: 9,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, "/visualizanadm",
                                              arguments: ordem);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(ordens.length==0 && num==1) {
                        return Card(
                          elevation: 8,
                          color: Color(0xffB5B6B3),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Nenhuma ordem finalizada foi programada para esta data.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "EDPPreon",
                                    fontSize: 12,
                                    color: Color(0xff9E0616),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return null;
                      }
                    }),
              );
            }
            break;
        }
      });

  @override
  void initState() {
    setState(() {
      _dataShow = _dataToString(DateTime.now());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: RaisedButton(
                child: Text(
                  "Data de programação",
                  style: TextStyle(
                    fontFamily: "EDPPreon",
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
                  setState(() {
                    _isVisible = !_isVisible;
                  });

                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2030)
                  ).then((date){
                    setState(() {
                      _dataShow = _dataToString(date);
                      _isVisible = !_isVisible;
                    });

                  });

                }),
          ),
          Visibility(
            visible: _isVisible,
            child: stream,
          ),
        ],
      ),
    );
  }
}

