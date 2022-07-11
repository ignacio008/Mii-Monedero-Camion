import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:mega_monedero_store/Screens/salesScreen.dart';
import 'package:mega_monedero_store/Screens/view_pago.dart';

import 'all_pagos.dart';

class TabViewActivacionesyCompras extends StatefulWidget {
  CenserModel censerModel;
  List<PagoModel> iconmodellistTienda = [];
  TabViewActivacionesyCompras(this.censerModel, this.iconmodellistTienda);

  @override
  State<TabViewActivacionesyCompras> createState() =>
      _TabViewActivacionesyComprasState();
}

class _TabViewActivacionesyComprasState
    extends State<TabViewActivacionesyCompras>
    with SingleTickerProviderStateMixin {
  TabController controlador;
  DateTime now = DateTime.now();
  String id_variable = "";
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    id_variable =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return id_variable;
  }

  @override
  void initState() {
    controlador = new TabController(length: 2, vsync: this);
    generateRandomString(10);
    //  getlista(widget.censerModel.id);
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activaciones y Compras"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MainScreen(censerModel: widget.censerModel)));
          },
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.red,
        child: TabBar(
          padding: const EdgeInsets.all(0),
          labelPadding: const EdgeInsets.all(0),
          controller: controlador,
          tabs: [
            Tab(
              icon: Icon(Icons.category, size: 20),
              text: "Mis activaciones",
            ),
            Tab(
              icon: Icon(
                Icons.shopping_bag,
                size: 20,
              ),
              text: "Mis compras",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controlador,
        children: [
          SalesScreen(censerModel: widget.censerModel),
          TodosPagos(widget.censerModel),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPago(widget.censerModel)));
        },
        label: const Text('Recargar'),
        icon: const Icon(Icons.payment),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
