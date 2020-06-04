import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Rota extends StatefulWidget {
  @override
  _RotaState createState() => _RotaState();
}

class _RotaState extends State<Rota> {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _marcadores = <MarkerId, Marker>{};

  var _latAtual;
  var _longAtual;

  static String _equipeLogado = "sem equipe";
  bool _isSemEquipe = true;


  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-20.214375, -40.2708342),
    zoom: 11,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  _recuperarLocalizacoes() async {

    CollectionReference reference = Firestore.instance.collection('ordens');
    reference.snapshots().listen((querySnapshot) {
      var listaLoc = querySnapshot.documents.
      where( (or) => (or.data['status']=='Atribuída') && (or.data['equipe']==_equipeLogado) ).toList();

      var somaLat = 0.0;
      var somaLong = 0.0;
      var n_users = listaLoc.length;



      //insere cada marca de cada ordem
      listaLoc.forEach((user) {
        double pixelRatio = MediaQuery.of(context).devicePixelRatio;

        var num = user.data['numero_ordem'];
        var lat = double.parse(user.data['coordenada_x']);
        var long = double.parse(user.data['coordenada_y']);

        somaLat += lat;
        somaLong += long;

        BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "images/el_services.png")
            .then((BitmapDescriptor icone) {

          Marker marc = Marker(
              markerId: MarkerId(num),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(
                title: "Ordem nº " + num,
              ),
              icon: icone);

          setState(() {
            _marcadores[MarkerId(num)] = marc;
          });

        });

      });

      //somaLat = somaLat + _latAtual;
      //somaLong = somaLong + _longAtual;

      var cameraLat = somaLat/(n_users);
      var cameraLong = somaLong/(n_users);


      if (n_users==0){
        cameraLat = _latAtual;
        cameraLong = _longAtual;
      }

      if (this.mounted) {
        setState(() {
          _posicaoCamera = CameraPosition(target: LatLng(cameraLat, cameraLong), zoom: 11);

          _movimentarCamera(_posicaoCamera);

        });
      }

    });
  }

  _posicaoAtual(){

    Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    ).then((Position position){

      setState(() {
        _latAtual = position.latitude;
        _longAtual = position.longitude;
      });

    }).timeout(Duration(seconds: 5), onTimeout: () {

    });

  }


  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _verificaEquipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var eq = "";
    while (eq == "") {
      eq = prefs.getString("equipe");
    }

    setState(() {
      _equipeLogado = eq;
    });
    if (_equipeLogado == "Adm" || _equipeLogado == "sem equipe") {
      setState(() {
        _isSemEquipe = false;
      });
    }else{
      setState(() {
        _isSemEquipe = true;
      });
    }
  }

  @override
  void initState() {
    _verificaEquipe();
    _recuperarLocalizacoes();
    _posicaoAtual();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mapa das OSM",
          style: TextStyle(
            fontFamily: "EDPPreon",
            fontSize: 18,
            color: Color(0xffffffff),
          ),
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
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_marcadores.values),
              zoomGesturesEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}