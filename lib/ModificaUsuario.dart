import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:osmbtzero/model/Usuario.dart';

class ModificaUsuario extends StatefulWidget {
  Usuario usuario;
  ModificaUsuario(this.usuario);

  @override
  _ModificaUsuarioState createState() => _ModificaUsuarioState();
}

class _ModificaUsuarioState extends State<ModificaUsuario> {
  String _selectedItemEquipe;
  String _selectedItemAdm = "";
  String _selectedUID = "";
  String _selectedNome = "";
  String _selectedSobreNome = "";
  String _selectedEmail = "";
  String _selectedMatricula = "";
  String _erro = "";


 Usuario user = Usuario();

  _modificaCampos(){

    //salva os dados
    Firestore db = Firestore.instance;


    user.adm = _selectedItemAdm;
    user.uid = _selectedUID;
    user.matricula = _selectedMatricula;
    user.nome = _selectedNome;
    user.sobrenome = _selectedSobreNome;
    user.email = _selectedEmail;

    if (_selectedItemEquipe=="" || _selectedItemEquipe == null){
      user.equipe = widget.usuario.equipe;
    }else{
      user.equipe = _selectedItemEquipe;
    }

    if (_selectedItemAdm=="" || _selectedItemAdm == null){
      user.adm = widget.usuario.adm;
    }else{
      user.adm = _selectedItemAdm;
    }

    db.collection("usuarios")
  .document(_selectedUID).setData(user.toMap());


  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context) async {
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
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.usuario.nome,
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
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 100),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Sobrenome: " + widget.usuario.sobrenome,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 14,
                      color: Color(0xff9E0616),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Matrícula: " + widget.usuario.matricula,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 14,
                      color: Color(0xff9E0616),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "E-mail: " + widget.usuario.email,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "EDP Preon",
                      fontSize: 14,
                      color: Color(0xff9E0616),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 1, right: 5),
                      child: Text(
                        "Equipe: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 14,
                          color: Color(0xff9E0616),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: DropdownButton<String>(
                        elevation: 15,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        hint: Text(
                          widget.usuario.equipe,
                          style: TextStyle(
                            fontFamily: "EDP Preon",
                            fontSize: 14,
                            color: Color(0xff9E0616),
                          ),
                        ),
                        items: <String>["Adm", '1', '2', '3', '4']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 14,
                                color: Color(0xff9E0616),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.usuario.equipe = value;
                            _selectedItemEquipe = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 1, right: 20),
                      child: Text(
                        "ADM: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "EDP Preon",
                          fontSize: 14,
                          color: Color(0xff9E0616),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: DropdownButton<String>(
                        elevation: 15,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        hint: Text(
                          widget.usuario.adm,
                          style: TextStyle(
                            fontFamily: "EDP Preon",
                            fontSize: 14,
                            color: Color(0xff9E0616),
                          ),
                        ),
                        items: <String>['não', 'sim']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 14,
                                color: Color(0xff9E0616),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.usuario.adm = value;
                            _selectedItemAdm = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30),
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
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedUID = widget.usuario.uid;
                              _selectedEmail = widget.usuario.email;
                              _selectedSobreNome = widget.usuario.sobrenome;
                              _selectedNome = widget.usuario.nome;
                              _selectedMatricula = widget.usuario.matricula;
                            });
                            _modificaCampos();
                            Navigator.pushReplacementNamed(context, "/admcim");
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
