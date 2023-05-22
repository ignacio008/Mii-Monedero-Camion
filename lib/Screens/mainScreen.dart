import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero_store/Firebase/authentication.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/codeModel.dart';
import 'package:mega_monedero_store/Models/lastScan.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/userModel.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero_store/Screens/editCamion.dart';
import 'package:mega_monedero_store/Screens/editCenserScreen.dart';
import 'package:mega_monedero_store/Screens/loginScreen.dart';
import 'package:mega_monedero_store/Screens/salesScreen.dart';
import 'package:mega_monedero_store/Screens/scanCodeScreen.dart';
import 'package:mega_monedero_store/Screens/screenLastScaner.dart';
import 'package:mega_monedero_store/Screens/tab_view_ayc.dart';
import 'package:mega_monedero_store/Screens/vinculadoCamion.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MainScreen extends StatefulWidget {
  CenserModel censerModel;
  MainScreen({this.censerModel});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final double barHeight = 50.0;
  bool _showSpinner = false;
  List<UserModel> usuarios = [];
  // List<ActivacionesTotal>ventasTotal=[];
  List<PagoModel> pagoMoldeList = [];
  List<LastScan> lastScanModelList = [];

  void getlista(String idusuario) async {
    pagoMoldeList = await FetchData().getPagosCamioneroActivaciones(idusuario);
    print('Tengo ${pagoMoldeList.length} cards Pagos');
    setState(() {});
  }

// Aqui el ultimo scan
  // void getlistLastScan(String idCamion) async {
  //   lastScanModelList = await FetchData().getPagosCamioneroActivaciones(idCamion);
  //   print('Tengo ${lastScanModelList.length} cards Pagos');
  //   setState(() {});
  // }

  @override
  void initState() {
    // TODO: implement initState
    getlista(widget.censerModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: statusbarHeight),
              height: statusbarHeight + barHeight,
              child: Center(
                child: Text(
                  "MII MONEDERO CHOFER",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
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
            SizedBox(
              height: 15.0,
            ),
            Text(
              "Bienvenido",
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.censerModel.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                _showAlertCerrarSesion();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Cerrar Sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Seleccione una opción",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  if (widget.censerModel.suspended) {
                    Toast.show(
                        "Tu cuenta está suspendida, por favor, contacta a los administradores para solucionar el problema",
                        context,
                        duration: Toast.LENGTH_LONG);
                  } else {
                    // String cameraScanResult = await scanner.scan();
                    String cameraScanResult =
                        await FlutterBarcodeScanner.scanBarcode(
                            '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                    print("el resuktado de la camara es ${cameraScanResult}");
                    if (cameraScanResult.length >= 10) {
                      _processUserScan(cameraScanResult);
                    } else {
                      print(
                          "Lo sentimos no has selecionado un codigo QR valido");
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 40.0, right: 40.0, bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red[300],
                    ),
                    child: Icon(
                      Icons.account_balance,
                      size: 50.0,
                      color: Color.fromARGB(255, 89, 9, 9),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Escanear código",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // Expanded(
            //   flex: 1,
            //   child: GestureDetector(
            //     onTap: (){
            //       if(!widget.censerModel.suspended){
            //         Toast.show("Tu cuenta está suspendida, por favor, contacta a los administradores para solucionar el problema", context, duration: Toast.LENGTH_LONG);
            //       }
            //       else{

            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => EditCamion(widget.censerModel)
            //             )
            //         );
            //       }
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.only(top:20.0, left: 40.0, right: 40.0, bottom: 5.0),
            //       child: Container(
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20.0),
            //             color: Colors.red[300],
            //         ),
            //         child: Icon(
            //           Icons.supervisor_account,
            //           size: 50.0,
            //           color: MyColors.Colors.colorRedBackgroundDark,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Text(
            //   "Mi información",
            //   style: TextStyle(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.bold
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  if (widget.censerModel.suspended) {
                    Toast.show(
                        "Tu cuenta está suspendida, por favor, contacta a los administradores para solucionar el problema",
                        context,
                        duration: Toast.LENGTH_LONG);
                  } else {
                    _activacionesyCompras();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 40.0, right: 40.0, bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red[300],
                    ),
                    child: Icon(
                      Icons.attach_money,
                      size: 50.0,
                      color: Color.fromARGB(255, 89, 9, 9),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Mis últimas activaciones y compras",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  if (widget.censerModel.idCamion.isEmpty) {
                    Toast.show(
                        "Lo sentimos no estas vinculado con ningun camion, intente volver a Scanear y reinicie la aplicacion",
                        context,
                        duration: Toast.LENGTH_LONG);
                    return;
                  } else {
                    Toast.show("Ultimo Scaneo", context,
                        duration: Toast.LENGTH_LONG);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScreenLastScaner(
                                censerModel: widget.censerModel,
                                iconmodellistTienda: pagoMoldeList)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 40.0, right: 40.0, bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red[300],
                    ),
                    child: Icon(
                      Icons.qr_code_scanner_sharp,
                      size: 50.0,
                      color: Color.fromARGB(255, 89, 9, 9),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Últimos Scaneos",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  void _showAlertCerrarSesion() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Cerrar Sesión",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "¿Está seguro de querer cerrar sesión?",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        TextButton(
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
        TextButton(
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
            Authentication().singOut();
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
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

  _processUserScan(String data) {
    CodeModel codeModel = CodeModel.fromJson(jsonDecode(data));

    if (codeModel.dateTime == null) {
      print("h");
      if (codeModel.locality == widget.censerModel.locality &&
          codeModel.state == widget.censerModel.state) {
        _getVincular(codeModel.id);
      } else {
        print("Error no es el mismo ciudad");
        Toast.show(
          "Error no estas registrado en la misma ciudad y municipio que el camion", context,
          duration: Toast.LENGTH_LONG);
        print(widget.censerModel.locality);
        print( widget.censerModel.state);
      }
    } else {
      DateTime activeUntil = DateFormat("yyyy-MM-dd").parse(codeModel.dateTime);
      DateTime now = DateTime.now();

      int isActive = now.compareTo(activeUntil);
      setState(() {
        _showSpinner = true;
      });
      print("Usuario inactivo");
      _getMiInfo(codeModel.id, false);
    }
  }

  void _getMiInfo(String idPropio, bool active) async {
    final messages = await QuerysService().getUserbyID(miId: idPropio);
    usuarios = _getUserItem(messages.docs);

    // ventasTotal=await FetchData().getVentas(widget.censerModel.id);
    // print('Tengo ${ventasTotal.length} cards');
    print(idPropio);
    setState(() {
      _showSpinner = false;
    });

    if (usuarios.length > 0) {
      DateTime now = DateTime.now();

      int isActive = now.compareTo(usuarios[0].activeUntil);

      if (isActive == 1) {
        print("Usuario inactivo");

        ActivacionesTotal iconModelVentas;
        // actuvacionesAtualizacion(ventasTotal[0],pagoMoldeList);

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ScanCodeScreen(
        //             usuarios[0], false, widget.censerModel, pagoMoldeList)));
      } else {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ScanCodeScreen(
        //             usuarios[0], true, widget.censerModel, pagoMoldeList)));
      }
    } else {
      Toast.show(
          "Ha ocurrido un error, por favor intente escanear de nuevo", context,
          duration: Toast.LENGTH_LONG);
    }
  }

  void _getVincular(String idCamion) async {
    print(idCamion);

    setState(() {
      _showSpinner = false;
    });

    var now = DateTime.now();
    QuerysService().updateCamiones(
        idCamion: idCamion,
        errorFunction: _cancelSpinnerError,
        function: _cancelSpinnerSuccesful,
        context: context,
        collectionValues: {
          'idCamion': idCamion,
          'upDateCamionero': now,
          'idCamionero': widget.censerModel.id,
        });

    QuerysService().updateCamioneroIdCamion(
        idCamion: widget.censerModel.id,
        errorFunction: _cancelSpinnerError,
        function: _cancelSpinnerSuccesful,
        context: context,
        collectionValues: {
          'idCamion': idCamion,
        });
  }

  _cancelSpinnerError() {
    setState(() {
      _showSpinner = false;
    });
  }

  _cancelSpinnerSuccesful() {
    setState(() {
      _showSpinner = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VincularCamion(widget.censerModel)));
  }

  void setSpinnerStatus(bool status) {
    setState(() {
      _showSpinner = status;
    });
  }

  void _activacionesyCompras() async {
    print(widget.censerModel.id);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TabViewActivacionesyCompras(
                widget.censerModel, pagoMoldeList)));
  }

  List<UserModel> _getUserItem(dynamic miInfo) {
    List<UserModel> miInfoList = [];

    for (var datos in miInfo) {
      final id_ = datos.data()['id'];
      final name_ = datos.data()['name'] ?? '';
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final activeUntil_ = datos.data()['activeUntil'];
      final locality_ = datos.data()['locality'] ?? '';
      final state_ = datos.data()['state'] ?? '';
      final renovations_ = datos.data()['renovations'];
      final suspended_ = datos.data()['suspended'];
      final urlProfile_ = datos.data()['urlProfile'] ?? '';

      UserModel usuariosModel = UserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_.toDate(),
        activeUntil: activeUntil_.toDate(),
        locality: locality_,
        state: state_,
        renovations: renovations_,
        suspended: suspended_,
        urlProfile: urlProfile_,
      );

      miInfoList.add(usuariosModel);
    }
    return miInfoList;
  }
}
