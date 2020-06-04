import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:osmbtzero/model/Nota.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/Ordem.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class FinalizaNota extends StatefulWidget {
  Ordem ordem;
  FinalizaNota(this.ordem);

  @override
  _FinalizaNotaState createState() => _FinalizaNotaState();
}

class _FinalizaNotaState extends State<FinalizaNota> {
  String _equipeLogado = "sem equipe";
  Map<String, dynamic> _equipamentos = Map();
  Map<String, dynamic> _materiaisCons = Map();
  Map<String, dynamic> _materiaisAtrib = Map();

  Color _coriconexec = Colors.white;
  Color _coriconparc = Colors.white;
  Color _coriconcanc = Colors.white;

  bool _isVisibleOrdem = false;
  bool _isVisibleMedidores = false;
  bool _isVisibleCpus = false;
  bool _isVisibleRadio = false;
  bool _isVisibleDisplay = false;
  bool _isVisibleSensorIp = false;
  bool _isVisibleCp = false;
  bool _isVisibleCpuCp = false;
  bool _isVisibleRemota = false;
  bool _isVisibleSsn = false;

  bool _isVisibleObs = false;
  bool _isVisibleMateriais = false;
  bool _isVisibleClandestinas = false;

  String _textoVisOrdem = "Visualizar os dados da ordem";
  String _textoVisMedidor = "\n Clique aqui para editar MEDIDOR";
  String _textoVisCpu = "\n Clique aqui para editar CPU de Cs";
  String _textoVisRadio = "\n Clique aqui para editar RÁDIO";
  String _textoVisDisplay = "\n Clique aqui para editar DISPLAY";
  String _textoVisSensorIp = "\n Clique aqui para editar SENSOR IP";
  String _textoVisCp = "\n Clique aqui para editar CP";
  String _textoVisRemota = "\n Clique aqui para editar REMOTA";
  String _textoVisSsn = "\n Clique aqui para editar SSN";

  String _textoVisObs = "\n Clique aqui para editar OBSERVAÇÔES";
  String _textoVisMateriais = "\n Clique aqui para editar MATERIAIS";
  String _textoVisClandestinas = "\n Clique aqui para editar CLANDESTINAS";

  String _textoVisCpuCps = "\n Clique aqui para editar CPU de CP";

  String _textoMateriais = "RAMAL:0.0\n"
      "CABO IP:0.0\n"
      "CONECTOR PERFURANTE:0.0\n"
      "CS:0.0\n"
      "CABO ARMADO:0.0\n"
      "CONECTOR CUNHA:0.0\n"
      "TERMINAL TUBULAR:0.0\n"
      "SEAL TUBE:0.0\n"
      "BLINDAGEM TRAFO:0.0\n"
      "ESTRANGULADOR:0.0\n"
      "CABO COBRE:0.0\n"
      "PLACA ELETRÔNICA NG:0.0\n"
      "RELÉ:0.0\n"
      "ALÇA:0.0\n"
      "CINTA BAP-3:0.0";

  String _hintStatusExec = "";
  String _hintMedidorInst = "Medidor instalado";
  String _hintCpuInst = "Cpu de cs instalada";
  String _hintRadioInst = "Rádio instalado";
  String _hintDisplayInst = "Display instalado";
  String _hintSensorIpInst = "Sensor IP instalado";
  String _hintCpIpInst = "CP instalado";
  String _hintRemotaInst = "REMOTA instalado";
  String _hintSsn = "Sim card instalado";
  String _hintCpuCpInst = "Cpu de CP instalada";

  String _preenchidos = "";

  TextEditingController _controllerLeitMedInst = TextEditingController();
  TextEditingController _controllerPosMedInst = TextEditingController();
  TextEditingController _controllerMedRet = TextEditingController();
  TextEditingController _controllerLeitMedRet = TextEditingController();
  TextEditingController _controllerPosMedRet = TextEditingController();
  TextEditingController _controllerCpuInst = TextEditingController();
  TextEditingController _controllerCpuRet = TextEditingController();
  TextEditingController _controllerRadioInst = TextEditingController();
  TextEditingController _controllerRadioRet = TextEditingController();
  TextEditingController _controllerDisplayInst = TextEditingController();
  TextEditingController _controllerDisplayRet = TextEditingController();
  TextEditingController _controllerSensorIpInst = TextEditingController();
  TextEditingController _controllerSensorIpRet = TextEditingController();
  TextEditingController _controllerCPInst = TextEditingController();
  TextEditingController _controllerCPRet = TextEditingController();
  TextEditingController _controllerObs = TextEditingController();
  TextEditingController _controllerRemotaInst = TextEditingController();
  TextEditingController _controllerSsnInst = TextEditingController();
  TextEditingController _controllerRemotaRet = TextEditingController();
  TextEditingController _controllerSsnRet = TextEditingController();
  TextEditingController _controllerMateriais = TextEditingController();
  TextEditingController _controllerMedidorInst = TextEditingController();
  TextEditingController _controllerCpuCPInst = TextEditingController();
  TextEditingController _controllerCpuCPRet = TextEditingController();

  //var listStatusExec = ['Parcial', 'Executado', 'Cancelado'];
  List<String> listMedInst = [];
  List<String> listCpuInst = [];
  List<String> listRadioInst = [];
  List<String> listDisplay = [];
  List<String> listSensorIp = [];
  List<String> listCp = [];
  List<String> listRemota = [];
  List<String> listSinCard = [];
  List<String> listCpuCpInst = [];

  ProgressDialog pr;

  var ramal = 0.0;
  var caboip = 0.0;
  var conectorp = 0.0;
  var cs = 0.0;
  var caboarmado = 0.0;
  var conectorc = 0.0;
  var terminaltubular = 0.0;
  var sealtube = 0.0;
  var blindagem = 0.0;
  var estrangulador = 0.0;
  var cabocobre = 0.0;
  var placaele = 0.0;
  var rele = 0.0;
  var alca = 0.0;
  var cintab = 0.0;

  var clandestinas = 0;

  List<String> _suggestedMedidores = [];
  _onChangedMedidores(String value) {
    _suggestedMedidores = listMedInst
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedMedidores;
  }

  List<String> _suggestedCpus = [];
  _onChangedCpus(String value) {
    _suggestedCpus = listCpuInst
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedCpus;
  }

  List<String> _suggestedRadios = [];
  _onChangedRadios(String value) {
    _suggestedRadios = listRadioInst
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedRadios;
  }

  List<String> _suggestedDisplays = [];
  _onChangedDisplays(String value) {
    _suggestedDisplays = listDisplay
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedDisplays;
  }

  List<String> _suggestedSensoresIp = [];
  _onChangedSensoresIp(String value) {
    _suggestedSensoresIp = listSensorIp
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedSensoresIp;
  }

  List<String> _suggestedCp = [];
  _onChangedCps(String value) {
    _suggestedCp = listCp
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedCp;
  }

  List<String> _suggestedRemota = [];
  _onChangedRemotas(String value) {
    _suggestedRemota = listRemota
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedRemota;
  }

  List<String> _suggestedSsn = [];
  _onChangedSsns(String value) {
    _suggestedSsn = listSinCard
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedSsn;
  }

  List<String> _suggestedCpuCp = [];
  _onChangedCpuCp(String value) {
    _suggestedCpuCp = listCpuCpInst
        .where((string) => string.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return _suggestedCpuCp;
  }

  _carregaEquipamentos() {

    Firestore db = Firestore.instance;
    db
        .collection("Equipe" + _equipeLogado)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        _equipamentos[f.documentID.toString()] = f.data.values.toList();
      });
      //medidores
      _equipamentos['medidores'].forEach((f) {
        listMedInst.add(f.toString());
      });
      //Cpus
      _equipamentos['cpus'].forEach((f) {
        listCpuInst.add(f.toString());
      });
      //Radios
      _equipamentos['radios'].forEach((f) {
        listRadioInst.add(f.toString());
      });
      //Radios
      _equipamentos['displays'].forEach((f) {
        listDisplay.add(f.toString());
      });
      //Sensores Ip
      _equipamentos['sensoresip'].forEach((f) {
        listSensorIp.add(f.toString());
      });
      //Cps
      _equipamentos['cps'].forEach((f) {
        listCp.add(f.toString());
      });
      //Remotas
      _equipamentos['remotas'].forEach((f) {
        listRemota.add(f.toString());
      });
      //Ssns
      _equipamentos['ssns'].forEach((f) {
        listSinCard.add(f.toString());
      });
      //CpusCp
      _equipamentos['cpuscp'].forEach((f) {
        listCpuCpInst.add(f.toString());
      });

    }).catchError((onError) {
      //print("Erro ao carregar os materiais." + onError.toString());
    });
  }


  _carregaMaterias(){
    Firestore db = Firestore.instance;
    db.collection("materiais_consumidos")
        .getDocuments()
        .then((QuerySnapshot snapshot){
      snapshot.documents.forEach((f){
        if (f.documentID == _equipeLogado) {
          //print("DDDDD:" + f.data.toString());
          _materiaisCons.addAll(f.data);
        }

      });//foreach
      _carregaMateriasAtrib();
    });//then

  }

  _carregaMateriasAtrib(){
    Firestore db = Firestore.instance;
    db.collection("materiais_atribuidos")
        .getDocuments()
        .then((QuerySnapshot snapshot){
      snapshot.documents.forEach((f){
        if (f.documentID == _equipeLogado) {
          //print("DDDDD:" + f.data.toString());
          _materiaisAtrib.addAll(f.data);
        }

      });//foreach

    });//then

  }

  _stringToDateTime(string) {
    var recorte = string.split(" - ");
    var data = recorte[0].split("/");
    var hora = recorte[1].split(":");

    return DateTime(int.tryParse(data[2]), int.tryParse(data[1]),
        int.tryParse(data[0]), int.tryParse(hora[0]), int.tryParse(hora[1]));
  }

  _calculaTempo(inicio, termino, formato) {
    DateTime Tinicio = _stringToDateTime(inicio);
    DateTime Tfinal = _stringToDateTime(termino);

    if (formato == 1) {
      return Tfinal.difference(Tinicio).inMinutes;
    } else if (formato == 2) {
      return Tfinal.difference(Tinicio).inHours;
    }
  }

  //padrão de TextStyle
  _textStyle14() {
    return TextStyle(
      fontFamily: "EDPPreon",
      fontSize: 14,
      color: Color(0xff9E0616),
    );
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

  /*
  _salvarSql(Nota nota) async{
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = p.join(caminhoBancoDados, "banco.db");
    //cria o banco
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE IF NOT EXISTS notas "
              "(num_nota VARCHAR, "
              "data_realiza VARCHAR, inicio VARCHAR, termino VARCHAR, "
              "status_exec VARCHAR, medidor_inst VARCHAR, "
              "medidor_ret VARCHAR, leitura_inst VARCHAR, "
              "leitura_ret VARCHAR, posicao_inst VARCHAR, "
              "posicao_ret VARCHAR, cpu_inst VARCHAR, "
              "cpu_ret VARCHAR, radio_inst VARCHAR, "
              "radio_ret VARCHAR, display_inst VARCHAR, "
              "display_ret VARCHAR, ip_inst VARCHAR, "
              "cp_inst VARCHAR, cp_ret VARCHAR, "
              "obs VARCHAR, tempo_atend VARCHAR"
              ") ";
          db.execute(sql);
        }
    );
    List num = await bd.rawQuery("SELECT * FROM notas WHERE num_nota = ?", [nota.num_nota]);
    print("tamanho" + num.length.toString() + "  " + nota.num_nota);
      //insere os valores
    await bd.insert("notas", nota.toMap());
    //listar
    List notas = await bd.rawQuery("SELECT * FROM notas");
    for (var n in notas){
      print("numero da nota: " + n['num_nota']);
    }
  }
   */

  _atribuiQuant(){

    var dadosCons = {
      "cs": cs + _materiaisCons['cs'],
      "ramal": ramal + _materiaisCons['ramal'],
      "caboip": caboip + _materiaisCons['caboip'],
      "conectorp": conectorp + _materiaisCons['conectorp'],
      "conectorc": conectorc + _materiaisCons['conectorc'],
      "caboarmado": caboarmado + _materiaisCons['caboarmado'],
      "terminaltubular": terminaltubular + _materiaisCons['terminaltubular'],
      "sealtube":sealtube + _materiaisCons['sealtube'],
      "blindagem":blindagem + _materiaisCons['blindagem'],
      "estrangulador": estrangulador + _materiaisCons['estrangulador'],
      "cabocobre": cabocobre + _materiaisCons['cabocobre'],
      "placaele": placaele + _materiaisCons['placaele'],
      "rele": rele + _materiaisCons['rele'],
      "alca": alca + _materiaisCons['alca'],
      "cintab": cintab + _materiaisCons['cintab']
    };

    var dadosAtrib = {
      "cs": _materiaisAtrib['cs'] - cs,
      "ramal": _materiaisAtrib['ramal'] - ramal,
      "caboip": _materiaisAtrib['caboip'] - caboip,
      "conectorp": _materiaisAtrib['conectorp'] - conectorp,
      "conectorc": _materiaisAtrib['conectorc'] - conectorc,
      "caboarmado": _materiaisAtrib['caboarmado'] - caboarmado,
      "terminaltubular": _materiaisAtrib['terminaltubular'] - terminaltubular,
      "sealtube": _materiaisAtrib['sealtube'] - sealtube,
      "blindagem": _materiaisAtrib['blindagem'] - blindagem,
      "estrangulador": _materiaisAtrib['estrangulador'] - estrangulador,
      "cabocobre": _materiaisAtrib['cabocobre'] - cabocobre,
      "placaele": _materiaisAtrib['placaele'] - placaele,
      "rele": _materiaisAtrib['rele'] - rele,
      "alca": _materiaisAtrib['alca'] - alca,
      "cintab": _materiaisAtrib['cintab'] - cintab
    };

    //print("DDD: " + dadosCons.toString());

    Firestore db = Firestore.instance;
    db
        .collection("materiais_consumidos")
        .document(_equipeLogado)
        .updateData(dadosCons)
        .then((onValue){
        //print("DDDD: " + dadosCons.toString());

        db
            .collection("materiais_atribuidos")
            .document(_equipeLogado)
            .updateData(dadosAtrib)
            .then((onValue){
          //print("DDDD: " + dadosAtrib.toString());

        });//then

    });//then

  }

  _modificaEquipamentos(){

    Firestore db = Firestore.instance;
    //medidor
    if (_controllerMedidorInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document("medidores")
          .updateData({_controllerMedidorInst.text: FieldValue.delete()});

    }
    if (_controllerMedRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("medidores")
          .updateData({_controllerMedRet.text: _controllerMedRet.text});
    }
    //--------------------------------------------------------------------------
    //CPU
    if (_controllerCpuInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document("cpus")
          .updateData({_controllerCpuInst.text: FieldValue.delete()});
    }

    if (_controllerCpuRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("cpus")
          .updateData({_controllerCpuRet.text: _controllerCpuRet.text});
    }
    //--------------------------------------------------------------------------
    //CP
    if (_controllerCPInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document('cps')
          .updateData({_controllerCPInst.text: FieldValue.delete()});
    }
    if (_controllerCPRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("cps")
          .updateData({_controllerCPRet.text: _controllerCPRet.text});
    }
    //--------------------------------------------------------------------------
    //SSN
    if (_controllerSsnInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document('ssns')
          .updateData({_controllerSsnInst.text: FieldValue.delete()});
    }
    if (_controllerSsnRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("ssns")
          .updateData({_controllerSsnRet.text: _controllerSsnRet.text});
    }
    //--------------------------------------------------------------------------
    //REMOTA
    if (_controllerRemotaInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document('remotas')
          .updateData({_controllerRemotaInst.text: FieldValue.delete()});
    }
    if (_controllerRemotaRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("remotas")
          .updateData({_controllerRemotaRet.text: _controllerRemotaRet.text});
    }
    //--------------------------------------------------------------------------
    //SENSOR IP
    if (_controllerSensorIpInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document('sensoresip')
          .updateData({_controllerSensorIpInst.text: FieldValue.delete()});
    }
    if (_controllerSensorIpRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("sensoresip")
          .updateData({_controllerSensorIpRet.text: _controllerSensorIpRet.text});
    }
    //--------------------------------------------------------------------------
    //DISPLAY
    if (_controllerDisplayInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document('displays')
          .updateData({_controllerDisplayInst.text: FieldValue.delete()});
    }
    if (_controllerDisplayRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("displays")
          .updateData({_controllerDisplayRet.text: _controllerDisplayRet.text});
    }
    //--------------------------------------------------------------------------
    //RADIO
    if (_controllerRadioInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document('radios')
          .updateData({_controllerRadioInst.text: FieldValue.delete()});
    }
    if (_controllerRadioRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("radios")
          .updateData({_controllerRadioRet.text: _controllerRadioRet.text});
    }
    //--------------------------------------------------------------------------
    //CPUCP
    if (_controllerCpuCPInst.text.isNotEmpty) {
      db
          .collection("Equipe" + _equipeLogado)
          .document("cpuscp")
          .updateData({_controllerCpuCPInst.text: FieldValue.delete()});
    }

    if (_controllerCpuCPRet.text.isNotEmpty){
      db
          .collection("adm")
          .document("cpuscp")
          .updateData({_controllerCpuCPRet.text: _controllerCpuCPRet.text});
    }
    //--------------------------------------------------------------------------

  }

  Future _finalizaOrdem() async {

    _retornaStrMateriais();

    Nota nota = Nota();
    nota.eq_exec = _equipeLogado;
    nota.num_nota = widget.ordem.nun_osm;
    nota.data_realiza = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
    nota.inicio = widget.ordem.inicio;
    nota.termino =
        formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' - ', H, ':', nn]);
    nota.status_exec = _hintStatusExec;
    nota.medidor_inst = _controllerMedidorInst.text;
    nota.leitura_inst = _controllerLeitMedInst.text;
    nota.posicao_inst = _controllerPosMedInst.text;
    nota.medidor_ret = _controllerMedRet.text;
    nota.leitura_ret = _controllerLeitMedRet.text;
    nota.posicao_ret = _controllerPosMedRet.text;
    nota.cpu_inst = _controllerCpuInst.text;
    nota.cpu_ret = _controllerCpuRet.text;
    nota.radio_inst = _controllerRadioInst.text;
    nota.radio_ret = _controllerRadioRet.text;
    nota.display_inst = _controllerDisplayInst.text;
    nota.display_ret = _controllerDisplayRet.text;
    nota.ip_inst = _controllerSensorIpInst.text;
    nota.ip_ret = _controllerSensorIpRet.text;
    nota.cp_inst = _controllerCPInst.text;
    nota.cp_ret = _controllerCPRet.text;
    nota.obs = _controllerObs.text;
    nota.tempo_atend = _calculaTempo(
        widget.ordem.inicio,
        formatDate(
            DateTime.now(), [dd, '/', mm, '/', yyyy, ' - ', H, ':', nn]),
        1)
        .toString();
    nota.remota_inst = _controllerRemotaInst.text;
    nota.remota_ret = _controllerRemotaRet.text;
    nota.ssn_inst = _controllerSsnInst.text;
    nota.ssn_ret = _controllerSsnRet.text;
    nota.materiais = _textoMateriais.toString();
    nota.num_clandestinas = clandestinas.toString();
    nota.cpu_cp_inst = _controllerCpuCPInst.text;
    nota.cpu_cp_ret = _controllerCpuCPRet.text;

    nota.material_ramal = ramal.toString();
    nota.material_caboip = caboip.toString();
    nota.material_conectorp = conectorp.toString();
    nota.material_cs = cs.toString();
    nota.material_caboarmado = caboarmado.toString();
    nota.material_conectorc = conectorc.toString();
    nota.material_terminaltubular = terminaltubular.toString();
    nota.material_sealtube = sealtube.toString();
    nota.material_blindagem = blindagem.toString();
    nota.material_estrangulador = estrangulador.toString();
    nota.material_cabocobre = cabocobre.toString();
    nota.material_placaele = placaele.toString();
    nota.material_rele = rele.toString();
    nota.material_alca = alca.toString();
    nota.material_cintabap3 = cintab.toString();

    Firestore db = Firestore.instance;

    db
        .collection("notas")
        .document(widget.ordem.nun_osm)
        .setData(nota.toMap())
        .then((onValue) {

      _atribuiQuant();

      _modificaEquipamentos();

      db
          .collection("ordens")
          .document(widget.ordem.nun_osm)
          .updateData({"status": "Finalizada"});

      pr.hide();
      _displayDialog(context, "Ordem finalizada com sucesso.");
    }).catchError((onError) {
      pr.hide();
    }).timeout(Duration(seconds: 10), onTimeout: () {
      pr.hide();

      _displayDialog_NOk(context);
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
              style: _textStyle14(),
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
              style: _textStyle14(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (_) => false);
                },
              ),
            ],
          );
        });
  }

  //ALERT DIALOG
  _displayDialog_NOk(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              "Ocorreu um erro de conexão. Deixe o App aberto e assim que a conexão se reestabelecer os dados serão enviados.",
              style: _textStyle14(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (_) => false);
                },
              ),
            ],
          );
        });
  }

  //ALERT DIALOG
  _displayDialog_Ok(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Tem certeza que deseja finalizar a ordem? "
                  "Confira novamente os valores e finalize. "
                  "Não será possível modificar após a confirmação.",
              style: _textStyle12(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Finalizar'),
                onPressed: () {
                  if (_hintStatusExec != "") {
                    _finalizaOrdem();
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
                      messageTextStyle: _textStyle14(),
                    );
                    pr.show();
                  } else {
                    Navigator.of(context).pop();
                    _displayDialogCancel(context,
                        "Campo status da execução não preenchido. Preencha e tente novamente.");
                  }
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
        });
  }

  Widget _insertTextField(controller, hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: _textStyle12(),
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

  Widget _insertTextFieldCPU(controller, hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        style: _textStyle12(),
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

  _verificaEquipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq == "") {
      eq = prefs.getString("equipe");
    }

    setState(() {
      _equipeLogado = eq;
      _carregaEquipamentos();
      _carregaMaterias();
    });
  }

  _retornaStrMateriais(){
    setState(() {
      _textoMateriais = "RAMAL:$ramal\n"
          "CABO IP:$caboip\n"
          "CONECTOR PERFURANTE:$conectorp\n"
          "CS:$cs\n"
          "CABO ARMADO:$caboarmado\n"
          "CONECTOR CUNHA:$conectorc\n"
          "TERMINAL TUBULAR:$terminaltubular\n"
          "SEAL TUBE:$sealtube\n"
          "BLINDAGEM TRAFO:$blindagem\n"
          "ESTRANGULADOR:$estrangulador\n"
          "CABO COBRE:$cabocobre\n"
          "PLACA ELETRÔNICA NG:$placaele\n"
          "RELÉ:$rele\n"
          "ALÇA:$alca\n"
          "CINTA BAP-3:$cintab";
    });

  }

  _testarPreenchimento(){
    //MEDIDORES
    if (_controllerMedidorInst.text.isEmpty && _isVisibleMedidores ) {
      setState(() {
        _preenchidos = _preenchidos + "- Medidor instalado -";
      });
    }
    if (_controllerMedRet.text.isEmpty && _isVisibleMedidores ) {
      setState(() {
        _preenchidos = _preenchidos + "- Medidor retirado -";
      });
    }
    if (_controllerPosMedInst.text.isEmpty && _isVisibleMedidores ) {
      setState(() {
        _preenchidos = _preenchidos + "- Posição medidor instalado -";
      });
    }
    if (_controllerPosMedRet.text.isEmpty && _isVisibleMedidores ) {
      setState(() {
        _preenchidos = _preenchidos + "- Posição medidor retirado -";
      });
    }

    if (_controllerLeitMedRet.text.isEmpty && _isVisibleMedidores ) {
      setState(() {
        _preenchidos = _preenchidos + "- Leitura medidor retirado -";
      });
    }

    if (_controllerLeitMedInst.text.isEmpty && _isVisibleMedidores ) {
      setState(() {
        _preenchidos = _preenchidos + "- Leitura medidor instalado -";
      });
    }
    //--------------------------------------------------------------------------
    //CPU
    if (_controllerCpuInst.text.isEmpty && _isVisibleCpus ) {
      setState(() {
        _preenchidos = _preenchidos + "- CPU de cs instalado -";
      });
    }
    if (_controllerCpuRet.text.isEmpty && _isVisibleCpus ) {
      setState(() {
        _preenchidos = _preenchidos + "- CPU de cs retirado -";
      });
    }
    //--------------------------------------------------------------------------
    //RADIO
    if (_controllerRadioInst.text.isEmpty && _isVisibleRadio ) {
      setState(() {
        _preenchidos = _preenchidos + "- RÁDIO instalado -";
      });
    }
    if (_controllerRadioRet.text.isEmpty && _isVisibleRadio ) {
      setState(() {
        _preenchidos = _preenchidos + "- RÁDIO retirado -";
      });
    }
    //--------------------------------------------------------------------------
    //DISPLAY
    if (_controllerDisplayInst.text.isEmpty && _isVisibleDisplay ) {
      setState(() {
        _preenchidos = _preenchidos + "- DISPLAY instalado -";
      });
    }
    if (_controllerDisplayRet.text.isEmpty && _isVisibleDisplay ) {
      setState(() {
        _preenchidos = _preenchidos + "- DISPLAY retirado -";
      });
    }
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //CP
    if (_controllerCPInst.text.isEmpty && _isVisibleCp ) {
      setState(() {
        _preenchidos = _preenchidos + "- CP instalado -";
      });
    }
    if (_controllerCPRet.text.isEmpty && _isVisibleCp ) {
      setState(() {
        _preenchidos = _preenchidos + "- CP retirado -";
      });
    }
    //--------------------------------------------------------------------------

    //SENSORIP
    if (_controllerSensorIpInst.text.isEmpty && _isVisibleSensorIp ) {
      setState(() {
        _preenchidos = _preenchidos + "- SENSOR IP instalado -";
      });
    }
    if (_controllerSensorIpRet.text.isEmpty && _isVisibleSensorIp ) {
      setState(() {
        _preenchidos = _preenchidos + "- SENSOR IP retirado -";
      });
    }
    //--------------------------------------------------------------------------

    //REMOTA
    if (_controllerRemotaInst.text.isEmpty && _isVisibleRemota ) {
      setState(() {
        _preenchidos = _preenchidos + "- REMOTA instalada -";
      });
    }
    if (_controllerRemotaRet.text.isEmpty && _isVisibleRemota ) {
      setState(() {
        _preenchidos = _preenchidos + "- REMOTA retirada -";
      });
    }
    //--------------------------------------------------------------------------

    //REMOTA
    if (_controllerSsnInst.text.isEmpty && _isVisibleSsn ) {
      setState(() {
        _preenchidos = _preenchidos + "- SSN instalado -";
      });
    }
    if (_controllerSsnRet.text.isEmpty && _isVisibleSsn ) {
      setState(() {
        _preenchidos = _preenchidos + "- SSN retirado -";
      });
    }
    //--------------------------------------------------------------------------


    //CLANDESTINAS
    if ( clandestinas==0 && _isVisibleClandestinas ) {
      setState(() {
        _preenchidos = _preenchidos + "- CLANDESTINAS retiradas -";
      });
    }
    //--------------------------------------------------------------------------

    //OBSERVAÇÕES
    if (_isVisibleObs && _controllerObs.text.isEmpty) {
      setState(() {
        _preenchidos = _preenchidos + "- OBSERVAÇÕES -";
      });
    }
    //--------------------------------------------------------------------------
    //CPU
    if (_controllerCpuCPInst.text.isEmpty && _isVisibleCpuCp ) {
      setState(() {
        _preenchidos = _preenchidos + "- CPU de CP instalado -";
      });
    }
    if (_controllerCpuCPRet.text.isEmpty && _isVisibleCpuCp ) {
      setState(() {
        _preenchidos = _preenchidos + "- CPU de CP retirado -";
      });
    }

    if (_preenchidos != ""){
      _displayTestPreench(context, _preenchidos);
    }else{
      _displayDialog_Ok(context);
    }

  }

  //ALERT DIALOG
  _displayTestPreench(BuildContext context, mensagem) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: Text(
              "Os seguintes campos não foram preenchidos: " + mensagem +
                  ". Tem certeza que deseja finalizar?",
              style: _textStyle14(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _displayDialog_Ok(context);
                },
              ),
              FlatButton(
                child: Text('Revisar'),
                onPressed: () {
                  setState(() {
                    _preenchidos = "";
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

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
          _controllerMedRet.text = barcodeScanRes;
        });
        break;
      case "CPU":
        setState(() {
          _controllerCpuRet.text = barcodeScanRes;
        });
        break;
      case "Radio":
        setState(() {
          _controllerRadioRet.text = barcodeScanRes;
        });
        break;
      case "Display":
        setState(() {
          _controllerDisplayRet.text = barcodeScanRes;
        });
        break;
      case "Sensorip":
        setState(() {
          _controllerSensorIpRet.text = barcodeScanRes;
        });
        break;
      case "CP":
        setState(() {
          _controllerCPRet.text = barcodeScanRes;
        });
        break;
      case "Remota":
        setState(() {
          _controllerRemotaRet.text = barcodeScanRes;
        });
        break;
      case "Cpucp":
        setState(() {
          _controllerCpuCPRet.text = barcodeScanRes;
        });
        break;
      case "Ssn":
        setState(() {
          _controllerSsnRet.text = barcodeScanRes;
        });
        break;
    }

  }

  @override
  void initState() {
    _verificaEquipe();
    setState(() {
      _controllerMateriais.text = _textoMateriais;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Finalizar OSM nº " + widget.ordem.nun_osm,
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
            Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
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
                  padding: EdgeInsets.all(10),
                  //-------------------- DADOS DA ORDEM ------------------------
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            _textoVisOrdem,
                            style: _textStyle14(),
                            textAlign: TextAlign.left,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                size: 36,
                                color: Color(0xffEE162D),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isVisibleOrdem = !_isVisibleOrdem;
                                  if (!_isVisibleOrdem) {
                                    _textoVisOrdem =
                                    "Visualizar os dados da ordem";
                                  } else {
                                    _textoVisOrdem =
                                    "Ocultar os dados da ordem";
                                  }
                                });
                              })
                        ],
                      ),
                      Visibility(
                        visible: _isVisibleOrdem,
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
                                "DATA DA PROGRAMAÇÃO: " +
                                    widget.ordem.data_prog,
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
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Container(
                  decoration: BoxDecoration(color: Color(0xffffffff)),
                  child: Column(
                    children: <Widget>[
                      Divider(
                        thickness: 0.5,
                        color: Color(0xffB5B6B3),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Status",
                          style: _textStyle14(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      //--------------------- STATUS ---------------------------
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              RadioListTile(
                                title: Text(
                                  "Executado",
                                  style: _textStyle12(),
                                  textAlign: TextAlign.left,
                                ),
                                value: "Executado",
                                groupValue: _hintStatusExec,
                                onChanged: (valor) {
                                  setState(() {
                                    _hintStatusExec = valor;
                                    _coriconexec = Color(0xffEE162D);
                                    _coriconparc = Colors.white;
                                    _coriconcanc = Colors.white;
                                  });
                                },
                                activeColor: Color(0xffEE162D),
                                secondary: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: _coriconexec,
                                ),
                              ),
                              RadioListTile(
                                title: Text(
                                  "Parcial",
                                  style: _textStyle12(),
                                  textAlign: TextAlign.left,
                                ),
                                value: "Parcial",
                                groupValue: _hintStatusExec,
                                onChanged: (valor) {
                                  setState(() {
                                    _hintStatusExec = valor;
                                    _coriconexec = Colors.white;
                                    _coriconparc = Color(0xffEE162D);
                                    _coriconcanc = Colors.white;
                                  });
                                },
                                dense: true,
                                activeColor: Color(0xffEE162D),
                                secondary: Icon(
                                  Icons.pause,
                                  size: 30,
                                  color: _coriconparc,
                                ),
                              ),
                              RadioListTile(
                                title: Text(
                                  "Cancelado",
                                  style: _textStyle12(),
                                  textAlign: TextAlign.left,
                                ),
                                value: "Cancelado",
                                groupValue: _hintStatusExec,
                                onChanged: (valor) {
                                  setState(() {
                                    _hintStatusExec = valor;
                                    _coriconexec = Colors.white;
                                    _coriconparc = Colors.white;
                                    _coriconcanc = Color(0xffEE162D);
                                  });
                                },
                                dense: true,
                                activeColor: Color(0xffEE162D),
                                secondary: Icon(
                                  Icons.cancel,
                                  size: 30,
                                  color: _coriconcanc,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //--------------------- MEDIDOR --------------------------
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
                                _textoVisMedidor,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleMedidores =
                                  !_isVisibleMedidores;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleMedidores,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerMedidorInst,
                                        style: _textStyle12(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintMedidorInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedMedidores(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle12());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle12(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerMedidorInst.text = suggestion;
                                          _hintMedidorInst = suggestion;
                                        });
                                      },
                                    ),
                                  ),
                                  _insertTextField(_controllerPosMedInst,
                                      "Posição do medidor instalado"),
                                  _insertTextField(
                                      _controllerLeitMedInst, "Leitura do medidor instalado"),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Container(
                                            width: 210,
                                            child: _insertTextField(_controllerMedRet, "Medidor retirado"),
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
                                  _insertTextField(
                                      _controllerLeitMedRet, "Leitura do medidor retirado"),
                                  _insertTextField(
                                      _controllerPosMedRet, "Posição do medidor retirado"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //----------------------- CPU ----------------------------
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
                                _textoVisCpu,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleCpus =
                                  !_isVisibleCpus;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleCpus,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerCpuInst,
                                        style: _textStyle12(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintCpuInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedCpus(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle12());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle12(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerCpuInst.text = suggestion;
                                          _hintCpuInst = suggestion;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Container(
                                            width: 210,
                                            child: _insertTextFieldCPU(_controllerCpuRet, "CPU de CS retirada"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //----------------------- RADIO --------------------------
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
                                _textoVisRadio,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleRadio =
                                  !_isVisibleRadio;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleRadio,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerRadioInst,
                                        style: _textStyle12(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintRadioInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedRadios(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle12());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle12(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerRadioInst.text = suggestion;
                                          _hintRadioInst = suggestion;
                                        });
                                      },
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
                                            child: _insertTextField(_controllerRadioRet, "Rádio retirado"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //----------------------- DISPLAY-------------------------
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
                                _textoVisDisplay,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleDisplay =
                                  !_isVisibleDisplay;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleDisplay,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerDisplayInst,
                                        style: _textStyle12(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintDisplayInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedDisplays(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle12());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle12(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerDisplayInst.text = suggestion;
                                          _hintDisplayInst = suggestion;
                                        });
                                      },
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
                                            child: _insertTextField(_controllerDisplayRet, "Display retirado"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //----------------------- SENSORES IP---------------------
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
                                _textoVisSensorIp,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleSensorIp =
                                  !_isVisibleSensorIp;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleSensorIp,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerSensorIpInst,
                                        style: _textStyle12(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintSensorIpInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedSensoresIp(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle12());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle12(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerSensorIpInst.text = suggestion;
                                          _hintSensorIpInst = suggestion;
                                        });
                                      },
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
                                            child: _insertTextField(_controllerSensorIpRet, "Sensor Ip retirado"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //------------------------ CPS ---------------------------
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
                                _textoVisCp,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleCp =
                                  !_isVisibleCp;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleCp,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerCPInst,
                                        style: _textStyle12(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintCpIpInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedCps(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle12());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle12(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerCPInst.text = suggestion;
                                          _hintCpIpInst = suggestion;
                                        });
                                      },
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
                                            child: _insertTextField(_controllerCPRet, "CP retirado"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //----------------------- REMOTAS ------------------------
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
                                _textoVisRemota,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleRemota =
                                  !_isVisibleRemota;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleRemota,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerRemotaInst,
                                        style: _textStyle11(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintRemotaInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedRemotas(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle11());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle11(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerRemotaInst.text = suggestion;
                                          _hintRemotaInst = suggestion;
                                        });
                                      },
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
                                            child: _insertTextField(_controllerRemotaRet, "Remota Retirada"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //------------------------ SSNS --------------------------
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
                                _textoVisSsn,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleSsn =
                                  !_isVisibleSsn;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleSsn,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerSsnInst,
                                        style: _textStyle11(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintSsn,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedSsns(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle11());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle11(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerSsnInst.text = suggestion;
                                          _hintSsn = suggestion;
                                        });
                                      },
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
                                            child: _insertTextField(_controllerSsnRet, "Sim card retirado"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //----------------------- CPU de CP ----------------------
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
                                _textoVisCpuCps,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleCpuCp =
                                  !_isVisibleCpuCp;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleCpuCp,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: TypeAheadField(
                                      suggestionsBoxController: SuggestionsBoxController(),
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: this._controllerCpuCPInst,
                                        style: _textStyle11(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: _hintCpuCpInst,
                                          filled: true,
                                          fillColor: Color(0xffB5B6B3),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return _onChangedCpuCp(pattern);
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Text("Sem correspondência",
                                            style: _textStyle11());
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: _textStyle11(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          this._controllerCpuCPInst.text = suggestion;
                                          _hintCpuInst = suggestion;
                                        });
                                      },
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
                                            child: _insertTextFieldCPU(_controllerCpuCPRet, "CPU de CP retirado"),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //--------------------- Observaçoes ----------------------
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
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
                                _textoVisObs,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleObs =
                                  !_isVisibleObs;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleObs,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15, top: 15),
                                    child: _insertTextFieldCPU(_controllerObs, "Observações"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //--------------------- Clandestinas ---------------------
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
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
                                _textoVisClandestinas,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleClandestinas =
                                  !_isVisibleClandestinas;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleClandestinas,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (clandestinas>0){
                                                clandestinas = clandestinas - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((clandestinas).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (clandestinas>=0){
                                                clandestinas = clandestinas + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
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

                      //--------------------- Materiais ------------------------
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
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
                                _textoVisMateriais,
                                style: _textStyle14(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  _isVisibleMateriais =
                                  !_isVisibleMateriais;
                                });
                              },
                            ),
                            Visibility(
                              visible: _isVisibleMateriais,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //RAMAL
                                 Padding(
                                   padding: EdgeInsets.only(top: 10),
                                   child: Row(
                                     children: <Widget>[
                                       Padding(
                                         padding: EdgeInsets.all(5),
                                         child: Container(
                                           width: 100,
                                           child: Text(
                                             "Ramal: ",
                                             style: _textStyle14(),
                                           ),
                                         ),
                                       ),
                                       FlatButton(
                                         onPressed: (){
                                           setState(() {
                                             if (ramal>0){
                                               ramal = ramal - 1;
                                             }
                                           });
                                         },
                                         child: Icon(
                                           Icons.arrow_downward,
                                           size: 30,
                                           color: Colors.green,
                                         ),
                                       ),
                                       Text(
                                           '${num.parse((ramal).toStringAsFixed(1))}',
                                         style: _textStyle14(),
                                       ),
                                       FlatButton(
                                         onPressed: (){
                                           setState(() {
                                             if (ramal>=0){
                                               ramal = ramal + 1;
                                             }
                                           });
                                         },
                                         child: Icon(
                                           Icons.arrow_upward,
                                           size: 30,
                                           color: Colors.green,
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CABOIP
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Cabo IP: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (caboip>0){
                                                caboip = caboip - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                            '${num.parse((caboip).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (caboip>=0){
                                                caboip = caboip + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CONECTOR PERF
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Conector Perfurante: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (conectorp>0){
                                                conectorp = conectorp - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                            '${num.parse((conectorp).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (conectorp>=0){
                                                conectorp = conectorp + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CS
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "CS: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (cs>0){
                                                cs = cs - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((cs).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (cs>=0){
                                                cs = cs + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CABO ARMADO
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Cabo Armado: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (caboarmado>0){
                                                caboarmado = caboarmado - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((caboarmado).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (caboarmado>=0){
                                                caboarmado = caboarmado + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CONECTOR CUNHA
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Conector cunha: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (conectorc>0){
                                                conectorc = conectorc - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((conectorc).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (conectorc>=0){
                                                conectorc = conectorc + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //TERMINAL TUBULAR
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Terminal Tubular: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (terminaltubular>0){
                                                terminaltubular = terminaltubular - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((terminaltubular).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (terminaltubular>=0){
                                                terminaltubular = terminaltubular + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //SEAL TUBE
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Seal tube: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (sealtube>0){
                                                sealtube = sealtube - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((sealtube).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (sealtube>=0){
                                                sealtube = sealtube + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //BLINDAGEM TRAFO
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Blindagem trafo: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (blindagem>0){
                                                blindagem = blindagem - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((blindagem).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (blindagem>=0){
                                                blindagem = blindagem + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //ESTRANGULADOR
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Estrangulador: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (estrangulador>0){
                                                estrangulador = estrangulador - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((estrangulador).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (estrangulador>=0){
                                                estrangulador = estrangulador + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CABO COBRE
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Cabo cobre: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (cabocobre>0){
                                                cabocobre = cabocobre - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((cabocobre).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (cabocobre>=0){
                                                cabocobre = cabocobre + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //PLACA NG
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Placa eletrônica NG: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (placaele>0){
                                                placaele = placaele - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((placaele).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (placaele>=0){
                                                placaele = placaele + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //RELÉ
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Relé: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (rele>0){
                                                rele = rele - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((rele).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (rele>=0){
                                                rele = rele + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //ALÇA
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Alça: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (alca>0){
                                                alca = alca - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((alca).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (alca>=0){
                                                alca = alca + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                  //CINTA BAP-3
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Cinta BAP-3: ",
                                              style: _textStyle14(),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (cintab>0){
                                                cintab = cintab - 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          '${num.parse((cintab).toStringAsFixed(1))}',
                                          style: _textStyle14(),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              if (cintab>=0){
                                                cintab = cintab + 1;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Color(0xffB5B6B3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: RaisedButton(
                            child: Text(
                              "Finalizar nota",
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
                              _testarPreenchimento();
                            }),
                      ),
                    ],
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
