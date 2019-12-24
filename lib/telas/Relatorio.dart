import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Relatorio extends StatefulWidget {
  @override
  _RelatorioState createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {

  Map<String, Map<String, dynamic>> notas = Map();
  Map<String, dynamic> salvos = Map();

  TextEditingController _controllerDataInicial = TextEditingController();
  TextEditingController __controllerDataFinal = TextEditingController();

  String _campo = "Campos disponíveis";
  String _equipe = "Escolha uma equipe";

  bool _isVisibleEquiAtrib = false;
  String _textoEquAtrib = "\nEquipamentos (Viaturas)\n";
  String _exibeEquiAtrib = "";

  bool _isVisibleEquiAdm = false;
  String _textoEquiAdm = "\nEquipamentos (ADM)\n";
  String _exibeEquiAdm = "";

  bool _isVisibleMatAtrib = false;
  String _textoMatAtrib = "\nMateriais atribuídos (Viaturas)\n";
  String _exibeMatAtrib = "";

  bool _isVisibleMatCons = false;
  String _textoMatCons = "\nMateriais consumidos (Viaturas)\n";
  String _exibeMatCons = "";

  bool _isVisibleMatConsForMon = false;
  String _textoMatConsForMon = "\nPesquisa por período\n";
  String _exibeMatConsForMon = "\n\n" + "" + "\n\n";


  //padrão de TextStyle
  _textStyle(double size) {
    return TextStyle(
      fontFamily: "EDP Preon",
      fontSize: size,
      color: Color(0xff9E0616),
    );
  }

  _carregarEquipamentos() {
    Firestore db = Firestore.instance;

    _exibeEquiAtrib = "\nEQUIPE 1 \n \n";
    db.collection("Equipe1").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {

          _exibeEquiAtrib = _exibeEquiAtrib +
              f.documentID.toString().toUpperCase() +
              " :" +
              f.data.values.toString() +
              "\n";
      });

      _exibeEquiAtrib = _exibeEquiAtrib + "\nEQUIPE 2 \n \n";
      db.collection("Equipe2").getDocuments().then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {

            _exibeEquiAtrib = _exibeEquiAtrib +
                f.documentID.toString().toUpperCase() +
                " :" +
                f.data.values.toString() +
                "\n";
        });

        _exibeEquiAtrib = _exibeEquiAtrib + "\nEQUIPE 3 \n \n";
        db.collection("Equipe3").getDocuments().then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {

            _exibeEquiAtrib = _exibeEquiAtrib +
                f.documentID.toString().toUpperCase() +
                " :" +
                f.data.values.toString() +
                "\n";
          });

          _exibeEquiAtrib = _exibeEquiAtrib + "\nEQUIPE 4 \n \n";
          db.collection("Equipe4").getDocuments().then((QuerySnapshot snapshot) {
            snapshot.documents.forEach((f) {

              _exibeEquiAtrib = _exibeEquiAtrib +
                  f.documentID.toString().toUpperCase() +
                  " :" +
                  f.data.values.toString() +
                  "\n";
            });

            setState(() {
              _exibeEquiAtrib = _exibeEquiAtrib;
            });



          });//then4
        });//then3
      });//then2
    });//then 1
  }

  _carregarEquipamentosAdm() {
    Firestore db = Firestore.instance;

    _exibeEquiAdm = "\nADM \n \n";
    db.collection("adm").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {

        _exibeEquiAdm = _exibeEquiAdm +
            f.documentID.toString().toUpperCase() +
            " :" +
            f.data.values.toString() +
            "\n";
      });
      setState(() {
        _exibeEquiAdm = _exibeEquiAdm;
      });
    });//then 1
  }

  _carregarmateriaisAtr() {
    Firestore db = Firestore.instance;
    Map<String, dynamic> materiais = Map();
    materiais['blindagem'] = 0.0;
    materiais['caboarmado'] = 0.0;
    materiais['estrangulador'] = 0.0;
    materiais['cabocobre'] = 0.0;
    materiais['alca'] = 0.0;
    materiais['conectorc'] = 0.0;
    materiais['caboip'] = 0.0;
    materiais['cintab'] = 0.0;
    materiais['sealtube'] = 0.0;
    materiais['terminaltubular'] = 0.0;
    materiais['conectorp'] = 0.0;
    materiais['cs'] = 0.0;
    materiais['placaele'] = 0.0;
    materiais['rele'] = 0.0;
    materiais['ramal'] = 0.0;

    db.collection("materiais_atribuidos").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var equipe = f.documentID.toString();

        materiais['blindagem'] += f.data['blindagem'];
        materiais['caboarmado'] += f.data['caboarmado'];
        materiais['estrangulador'] += f.data['estrangulador'];
        materiais['cabocobre'] += f.data['cabocobre'];
        materiais['alca'] += f.data['alca'];
        materiais['conectorc'] += f.data['conectorc'];
        materiais['caboip'] += f.data['caboip'];
        materiais['cintab'] += f.data['cintab'];
        materiais['sealtube'] += f.data['sealtube'];
        materiais['terminaltubular'] += f.data['terminaltubular'];
        materiais['conectorp'] += f.data['conectorp'];
        materiais['cs'] += f.data['cs'];
        materiais['placaele'] += f.data['placaele'];
        materiais['rele'] += f.data['rele'];
        materiais['ramal'] += f.data['ramal'];

        _exibeMatAtrib = _exibeMatAtrib + "\nEQUIPE $equipe \n \n";

        f.data.forEach((String id, dynamic valor){

          _exibeMatAtrib = _exibeMatAtrib +
          id + ": " + valor.toString() + "\n";
        });
      });

      _exibeMatAtrib = _exibeMatAtrib + "\nTOTAIS \n \n";
      materiais.forEach((String id, dynamic valor){
        _exibeMatAtrib = _exibeMatAtrib +
            id + ": " + valor.toString() + "\n";
      });

      setState(() {
        _exibeMatAtrib = _exibeMatAtrib;
      });
      print(materiais.toString());
    });//then 1

  }

  _carregarmateriaisCons() {
    Firestore db = Firestore.instance;

    Map<String, dynamic> materiais = Map();
    materiais['blindagem'] = 0.0;
    materiais['caboarmado'] = 0.0;
    materiais['estrangulador'] = 0.0;
    materiais['cabocobre'] = 0.0;
    materiais['alca'] = 0.0;
    materiais['conectorc'] = 0.0;
    materiais['caboip'] = 0.0;
    materiais['cintab'] = 0.0;
    materiais['sealtube'] = 0.0;
    materiais['terminaltubular'] = 0.0;
    materiais['conectorp'] = 0.0;
    materiais['cs'] = 0.0;
    materiais['placaele'] = 0.0;
    materiais['rele'] = 0.0;
    materiais['ramal'] = 0.0;

    db.collection("materiais_consumidos").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var equipe = f.documentID.toString();
        materiais['blindagem'] += f.data['blindagem'];
        materiais['caboarmado'] += f.data['caboarmado'];
        materiais['estrangulador'] += f.data['estrangulador'];
        materiais['cabocobre'] += f.data['cabocobre'];
        materiais['alca'] += f.data['alca'];
        materiais['conectorc'] += f.data['conectorc'];
        materiais['caboip'] += f.data['caboip'];
        materiais['cintab'] += f.data['cintab'];
        materiais['sealtube'] += f.data['sealtube'];
        materiais['terminaltubular'] += f.data['terminaltubular'];
        materiais['conectorp'] += f.data['conectorp'];
        materiais['cs'] += f.data['cs'];
        materiais['placaele'] += f.data['placaele'];
        materiais['rele'] += f.data['rele'];
        materiais['ramal'] += f.data['ramal'];

        _exibeMatCons = _exibeMatCons + "\nEQUIPE $equipe \n \n";
        f.data.forEach((String id, dynamic valor){
          _exibeMatCons = _exibeMatCons +
              id + ": " + valor.toString() + "\n";
        });
      });

      _exibeMatCons = _exibeMatCons + "\nTOTAIS \n \n";
      materiais.forEach((String id, dynamic valor){
        _exibeMatCons = _exibeMatCons +
            id + ": " + valor.toString() + "\n";
      });

      setState(() {
        _exibeMatCons = _exibeMatCons;
      });
    });//then 1
  }

  _carregarmateriaisConsForMon(initial_data, final_data, equipe, campo) {

    var inicial = _formataStringData(initial_data);
    var dataIni = DateTime(inicial[2], inicial[1], inicial[0]);

    var finald = _formataStringData(final_data);
    var dataFim = DateTime(finald[2], finald[1], finald[0]);

  //
    var _material_ramal = 0.0;
    var _material_caboip = 0.0;
    var _material_conectorp = 0.0;
    var _material_cs = 0.0;
    var _material_caboarmado = 0.0;
    var _material_conectorc = 0.0;
    var _material_terminaltubular = 0.0;
    var _material_sealtube = 0.0;
    var _material_blindagem = 0.0;
    var _material_estrangulador = 0.0;
    var _material_cabocobre = 0.0;
    var _material_placaele = 0.0;
    var _material_rele = 0.0;
    var _material_alca = 0.0;
    var _material_cintabap3 = 0.0;
    var _num_clandestinas = 0.0;
    var _tempo_atend = 0.0;

    var _num_nota;
    var _data_realiza;
    var _inicio;
    var _termino;
    var _num_tempo = List();
    var _status_exec = List();
    var _medidor_inst = List();
    var _medidor_ret = List();
    var _cpu_inst = List();
    var _cpu_ret = List();
    var _cpu_cp_inst = List();
    var _cpu_cp_ret = List();
    var _radio_inst = List();
    var _radio_ret = List();
    var _display_inst = List();
    var _display_ret = List();
    var _ip_inst = List();
    var _ip_ret = List();
    var _cp_inst = List();
    var _cp_ret = List();
    var _remota_inst = List();
    var _ssn_inst = List();
    var _remota_ret = List();
    var _ssn_ret = List();


    //percorre as notas
    notas.forEach((String numero, Map<String, dynamic> dados){

      var data = dados['data_realiza'];
      var dataint = _formataStringData(data);
      var dataTime = DateTime(dataint[2], dataint[1], dataint[0]);

      var eq_exec = dados['eq_exec'];

      if ( (dataTime.isAtSameMomentAs(dataIni) || dataTime.isAfter(dataIni)) &&
          (dataTime.isAtSameMomentAs(dataFim) || dataTime.isBefore(dataFim))) {


        if (equipe.split(' ')[1] == eq_exec){

          _material_ramal += double.tryParse(dados['ramal']);
          _material_caboip += double.tryParse(dados['caboip']);
          _material_conectorp += double.tryParse(dados['conectorp']);
          _material_cs += double.tryParse(dados['cs']);
          _material_caboarmado += double.tryParse(dados['caboarmado']);
          _material_conectorc += double.tryParse(dados['conectorc']);
          _material_terminaltubular += double.tryParse(dados['terminaltubular']);
          _material_sealtube += double.tryParse(dados['sealtube']);
          _material_blindagem += double.tryParse(dados['blindagem']);
          _material_estrangulador += double.tryParse(dados['estrangulador']);
          _material_cabocobre += double.tryParse(dados['cabocobre']);
          _material_placaele += double.tryParse(dados['placaele']);
          _material_rele += double.tryParse(dados['rele']);
          _material_alca += double.tryParse(dados['alca']);
          _material_cintabap3 += double.tryParse(dados['cintab']);
          _num_clandestinas += double.tryParse(dados['num_clandestinas']);
          _tempo_atend += double.tryParse(dados['tempo_atend']);


          if (dados['tempo_atend']!=""){
            _num_tempo.add(dados['tempo_atend']);
          }
          if (dados['status_exec']!=""){
            _status_exec.add(dados['status_exec']);
          }
          if (dados['medidor_inst']!=""){
            _medidor_inst.add(dados['medidor_inst']);
          }
          if (dados['medidor_ret']!=""){
            _medidor_ret.add(dados['medidor_ret']);
          }
          if (dados['cpu_inst']!=""){
            _cpu_inst.add(dados['cpu_inst']);
          }
          if (dados['cpu_ret']!=""){
            _cpu_ret.add(dados['cpu_ret']);
          }
          if (dados['cpu_cp_inst']!=""){
            _cpu_cp_inst.add(dados['cpu_cp_inst']);
          }
          if (dados['cpu_cp_ret']!=""){
            _cpu_cp_ret.add(dados['cpu_cp_ret']);
          }
          if (dados['radio_inst']!=""){
            _radio_inst.add(dados['radio_inst']);
          }
          if (dados['radio_ret']!=""){
            _radio_ret.add(dados['radio_ret']);
          }
          if (dados['display_inst']!=""){
            _display_inst.add(dados['display_inst']);
          }
          if (dados['display_ret']!=""){
            _display_ret.add(dados['display_ret']);
          }
          if (dados['ip_inst']!=""){
            _ip_inst.add(dados['ip_inst']);
          }
          if (dados['ip_ret']!=""){
            _ip_ret.add(dados['ip_ret']);
          }
          if (dados['cp_inst']!=""){
            _cp_inst.add(dados['cp_inst']);
          }
          if (dados['cp_ret']!=""){
            _cp_ret.add(dados['cp_ret']);
          }
          if (dados['remota_inst']!=""){
            _remota_inst.add(dados['remota_inst']);
          }
          if (dados['ssn_inst']!=""){
            _ssn_inst.add(dados['ssn_inst']);
          }
          if (dados['remota_ret']!=""){
            _remota_ret.add(dados['remota_ret']);
          }
          if (dados['ssn_ret']!=""){
            _ssn_ret.add(dados['ssn_ret']);
          }


        }else if (equipe.split(' ')[1] == 'as'){
          print("entrou em todas");

          _material_ramal += double.tryParse(dados['ramal']);
          _material_caboip += double.tryParse(dados['caboip']);
          _material_conectorp += double.tryParse(dados['conectorp']);
          _material_cs += double.tryParse(dados['cs']);
          _material_caboarmado += double.tryParse(dados['caboarmado']);
          _material_conectorc += double.tryParse(dados['conectorc']);
          _material_terminaltubular += double.tryParse(dados['terminaltubular']);
          _material_sealtube += double.tryParse(dados['sealtube']);
          _material_blindagem += double.tryParse(dados['blindagem']);
          _material_estrangulador += double.tryParse(dados['estrangulador']);
          _material_cabocobre += double.tryParse(dados['cabocobre']);
          _material_placaele += double.tryParse(dados['placaele']);
          _material_rele += double.tryParse(dados['rele']);
          _material_alca += double.tryParse(dados['alca']);
          _material_cintabap3 += double.tryParse(dados['cintab']);
          _num_clandestinas += double.tryParse(dados['num_clandestinas']);
          _tempo_atend += double.tryParse(dados['tempo_atend']);


          if (dados['tempo_atend']!=""){
            _num_tempo.add(dados['tempo_atend']);
          }
          if (dados['status_exec']!=""){
            _status_exec.add(dados['status_exec']);
          }
          if (dados['medidor_inst']!=""){
            _medidor_inst.add(dados['medidor_inst']);
          }
          if (dados['medidor_ret']!=""){
            _medidor_ret.add(dados['medidor_ret']);
          }
          if (dados['cpu_inst']!=""){
            _cpu_inst.add(dados['cpu_inst']);
          }
          if (dados['cpu_ret']!=""){
            _cpu_ret.add(dados['cpu_ret']);
          }
          if (dados['cpu_cp_inst']!=""){
            _cpu_cp_inst.add(dados['cpu_cp_inst']);
          }
          if (dados['cpu_cp_ret']!=""){
            _cpu_cp_ret.add(dados['cpu_cp_ret']);
          }
          if (dados['radio_inst']!=""){
            _radio_inst.add(dados['radio_inst']);
          }
          if (dados['radio_ret']!=""){
            _radio_ret.add(dados['radio_ret']);
          }
          if (dados['display_inst']!=""){
            _display_inst.add(dados['display_inst']);
          }
          if (dados['display_ret']!=""){
            _display_ret.add(dados['display_ret']);
          }
          if (dados['ip_inst']!=""){
            _ip_inst.add(dados['ip_inst']);
          }
          if (dados['ip_ret']!=""){
            _ip_ret.add(dados['ip_ret']);
          }
          if (dados['cp_inst']!=""){
            _cp_inst.add(dados['cp_inst']);
          }
          if (dados['cp_ret']!=""){
            _cp_ret.add(dados['cp_ret']);
          }
          if (dados['remota_inst']!=""){
            _remota_inst.add(dados['remota_inst']);
          }
          if (dados['ssn_inst']!=""){
            _ssn_inst.add(dados['ssn_inst']);
          }
          if (dados['remota_ret']!=""){
            _remota_ret.add(dados['remota_ret']);
          }
          if (dados['ssn_ret']!=""){
            _ssn_ret.add(dados['ssn_ret']);
          }

        }

      }

    });

    salvos['Materiais'] = "RAMAL: $_material_ramal\n"
        "CABO IP: $_material_caboip\n"
        "CONECTOR PERFURANTE: $_material_conectorp\n"
        "CS: $_material_cs\n"
        "CABO ARMADO: $_material_caboarmado\n"
        "CONECTOR CUNHA: $_material_conectorc\n"
        "TERMINAL TUBULAR: $_material_terminaltubular\n"
        "SEAL TUBE: $_material_sealtube\n"
        "BLINDAGEM TRAFO: $_material_blindagem\n"
        "ESTRANGULADOR: $_material_estrangulador\n"
        "CABO COBRE: $_material_cabocobre\n"
        "PLACA ELETRÔNICA NG: $_material_placaele\n"
        "RELÉ: $_material_rele\n"
        "ALÇA: $_material_alca\n"
        "CINTA BAP-3: $_material_cintabap3";

    var executado = 0;
    var parcial = 0;
    var cancelado = 0;

    _status_exec.forEach((status){
      switch(status){
        case "Executado":
          executado += 1;
          break;
        case "Parcial":
          parcial += 1;
          break;
        case "Cancelado":
          cancelado += 1;
          break;

      }
    });

    salvos['Status'] = "Executados: $executado \n Parcial: $parcial \n Cancelado: $cancelado";
    salvos['Medidores instalados'] = _medidor_inst.length.toString() + "\nmedidores instalados";
    salvos['Medidores retirados'] = _medidor_ret.length.toString() + "\nmedidores retirados";
    salvos['CPUs instalados'] = _cpu_inst.length.toString() + "\nCPUs instalados";
    salvos['CPUs retirados'] = _cp_ret.length.toString() + "\nCPUs retirados";
    salvos['Rádios instalados'] = _radio_inst.length.toString() + "\nRádios instalados";
    salvos['Rádios retirados'] = _radio_ret.length.toString() + "\nRádios retirados";
    salvos['Display instalados'] = _display_inst.length.toString() + "\nDisplay instalados";
    salvos['Display retirados'] = _display_ret.length.toString() + "\nDisplay retirados";
    salvos['Sensores IP instalados'] = _ip_inst.length.toString() + "\nSensores IP instalados";
    salvos['Sensores IP retirados'] = _ip_ret.length.toString() + "\nSensores IP retirados";
    salvos['CPs instalados'] = _cp_inst.length.toString() + "\nCPs instalados";
    salvos['CPs retirados'] = _cpu_ret.length.toString() + "\nCPs retirados";
    salvos['Remotas instaladas'] = _remota_inst.length.toString() + "\nRemotas instaladas";
    salvos['Remotas retiradas'] = _remota_ret.length.toString() + "\nRemotas retiradas";
    salvos['Cpus de CP instaladas'] = _cpu_cp_inst.length.toString() + "\nCpus de CP instaladas";
    salvos['Cpus de CP retiradas'] = _cpu_cp_ret.length.toString() + "\nCpus de CP retiradas";
    salvos['Sim Cards instalados'] = _ssn_inst.length.toString() + "\nSim Cards instalados";
    salvos['Sim Cards retirados'] = _ssn_ret.length.toString() + "\nSim Cards retirados";


    salvos['Tempo médio de \n atendimento em minutos'] = (_tempo_atend / _num_tempo.length).toStringAsFixed(1) + " minutos";
    salvos['Clandestinas retiradas'] = _num_clandestinas.toString() + " clandestinas \n retiradas";


    salvos.forEach((String titulo, dynamic valor){

      if (titulo==campo){
        setState(() {
            _exibeMatConsForMon = "\n\n" + valor.toString() + "\n\n";

        });
      }

    });


  }

  _formataStringData(string_data){

    var data = string_data.split('/');
    var dia = int.parse(data[0]);
    var mes = int.parse(data[1]);
    var ano = int.parse(data[2]);

    var dataint = [dia, mes, ano];

    return dataint;
  }

  _carregaNotas() async{
    Firestore db = Firestore.instance;
    db.collection("notas").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        notas[f.documentID]=f.data;

      });
      setState(() {
        notas = notas;
      });

    });//then 1
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

  @override
  void initState() {
    _carregaNotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Relatórios",
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
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "\n Escolha uma opção de Relatório",
                  style: _textStyle(16.0),
                  textAlign: TextAlign.left,
                ),
              ),
              //-----------------------Equipamentos viaturas -------------------
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoEquAtrib,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleEquiAtrib = !_isVisibleEquiAtrib;
                          _exibeEquiAtrib = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleEquiAtrib,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeEquiAtrib,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
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
                                  _carregarEquipamentos();
                                }),
                          ),
                        ],
                      ),
                    ),

                    //------------------ Equipamentos Adm-----------------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoEquiAdm,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleEquiAdm = !_isVisibleEquiAdm;
                          _exibeEquiAdm = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleEquiAdm,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeEquiAdm,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
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
                                  _carregarEquipamentosAdm();
                                }),
                          ),
                        ],
                      ),
                    ),
                    //------------------ Materiais Atribuídos-------------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoMatAtrib,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleMatAtrib = !_isVisibleMatAtrib;
                          _exibeMatAtrib = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleMatAtrib,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeMatAtrib,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
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
                                  _carregarmateriaisAtr();
                                }),
                          ),
                        ],
                      ),
                    ),
                    //------------------ Materiais Consumidos-------------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoMatCons,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleMatCons = !_isVisibleMatCons;
                          _exibeMatCons = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleMatCons,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeMatCons,
                              style: _textStyle(13.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: RaisedButton(
                                child: Text(
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
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
                                  _carregarmateriaisCons();
                                }),
                          ),
                        ],
                      ),
                    ),
                    //-------------- Materiais Consumidos por mês --------------
                    Divider(
                      thickness: 0.5,
                      color: Color(0xffB5B6B3),
                    ),
                    GestureDetector(
                      child: Text(
                        _textoMatConsForMon,
                        style: _textStyle(14.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _isVisibleMatConsForMon = !_isVisibleMatConsForMon;
                          _exibeMatConsForMon = "";
                        });
                      },
                    ),
                    Visibility(
                      visible: _isVisibleMatConsForMon,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _exibeMatConsForMon,
                              style: _textStyle(14.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Escolha os campos abaixo...",
                              style: _textStyle(13.0),
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
                                _campo,
                                style: _textStyle(13.0),
                              ),
                              items: <String>["Materiais", "Medidores instalados", "Medidores retirados",
                                "CPUs instalados", "CPUs retirados",
                                "Rádios instalados", "Rádios retirados", "Display instalados", "Display retirados",
                                "Sensores IP instalados", "Sensores IP retirados", "CPs instalados", "CPs retirados",
                                "Remotas instaladas", "Remotas retiradas", "Cpus de CP instaladas",
                                "Cpus de CP retiradas", "Sim Cards instalados", "Sim Cards retirados", "Status",
                                "Tempo médio de \n atendimento em minutos", "Clandestinas retiradas" ]
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: _textStyle(13.0),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _campo = value;
                                  _exibeMatConsForMon = "\n\n" + "" + "\n\n";
                                });
                              },
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
                                style: _textStyle(13.0),
                              ),
                              items: <String>["Equipe 1", "Equipe 2", "Equipe 3", "Equipe 4", "Todas as equipes"]
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: _textStyle(13.0),
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
                            child: TextField(
                              controller: _controllerDataInicial,
                              keyboardType: TextInputType.datetime,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 13,
                                color: Color(0xff9E0616),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Data inicial - (dd/mm/aaaa)",
                                filled: true,
                                fillColor: Color(0xffB5B6B3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: TextField(
                              controller: __controllerDataFinal,
                              keyboardType: TextInputType.datetime,
                              style: TextStyle(
                                fontFamily: "EDP Preon",
                                fontSize: 13,
                                color: Color(0xff9E0616),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Data final - (dd/mm/aaaa)",
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
                                  "Carregar",
                                  style: TextStyle(
                                    fontFamily: "EDP Preon",
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


                                  RegExp regExp = new RegExp(r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$');

                                  if (_equipe!= "Escolha uma equipe" && _campo!="Campos disponíveis" &&
                                  _controllerDataInicial.text.isNotEmpty && __controllerDataFinal.text.isNotEmpty &&
                                      regExp.hasMatch(_controllerDataInicial.text) &&
                                      regExp.hasMatch(__controllerDataFinal.text)){
                                    _carregarmateriaisConsForMon(
                                        _controllerDataInicial.text,
                                        __controllerDataFinal.text, _equipe, _campo);
                                  }else{
                                    if (!regExp.hasMatch(_controllerDataInicial.text) ||
                                        !regExp.hasMatch(__controllerDataFinal.text)){
                                      _displayDialogCancel(context, "Preencha as datas no formato dd/mm/aaaa");
                                    }
                                    _displayDialogCancel(context, "Preencha todos os campos para realizar a pesquisa");
                                  }

                                }),
                          ),
                        ],
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
