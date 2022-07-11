import 'dart:math';

import 'package:intl/intl.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/salesModel.dart';
import 'package:mega_monedero_store/Models/scaneosTotal.dart';
import 'package:mega_monedero_store/Models/userModel.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';

import 'view_pago.dart';

class ScanCodeScreen extends StatefulWidget {
  UserModel userModel;
  CenserModel censerModel;
  bool active;
  List<PagoModel> iconmodellistTienda = [];
  ScanCodeScreen(
      this.userModel, this.active, this.censerModel, this.iconmodellistTienda);

  @override
  _ScanCodeScreenState createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {
  final double barHeight = 50.0;
  bool _showSpinner = false;
  List<ScaneosModel> scaneoModel = [];

  List<ActivacionesTotal> ventasTotal = [];
  void getlista(String idusuario) async {
    ventasTotal = await FetchData().getVentas(widget.censerModel.id);
    print('Tengo ${ventasTotal.length} cards');
    print(idusuario);
    setState(() {});
  }

  preScaneo() async {
    scaneoModel = await FetchData()
        .getScaneos(widget.censerModel.id, widget.userModel.id);
    print('Tengo ${scaneoModel.length} cards scaner');
    setState(() {});
    if (scaneoModel.length == 0) {
      scaneoTrue();
    } else {
      if (widget.active == true) {
        Toast.show(
            "Si no ha pasado 1 hora este usuario ya se escaneo previamente no se contabilizara",
            context,
            duration: Toast.LENGTH_LONG);
      } else {}
    }
  }

  String id_variable = "";
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    id_variable =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return id_variable;
  }

  scaneoTrue() async {
    if (widget.active == true) {
      print("Estoy ${widget.active}");
      DateTime now = DateTime.now();
      bool erroguardar = await QuerysService().SaveGeneralInfoScaneos(
        reference: "Scaneos",
        id: id_variable,
        collectionValues: ScaneosModel().toJsonBodyScaner(
            id_variable,
            widget.censerModel.id,
            widget.userModel.id,
            widget.censerModel.locality,
            widget.censerModel.state,
            now,
            widget.censerModel.email,
            widget.userModel.email),
      );
    } else {
      print("Estoy incativo ${widget.active}");
    }
  }

  @override
  void initState() {
    getlista(widget.censerModel.id);
    generateRandomString(12);
    preScaneo();

    // TODO: implement initState
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
                  "MII MONEDERO CHOFER",
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
                    image: widget.userModel.urlProfile,
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
                    widget.userModel.name,
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
                    widget.active ? "USUARIO ACTIVO" : "USUARIO INACTIVO",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: widget.active ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                widget.active
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          widget.censerModel.activacionesRestantes == 0
                              ? _showAlertVentaMaxima()
                              : _showAlertActive();
                        },
                        child: Container(
                          width: 200.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              "ACTIVAR USUARIO",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 15.0,
                ),
                widget.active
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          widget.censerModel.activacionesRestantes == 0
                              ? "Alcanzaste el numero maximo de activaciones, Procede a pagar"
                              : "Te quedan ${widget.censerModel.activacionesRestantes} actvaciones mas por realizar",
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  widget.censerModel.activacionesRestantes == 0
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void _showAlertVentaMaxima() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Activación",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "Lo sentimos alcanzaste el numero maximo de activaciones. Realiza una recarga para poder seguir trabajando",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Cancelar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "Pagar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewPago(
                          widget.censerModel,
                        )));
          },
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void _showAlertActive() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Activación",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "¿Está seguro de querer activar a este usuario?",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Cancelar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "Aceptar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            _activeUser();
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _activeUser() {
    setState(() {
      _showSpinner = true;
    });

    DateTime now = DateTime.now();
    DateTime nextTime = DateTime(now.year, now.month, now.day + 15);

    QuerysService().updateUserDataServices(
        idUser: widget.userModel.id,
        context: context,
        collectionValues: nextTime,
        errorFunction: _errorFunction,
        succesfulFunction: _succesfulFunction);
  }

  _errorFunction() {
    setState(() {
      _showSpinner = false;
    });
  }

  _succesfulFunction() async {
    DateTime now = DateTime.now();
    String idSale_ = randomAlphaNumeric(18);

    QuerysService().SaveSale(
        idSale: idSale_,
        errorFunction: _errorFunction,
        function: _sucessTotal,
        context: context,
        collectionValues: {
          'id': idSale_,
          'storeId': widget.censerModel.id,
          'nameStore': widget.censerModel.name,
          'categoryStore': widget.censerModel.category,
          'dateTime': now,
          'userId': widget.userModel.id,
          'nameUser': widget.userModel.name,
          'nameOwner': widget.censerModel.nameOwner,
          'numberOwner': widget.censerModel.numberOwner,
          'state': widget.censerModel.state,
          'locality': widget.censerModel.locality,
          'placa': widget.censerModel.placa,
          'nameRuta': widget.censerModel.nameRuta,
        });
    // bool erroguardar=await QuerysService().UpdateCenserVentas(reference: FirebaseReferencias.REFERENCE_ActivacionesTotalCamionero, id:widget.censerModel.id, collectionValues:ActivacionesTotal().toJsonBodyActualizar(
    //     widget.iconModelVentas.numeroActivacion==12?widget.iconModelVentas.ciclosDoce+1:widget.iconModelVentas.ciclosDoce,

    //     widget.iconModelVentas.numeroActivacion==0
    //     ?widget.iconModelVentas.numeroActivacion+1
    //     :widget.iconModelVentas.numeroActivacion-1,

    //     now,
    //     ),
    //     );

    bool erroguardarCamion = await QuerysService().UpdateCenserCamion(
      reference: FirebaseReferencias.REFERENCE_CENSERS,
      id: widget.censerModel.id,
      collectionValues: CenserModel().toJsonBodyCamionActivacion(
        widget.censerModel.activacionesRestantes - 1,
      ),
    );

    // bool erroguardarCamion=await QuerysService().SetCenserVentas(reference: FirebaseReferencias.REFERENCE_ActivacionesTotalCamionero, id:id_variable, collectionValues:ActivacionesTotal().toJsonBodyCamionActivaciones(
    // id_variable,
    // widget.censerModel.id,
    // now,
    // widget.userModel.email,
    // widget.censerModel.name,
    // ),
    // );
    //  bool erroguardarCamionero=await QuerysService().UpdateCamionCenserActivaciones(reference: "Censers", id:widget.censerModel.id, collectionValues:{
    //     'activacionesRestantes': widget.censerModel.activacionesRestantes-1,

    // }
    //     );
    // if(erroguardarCamionero){
    //   print("hubo un error");
    // }else{
    //   print("EXito a cambiar");
    // }
  }

  _sucessTotal() {
    setState(() {
      _showSpinner = false;
    });
    //Navigator.of(context).pop();
    _showAlertCerrarSesion();
  }

  void _showAlertCerrarSesion() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Activación éxitosa",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "La activación del código de este usuario se ha finalizado con éxito, por favor, dígale al cliente que reinicie su aplicación para observar los cambios",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Aceptar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () async {
            CenserModel adminmodel =
                await FetchData().getCamionero(widget.censerModel.id);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(censerModel: adminmodel)));
          },
        ),
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
