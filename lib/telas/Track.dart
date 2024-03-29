import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Track extends StatefulWidget {
  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  Completer<GoogleMapController> _controller = Completer();
  List<dynamic> listaPosIni = List<dynamic>();
  //Set<Marker> _marcadores = {};
  Map<MarkerId, Marker> _marcadores = <MarkerId, Marker>{};

  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-20.214375, -40.2708342),
    zoom: 9.8,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recuperarLocalizacoes() async {
    CollectionReference reference = Firestore.instance.collection('localiza');
    reference.snapshots().listen((querySnapshot) {
      var lat = 0.0;
      var long = 0.0;

      querySnapshot.documentChanges.forEach((change) {
        listaPosIni[int.parse(change.document.documentID) - 1] =
            change.document.data;
      });

      listaPosIni.forEach((f) {
        lat = lat + f['latitude'];
        long = long + f['longitude'];
      });

      lat = lat / 6.0;
      long = long / 6.0;

      if (this.mounted) {
        setState(() {
          _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: 9.8);

          var equipe1Pos = listaPosIni[0];
          var equipe2Pos = listaPosIni[1];
          var equipe3Pos = listaPosIni[2];
          var equipe4Pos = listaPosIni[3];
          var equipe5Pos = listaPosIni[4];
          var equipe6Pos = listaPosIni[5];

          //print("ww" + equipe3Pos.toString());

          _movimentarCamera(_posicaoCamera);
          _exibirMarcador(
              LatLng(equipe1Pos['latitude'], equipe1Pos['longitude']), equipe1Pos['time'],
              LatLng(equipe2Pos['latitude'], equipe2Pos['longitude']), equipe2Pos['time'],
              LatLng(equipe3Pos['latitude'], equipe3Pos['longitude']), equipe3Pos['time'],
              LatLng(equipe4Pos['latitude'], equipe4Pos['longitude']), equipe4Pos['time'],
              LatLng(equipe5Pos['latitude'], equipe5Pos['longitude']), equipe5Pos['time'],
              LatLng(equipe6Pos['latitude'], equipe6Pos['longitude']), equipe6Pos['time']
          );
        });
      }
    });
  }

  _exibirMarcador(LatLng equipe1, time1, LatLng equipe2, time2,
      LatLng equipe3, time3, LatLng equipe4, time4,
      LatLng equipe5, time5,  LatLng equipe6, time6) async {

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: pixelRatio),
        "images/carro.png")
        .then((BitmapDescriptor icone) {
      Marker marcador1 = Marker(
          markerId: MarkerId("1"),
          position: equipe1,
          infoWindow: InfoWindow(title: "Equipe 1 - " + time1),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("1")] = marcador1;
      });

      Marker marcador2 = Marker(
          markerId: MarkerId("2"),
          position: equipe2,
          infoWindow: InfoWindow(title: "Equipe 2 - " + time2),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("2")] = marcador2;
      });

      Marker marcador3 = Marker(
          markerId: MarkerId("3"),
          position: equipe3,
          infoWindow: InfoWindow(title: "Equipe 3 - " + time3),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("3")] = marcador3;
      });

      Marker marcador4 = Marker(
          markerId: MarkerId("4"),
          position: equipe4,
          infoWindow: InfoWindow(title: "Equipe 4 - " + time4),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("4")] = marcador4;
      });

      Marker marcador5 = Marker(
          markerId: MarkerId("5"),
          position: equipe5,
          infoWindow: InfoWindow(title: "Equipe 5 - " + time5),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("5")] = marcador5;
      });

      Marker marcador6 = Marker(
          markerId: MarkerId("6"),
          position: equipe6,
          infoWindow: InfoWindow(title: "Equipe 6 - " + time6),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("6")] = marcador6;
      });

    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _carregaPosInitial() async {
    Firestore db = Firestore.instance;
    db.collection("localiza").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        listaPosIni.add(f.data);
        print(f.data.toString());
        _recuperarLocalizacoes();
      }); //foreach
    }); //then
  }

  @override
  void initState() {
    super.initState();
    _carregaPosInitial();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Localização",
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
            Navigator.pushNamedAndRemoveUntil(context, "/admcim", (_) => false);
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
            ),
          ],
        ),
      ),
    );
  }
}
