import 'dart:core';

class Nota{

  String _eq_exec;
  String _num_nota;
  String _data_realiza;
  String _inicio;
  String _termino;
  String _status_exec;
  String _medidor_inst;
  String _medidor_ret;
  String _leitura_inst;
  String _leitura_ret;
  String _posicao_inst;
  String _posicao_ret;
  String _cpu_inst;
  String _cpu_ret;
  String _cpu_cp_inst;
  String _cpu_cp_ret;
  String _radio_inst;
  String _radio_ret;
  String _display_inst;
  String _display_ret;
  String _ip_inst;
  String _ip_ret;
  String _cp_inst;
  String _cp_ret;
  String _obs;
  String _materiais;
  String _tempo_atend;
  String _remota_inst;
  String _ssn_inst;
  String _remota_ret;
  String _ssn_ret;
  String _num_clandestinas;

  String _material_ramal;
  String _material_caboip;
  String _material_conectorp;
  String _material_cs;
  String _material_caboarmado;
  String _material_conectorc;
  String _material_terminaltubular;
  String _material_sealtube;
  String _material_blindagem;
  String _material_estrangulador;
  String _material_cabocobre;
  String _material_placaele;
  String _material_rele;
  String _material_alca;
  String _material_cintabap3;
  String _problemas;
  String _agravantes;



  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "eq_exec" : this._eq_exec,
      "num_nota" : this._num_nota,
      "data_realiza": this._data_realiza,
      "inicio": this._inicio,
      "termino": this._termino,
      "status_exec": this._status_exec,
      "medidor_inst": this._medidor_inst,
      "medidor_ret": this._medidor_ret,
      "leitura_inst": this._leitura_inst,
      "leitura_ret": this._leitura_ret,
      "posicao_inst": this._posicao_inst,
      "posicao_ret": this._posicao_ret,
      "cpu_inst": this._cpu_inst,
      "cpu_ret": this._cpu_ret,
      "cpu_cp_inst": this._cpu_cp_inst,
      "cpu_cp_ret": this._cpu_cp_ret,
      "radio_inst": this._radio_inst,
      "radio_ret": this._radio_ret,
      "display_inst": this._display_inst,
      "display_ret": this._display_ret,
      "ip_inst": this._ip_inst,
      "ip_ret": this._ip_ret,
      "cp_inst": this._cp_inst,
      "cp_ret": this._cp_ret,
      "obs": this._obs,
      "materiais": this._materiais,
      "tempo_atend": this._tempo_atend,
      "remota_inst": this._remota_inst,
      "ssn_inst": this._ssn_inst,
      "remota_ret": this._remota_ret,
      "ssn_ret": this._ssn_ret,
      "num_clandestinas": this._num_clandestinas,
      "cs": this._material_cs,
      "ramal": this._material_ramal,
      "caboip": this._material_caboip,
      "conectorp": this._material_conectorp,
      "conectorc": this._material_conectorc,
      "caboarmado": this._material_caboarmado,
      "terminaltubular": this._material_terminaltubular,
      "sealtube": this._material_sealtube,
      "blindagem": this._material_blindagem,
      "estrangulador": this._material_estrangulador,
      "cabocobre": this._material_cabocobre,
      "placaele": this._material_placaele,
      "rele": this._material_rele,
      "alca": this._material_alca,
      "cintab": this._material_cintabap3,
      "problemas": this._problemas,
      "agravantes": this._agravantes

    };
    return map;
  }

  Nota();


  String get problemas => _problemas;

  set problemas(String value) {
    _problemas = value;
  }

  String get eq_exec => _eq_exec;

  set eq_exec(String value) {
    _eq_exec = value;
  }

  String get cpu_cp_inst => _cpu_cp_inst;

  set cpu_cp_inst(String value) {
    _cpu_cp_inst = value;
  }

  String get material_ramal => _material_ramal;

  set material_ramal(String value) {
    _material_ramal = value;
  }

  String get num_clandestinas => _num_clandestinas;

  set num_clandestinas(String value) {
    _num_clandestinas = value;
  }

  String get materiais => _materiais;

  set materiais(String value) {
    _materiais = value;
  }

  String get remota_inst => _remota_inst;

  set remota_inst(String value) {
    _remota_inst = value;
  }

  String get tempo_atend => _tempo_atend;

  set tempo_atend(String value) {
    _tempo_atend = value;
  }

  String get obs => _obs;

  set obs(String value) {
    _obs = value;
  }

  String get cp_ret => _cp_ret;

  set cp_ret(String value) {
    _cp_ret = value;
  }

  String get cp_inst => _cp_inst;

  set cp_inst(String value) {
    _cp_inst = value;
  }

  String get ip_ret => _ip_ret;

  set ip_ret(String value) {
    _ip_ret = value;
  }

  String get ip_inst => _ip_inst;

  set ip_inst(String value) {
    _ip_inst = value;
  }

  String get display_ret => _display_ret;

  set display_ret(String value) {
    _display_ret = value;
  }

  String get display_inst => _display_inst;

  set display_inst(String value) {
    _display_inst = value;
  }

  String get radio_ret => _radio_ret;

  set radio_ret(String value) {
    _radio_ret = value;
  }

  String get radio_inst => _radio_inst;

  set radio_inst(String value) {
    _radio_inst = value;
  }

  String get cpu_ret => _cpu_ret;

  set cpu_ret(String value) {
    _cpu_ret = value;
  }

  String get cpu_inst => _cpu_inst;

  set cpu_inst(String value) {
    _cpu_inst = value;
  }

  String get posicao_ret => _posicao_ret;

  set posicao_ret(String value) {
    _posicao_ret = value;
  }

  String get posicao_inst => _posicao_inst;

  set posicao_inst(String value) {
    _posicao_inst = value;
  }

  String get leitura_ret => _leitura_ret;

  set leitura_ret(String value) {
    _leitura_ret = value;
  }

  String get leitura_inst => _leitura_inst;

  set leitura_inst(String value) {
    _leitura_inst = value;
  }

  String get medidor_ret => _medidor_ret;

  set medidor_ret(String value) {
    _medidor_ret = value;
  }

  String get medidor_inst => _medidor_inst;

  set medidor_inst(String value) {
    _medidor_inst = value;
  }

  String get status_exec => _status_exec;

  set status_exec(String value) {
    _status_exec = value;
  }

  String get termino => _termino;

  set termino(String value) {
    _termino = value;
  }

  String get inicio => _inicio;

  set inicio(String value) {
    _inicio = value;
  }

  String get data_realiza => _data_realiza;

  set data_realiza(String value) {
    _data_realiza = value;
  }

  String get num_nota => _num_nota;

  set num_nota(String value) {
    _num_nota = value;
  }

  String get ssn_inst => _ssn_inst;

  set ssn_inst(String value) {
    _ssn_inst = value;
  }

  String get remota_ret => _remota_ret;

  set remota_ret(String value) {
    _remota_ret = value;
  }

  String get ssn_ret => _ssn_ret;

  set ssn_ret(String value) {
    _ssn_ret = value;
  }

  String get material_caboip => _material_caboip;

  set material_caboip(String value) {
    _material_caboip = value;
  }

  String get material_conectorp => _material_conectorp;

  set material_conectorp(String value) {
    _material_conectorp = value;
  }

  String get material_cs => _material_cs;

  set material_cs(String value) {
    _material_cs = value;
  }

  String get material_caboarmado => _material_caboarmado;

  set material_caboarmado(String value) {
    _material_caboarmado = value;
  }

  String get material_conectorc => _material_conectorc;

  set material_conectorc(String value) {
    _material_conectorc = value;
  }

  String get material_terminaltubular => _material_terminaltubular;

  set material_terminaltubular(String value) {
    _material_terminaltubular = value;
  }

  String get material_sealtube => _material_sealtube;

  set material_sealtube(String value) {
    _material_sealtube = value;
  }

  String get material_blindagem => _material_blindagem;

  set material_blindagem(String value) {
    _material_blindagem = value;
  }

  String get material_estrangulador => _material_estrangulador;

  set material_estrangulador(String value) {
    _material_estrangulador = value;
  }

  String get material_cabocobre => _material_cabocobre;

  set material_cabocobre(String value) {
    _material_cabocobre = value;
  }

  String get material_placaele => _material_placaele;

  set material_placaele(String value) {
    _material_placaele = value;
  }

  String get material_rele => _material_rele;

  set material_rele(String value) {
    _material_rele = value;
  }

  String get material_alca => _material_alca;

  set material_alca(String value) {
    _material_alca = value;
  }

  String get material_cintabap3 => _material_cintabap3;

  set material_cintabap3(String value) {
    _material_cintabap3 = value;
  }

  String get cpu_cp_ret => _cpu_cp_ret;

  set cpu_cp_ret(String value) {
    _cpu_cp_ret = value;
  }

  String get agravantes => _agravantes;

  set agravantes(String value) {
    _agravantes = value;
  }
}