import 'dart:core';

class Ordem {

  String _emissao;
  String _nun_osm;
  String _data_prog;
  String _agrupamento;
  String _trafo;
  String _endereco;
  String _medidor;
  String _coordX;
  String _coordY;
  String _net;
  String _tipMan;
  String _prioridade;
  String _cs;
  String _obs;
  String _equipe;
  String _uidcriador;
  String _uidmod;
  String _status;
  String _inicio;

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
    "emissao" : this.emissao,
    "numero_ordem" : this.nun_osm,
    "data_programacao" : this.data_prog,
    "agrupamento" : this.agrupamento,
    "trafo" : this.trafo,
    "endereco" : this.endereco,
    "medidor" : this.medidor,
    "coordenada_x" : this.coordX,
    "coordenada_y" : this.coordY,
    "net" : this.net,
    "tipo_manutencao" : this.tipMan,
    "prioridade" : this.prioridade,
    "cs" : this.cs,
    "observacoes" : this.obs,
      "equipe" : this.equipe,
      "uidcriador" : this.uidcriador,
      "uidmod" : this.uidmod,
      "status" : this._status,
      "inicio" : this._inicio
    };
    return map;
  }

  Ordem();

  String get inicio => _inicio;

  set inicio(String value) {
    _inicio = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get uidmod => _uidmod;

  set uidmod(String value) {
    _uidmod = value;
  }

  String get uidcriador => _uidcriador;

  set uidcriador(String value) {
    _uidcriador = value;
  }

  String get equipe => _equipe;

  set equipe(String value) {
    _equipe = value;
  }

  String get obs => _obs;

  set obs(String value) {
    _obs = value;
  }

  String get cs => _cs;

  set cs(String value) {
    _cs = value;
  }

  String get prioridade => _prioridade;

  set prioridade(String value) {
    _prioridade = value;
  }

  String get tipMan => _tipMan;

  set tipMan(String value) {
    _tipMan = value;
  }

  String get net => _net;

  set net(String value) {
    _net = value;
  }

  String get coordY => _coordY;

  set coordY(String value) {
    _coordY = value;
  }

  String get coordX => _coordX;

  set coordX(String value) {
    _coordX = value;
  }

  String get medidor => _medidor;

  set medidor(String value) {
    _medidor = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get trafo => _trafo;

  set trafo(String value) {
    _trafo = value;
  }

  String get agrupamento => _agrupamento;

  set agrupamento(String value) {
    _agrupamento = value;
  }

  String get data_prog => _data_prog;

  set data_prog(String value) {
    _data_prog = value;
  }

  String get nun_osm => _nun_osm;

  set nun_osm(String value) {
    _nun_osm = value;
  }

  String get emissao => _emissao;

  set emissao(String value) {
    _emissao = value;
  }


}