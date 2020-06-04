import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Ordem.dart';

class AdmEmExecucao extends StatefulWidget {
  @override
  _AdmEmExecucaoState createState() => _AdmEmExecucaoState();
}

class _AdmEmExecucaoState extends State<AdmEmExecucao> {
  static Firestore db = Firestore.instance;

  //ALERT DIALOG
  static _displayDialog_Ok(BuildContext context, item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Tem certeza que deseja deletar a ordem? Todos os dados serão perdidos",
              style: TextStyle(
                fontFamily: "EDPPreon",
                fontSize: 12,
                color: Color(0xff9E0616),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Deletar'),
                onPressed: () async {
                  await db
                      .collection('ordens')
                      .document(item.documentID)
                      .delete();

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
          .where("status", isEqualTo: 'Em execução')
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
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
            if (querySnapshot.documents.length == 0) {
              return Card(
                elevation: 8,
                color: Color(0xffB5B6B3),
                borderOnForeground: true,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Não há ordens em execução ou houve um erro no carregamento. "
                            "Recarregue navegando para a aba seguinte e retornando para a aba atual.",
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
                      List<DocumentSnapshot> ordens =
                          querySnapshot.documents.toList();
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
                      ordem.status = item['status'];
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
                                    "Início: " +
                                    item['inicio'],
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
                                        "Editar",
                                        style: TextStyle(
                                          fontFamily: "EDPPreon",
                                          fontSize: 8,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, "/editanota",
                                            arguments: ordem);
                                      }),
                                  RaisedButton(
                                      child: Text(
                                        "Deletar",
                                        style: TextStyle(
                                          fontFamily: "EDPPreon",
                                          fontSize: 9,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      color: Color(0xffEE162D),
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
                    }),
              );
            }
            break;
        }
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          stream,
        ],
      ),
    );
  }
}
