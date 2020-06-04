import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Usuario.dart';

class People extends StatefulWidget {
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  static Firestore db = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection("usuarios").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              padding: EdgeInsets.only(top: 100),
              child: Center(
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
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar dados"),
              );
            } else {
              return Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ListView.separated(
                    // ignore: missing_return
                    separatorBuilder: (context, indice) => Divider(
                          color: Color(0xff9E0616),
                          thickness: 0.2,
                        ),
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {
                      //Recupara as ordens
                      List<DocumentSnapshot> usuarios =
                          querySnapshot.documents.toList();
                      DocumentSnapshot item = usuarios[indice];

                      var dados = item.data;
                      Usuario usuario = Usuario();
                      usuario.nome = dados["nome"];
                      usuario.sobrenome = dados["sobrenome"];
                      usuario.matricula = dados["matricula"];
                      usuario.email = dados["email"];
                      usuario.adm = dados["adm"];
                      usuario.equipe = dados["equipe"];
                      usuario.uid = item.documentID;

                      return Card(
                        elevation: 8,
                        color: Color(0xffB5B6B3),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, "/modificausuario",
                                arguments: usuario);
                          },
                          title: Text(
                            "Nome: " + item['nome'] + " " + item['sobrenome'],
                            style: TextStyle(
                              fontFamily: "EDPPreon",
                              fontSize: 15,
                              color: Color(0xff9E0616),
                            ),
                          ),
                          subtitle: Text(
                            "Equipe: " + item['equipe'],
                            style: TextStyle(
                              fontFamily: "EDPPreon",
                              fontSize: 12,
                              color: Color(0xff9E0616),
                            ),
                          ),
                          trailing: Text(
                            "ADM: " + item['adm'],
                            style: TextStyle(
                              fontFamily: "EDPPreon",
                              fontSize: 10,
                              color: Color(0xffEE162D),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
            break;
        }
      },
    );
  }
}
