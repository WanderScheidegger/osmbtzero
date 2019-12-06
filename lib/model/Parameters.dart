import 'dart:core';

class Parameters{

  String _uid;
  String _equipe;

  Parameters();

  String get equipe => _equipe;

  set equipe(String value) {
    _equipe = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }


}