import 'package:flutter/material.dart';
import 'package:osmbtzero/model/back.dart';
import 'package:osmbtzero/telas/AdmAexecutar.dart';
import 'package:osmbtzero/telas/AdmEmExecucao.dart';
import 'package:osmbtzero/telas/AdmExecutadas.dart';
import 'package:osmbtzero/telas/Peoples.dart';
import 'package:url_launcher/url_launcher.dart';

class AdmCim extends StatefulWidget {
  @override
  _AdmCimState createState() => _AdmCimState();
}

class _AdmCimState extends State<AdmCim> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Área Administrativa",
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
            Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
          },
        ),
        backgroundColor: Color(0xffEE162D),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 2,
          indicatorColor: Colors.white,
          labelColor: Color(0xffffffff),
          labelStyle: TextStyle(
            fontFamily: "EDP Preon",
            fontSize: 6.5,
          ),
          //controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.people, size: 30),
              text: "Usuários",
            ),
            Tab(
              icon: Icon(
                Icons.sort,
                size: 30,
              ),
              text: "A executar",
            ),
            Tab(
              icon: Icon(
                Icons.timer,
                size: 30,
              ),
              text: "Em execução",
            ),
            Tab(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              text: "Executadas",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          People(),
          AdmAexecutar(),
          AdmEmExecucao(),
          //AdmExecutadas(),
          back(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xffEE162D),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.work),
              onPressed: () {
                Navigator.pushNamed(context, "/addmaterial");
              },
            ),
            IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.map),
              onPressed: () {
                Navigator.pushNamed(context, "/track");
              },
            ),
            IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.note),
              onPressed: () {
                Navigator.pushNamed(context, "/relatorio");
              },
            ),
            IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.add_to_photos),
              onPressed: () {
                Navigator.pushNamed(context, "/inicianota");
              },
            ),
          ],
        ),
      ),
    );
  }
}
