import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/stateCosto.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:mega_monedero_store/Screens/screen_pago.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:toast/toast.dart';

class ViewPago extends StatefulWidget {
  CenserModel censerModel;
  List<PagoModel> iconmodellistTienda = [];
  ViewPago(this.censerModel);

  @override
  State<ViewPago> createState() => _ViewPagoState();
}

class _ViewPagoState extends State<ViewPago> {
  List<CenserModel> censerList = [];
  final double barHeight = 50.0;
  bool _showSpinner = false;

  String id_variable = "";
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    id_variable =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return id_variable;
  }

  DateTime now = DateTime.now();
  List<StateCosto> stateCosto = [];

  void getTopChanele(String state) async {
    stateCosto = await FetchData().getStateCostp(widget.censerModel.state);
    var tamano = stateCosto.length;
    print("Mi estaod es ${widget.censerModel.state}");
    print("EL TAMAÑO DE LA LISTA ES: ${tamano}");
  }

  @override
  void initState() {
    // TODO: implement initState
    generateRandomString(10);

    print("Tengo ${widget.censerModel.id}");
    //actuvacionesAtualizacion();
    getTopChanele(widget.censerModel.state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: statusbarHeight),
              height: statusbarHeight + barHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen(censerModel: widget.censerModel)));
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Mii Boletinaje",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      MyColors.Colors.colorRedBackgroundDark,
                      MyColors.Colors.colorRedBackgroundLight
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.5, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/fondo_negro.jpg",
                      image: widget.censerModel.photos,
                      fit: BoxFit.cover,
                      width: 100.0,
                      height: 100.0,
                      fadeInDuration: Duration(milliseconds: 1000),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.censerModel.name,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: MyColors.Colors.colorBackgroundDark),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.censerModel.activacionesRestantes == 0
                          ? "DEUDA"
                          : "Te quedan ${widget.censerModel.activacionesRestantes} activaciones, ¿Deseas recargar +12?",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: widget.censerModel.activacionesRestantes == 0
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      pagoView();
                      // widget.iconModelVentas.numeroVenta==12?_showAlertVentaMaxima():
                      //                   _showAlertActive();
                    },
                    child: Container(
                      width: 200.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          "Pagar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pagoView() async {
    DateTime now = DateTime.now();
    setSpinnerStatus(false);
    int numPago = 1;
    int pagoTotal = 200;
    if (stateCosto.isEmpty) {
      StateCosto cuadro1 = StateCosto(
          state: "E.U", locality: "E.U", costo: 100, costoPorPasaje: 55);
      stateCosto.add(cuadro1);
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ScreenPago(stateCosto[0], widget.censerModel)));

    // bool pagoError=await QuerysService().SavePago(reference: FirebaseReferencias.REFERENCE_PagoCamionero, id:id_variable, collectionValues:PagoModel().toJsonBody(
    // id_variable,
    // widget.censerModel.id,
    // numPago,
    // now,
    // widget.censerModel.name,
    // widget.censerModel.email,
    // widget.censerModel.numberOwner,
    // widget.censerModel.placa,
    // ),
    // );

    // bool erroguardar=await QuerysService().UpdateCenserVentas(reference: FirebaseReferencias.REFERENCE_ActivacionesTotalCamionero, id:widget.iconModelVentas.idCamion, collectionValues:ActivacionesTotal().toJsonBodyActualizar(
    // widget.iconModelVentas.numeroActivacion==0?widget.iconModelVentas.ciclosDoce+1:widget.iconModelVentas.ciclosDoce,

    // widget.iconModelVentas.numeroActivacion+12,

    // now,
    // ),
    // );

    // if(pagoError){
    //    Toast.show("Ha ocurrido un error en su pago", context, duration: Toast.LENGTH_LONG);
    // }else{

    //   if(erroguardar){
    // Toast.show("Ha ocurrido un problema en su informacion su folio es: ${id_variable}", context, duration: Toast.LENGTH_LONG);
    // }else{
    //    setSpinnerStatus(false);
    //     Toast.show("Pago realizado con exito!!! Su Folio: ${id_variable}", context, duration: Toast.LENGTH_LONG);
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(censerModel: widget.censerModel)));

    //   }
    // }
  }

  void setSpinnerStatus(bool status) {
    setState(() {
      _showSpinner = status;
    });
  }

  // List<CenserModel> _getCenserItem(dynamic miInfo){

  //   List<CenserModel> miInfoList = [];

  //   for(var datos in miInfo) {
  //     final id_ = datos.data()['id'];
  //     final name_ = datos.data()['name'] ?? '';
  //     final email_ = datos.data()['email'] ?? '';
  //     final createdOn_ = datos.data()['createdOn'];
  //     final description_ = datos.data()['description'] ?? '';
  //     final category_ = datos.data()['category'] ?? '';
  //     final addres_ = datos.data()['addres'] ?? '';
  //     final openHours_ = datos.data()['openHours'] ?? '';
  //     final latitude_ = datos.data()['latitude'];
  //     final longitude_ = datos.data()['longitude'];
  //     final state_ = datos.data()['state'] ?? '';
  //     final locality_ = datos.data()['locality'] ?? '';
  //     final nameOwner_ = datos.data()['nameOwner'] ?? '';
  //     final numberOwner_ = datos.data()['numberOwner'] ?? '';
  //     final suspended_ = datos.data()['suspended'];
  //     final photos_ = datos.data()['photos'];
  //     final services_ = datos.data()['services'];
  //     final distanceTo_ = datos.data()['distanceTo'] ?? '';
  //     final numUnidad_ =datos.data()['numUnidad']??'';
  //     final placa_ = datos.data()['placa']??'';
  //     final photoPLaca_ = datos.data()['photoPLaca']??'';
  //     final photoLicencia_ = datos.data()['photoLicencia']??'';
  //     final nameRuta_ = datos.data()['nameRuta']??'';
  //     final paraderoRuta_ = datos.data()['paraderoRuta']??'';
  //     final imagenCamion_=datos.data()['camion']??'';

  //     CenserModel censerModel = CenserModel(
  //       id: id_,
  //       name: name_,
  //       email: email_,
  //       createdOn: createdOn_.toDate(),
  //       locality: locality_,
  //       state: state_,
  //       suspended: suspended_,
  //       description: description_,
  //       category: category_,
  //       addres: addres_,
  //       openHours: openHours_,
  //       latitude: latitude_,
  //       longitude: longitude_,
  //       nameOwner: nameOwner_,
  //       numberOwner: numberOwner_,
  //       photos: photos_  ,
  //       services: services_  ,
  //       distanceTo: distanceTo_,
  //       numUnidad:numUnidad_,
  //       placa:placa_,
  //       photoPLaca:photoPLaca_,
  //       photoLicencia:photoLicencia_,
  //       nameRuta:nameRuta_,
  //       paraderoRuta:paraderoRuta_,
  //       imagenCamion:imagenCamion_,
  //     );

  //     miInfoList.add(censerModel);
  //   }
  //   return miInfoList;
  // }
}
