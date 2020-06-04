import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/Usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _fontSizeField = 14.0;
  bool _isLoading = false;
  var _number = 20.0;


  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = "";

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length >= 6) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "A senha deve conter mais de 5 caracteres.";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Endereço de e-mail vazio ou incorreto.";
      });
    }
  }

  _logarUsuario(Usuario usuario) async {
    setState(() {
      _number = 2.0;
      _isLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
        email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      setState(() {
        _number = 20.0;
        //_isLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(context, "/loadpage", (_) => false);
    }).catchError((error) {
      setState(() {
        //print("erro app: " + error.toString());
        _mensagemErro =
        "Erro ao autenticar. Verifique o e-mail e a senha e tente novamente.";
        _number = 20.0;
        _isLoading = false;
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {

      Navigator.pushNamedAndRemoveUntil(context, "/loadpage", (_) => false);
    }
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showCIM() {
    if (!_isLoading) {
      return Text(
        "Centro Integrado de Medição",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "EDPPreon",
          fontSize: 15,
          color: Color(0xff9E0616),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffffff)),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 21),
                  child: Text(
                    "Controle de Ordens - BtZero",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "EDPPreon",
                      fontSize: 19,
                      color: Color(0xff9E0616),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: _number),
                  child: Image.asset("images/edp_logo.png",
                      width: 215, height: 175),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: showCircularProgress(),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 35),
                    child: showCIM()
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "EDPPreon",
                      fontSize: 16,
                      color: Color(0xff9E0616),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Color(0xffB5B6B3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "EDPPreon",
                    fontSize: 16,
                    color: Color(0xff9E0616),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Color(0xffB5B6B3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontFamily: "EDPPreon",
                          fontSize: 17,
                          color: Color(0xffffffff),
                        ),
                      ),
                      color: Color(0xffEE162D),
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Sem cadastro? clique aqui!",
                      style: TextStyle(
                        fontFamily: "EDPPreon",
                        fontSize: 16,
                        color: Color(0xff9E0616),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/cadastro");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        fontFamily: "EDPPreon",
                        fontSize: _fontSizeField,
                        color: Color(0xff9E0616),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}