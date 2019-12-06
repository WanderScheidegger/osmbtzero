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
    zoom: 11,
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

      lat = lat / 3.0;
      long = long / 3.0;

      if (this.mounted) {
        setState(() {
          _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: 11);

          var equipe1Pos = listaPosIni[0];
          var equipe2Pos = listaPosIni[1];
          var equipe3Pos = listaPosIni[2];

          print("ww" + equipe3Pos.toString());

          _movimentarCamera(_posicaoCamera);
          _exibirMarcador(
              LatLng(equipe1Pos['latitude'], equipe1Pos['longitude']),
              LatLng(equipe2Pos['latitude'], equipe2Pos['longitude']),
              LatLng(equipe3Pos['latitude'], equipe3Pos['longitude']));
        });
      }
    });
  }

  _exibirMarcador(LatLng equipe1, LatLng equipe2, LatLng equipe3) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "images/carro.png")
        .then((BitmapDescriptor icone) {
      Marker marcador1 = Marker(
          markerId: MarkerId("1"),
          position: equipe1,
          infoWindow: InfoWindow(title: "Equipe 1"),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("1")] = marcador1;
      });

      Marker marcador2 = Marker(
          markerId: MarkerId("2"),
          position: equipe2,
          infoWindow: InfoWindow(title: "Equipe 2"),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("2")] = marcador2;
      });

      Marker marcador3 = Marker(
          markerId: MarkerId("3"),
          position: equipe3,
          infoWindow: InfoWindow(title: "Equipe 3"),
          icon: icone);

      setState(() {
        _marcadores[MarkerId("3")] = marcador3;
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
