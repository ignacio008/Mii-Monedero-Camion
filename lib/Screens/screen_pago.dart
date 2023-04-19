import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/stateCosto.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:toast/toast.dart';

class ScreenPago extends StatefulWidget {
  StateCosto statecosto;
  CenserModel censerModel;
  ScreenPago(this.statecosto, this.censerModel);

  @override
  State<ScreenPago> createState() => _ScreenPagoState();
}

class _ScreenPagoState extends State<ScreenPago> {
  String id_variable = "";
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    id_variable =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return id_variable;
  }

  List<StateCosto> stateCosto = [];

  void getTopChanele(String state) async {
    stateCosto = await FetchData().getStateCostp(widget.censerModel.state);
    var tamano = stateCosto.length;
    print("Mi estaod es ${widget.censerModel.state}");
    print("EL TAMAÑO DE LA LISTA ES: ${tamano}");
  }

  bool _loading = true;
  String _mesage = "";
  bool _pagando = false;
  DateTime now = DateTime.now();
  double numPago = 200.00;
  _createOrderPago() async {
    DateTime now = DateTime.now();

    var orderRef = FirebaseFirestore.instance.collection("PagoCamionero").doc();
    await orderRef.set(PagoModel().toJsonBody(
      id_variable,
      widget.censerModel.id,
      widget.statecosto.costo,
      now,
      widget.censerModel.name,
      widget.censerModel.email,
      widget.censerModel.numberOwner,
      widget.censerModel.placa,
    ));

    orderRef.snapshots().listen(onData);
  }

  final double barHeight = 50.0;
  bool _showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState

    generateRandomString(12);
    _createOrderPago();
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "MII MONEDERO CHOFER",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _loading
                          ? Text("Su pago es de: ",
                              style: TextStyle(fontSize: 20))
                          : Text("Tu pago fue de: ",
                              style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 6.0),
                      Text("\$ ${widget.statecosto.costo} MXN",
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20.0),
                      _loading
                          ? Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10.0),
                                Text("Cargando... Por favor espere"),
                              ],
                            )
                          : TextButton(
                              style: ButtonStyle(
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(40.0),
                                    ),
                                  )),
                              child: Text("Gracias por tu recarga",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              onPressed: () async {
                                CenserModel adminmodel = await FetchData()
                                    .getCamionero(widget.censerModel.id);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen(
                                            censerModel: adminmodel)));
                              }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onData(DocumentSnapshot event) async {
    print("recibo ${event.data()}");
    // if(event.data()['preference_id'] != null){
    //   var result = await MercadoPagoMobileCheckout.startCheckout("TEST-32a3ac49-f045-41ac-95df-c9fa000f6eea", event.data()['preference_id']);
    //   print("pruebas recibo +${result}");
    // }

    if (event.data()['status'] == 'Aprobado' ||
        event.data()['status'] == 'Pendiente') {
      setState(() {
        _loading = false;
        _mesage = event.data()['message'];
      });
    } else if (_pagando == false) {
      if (event.data()['preference_id'] != null) {
        var response = await MercadoPagoMobileCheckout.startCheckout(
            "TEST-32a3ac49-f045-41ac-95df-c9fa000f6eea",
            event.data()['preference_id']);
        print(response);

        if (response.status == 'approved') {
          print("mi estado ${response.status[4]}");
          event.reference.update({
            'status': 'Aprobado',
            'message': 'Te enviaremos tu pedido pronto',
          });

          bool erroguardarCamionero = await QuerysService()
              .UpdateCamionCenserActivaciones(
                  reference: "Censers",
                  id: widget.censerModel.id,
                  collectionValues: {
                'activacionesRestantes':
                    widget.censerModel.activacionesRestantes + 12,
              });
          if (erroguardarCamionero) {
            print("hubo un error");
          } else {
            print("EXito a cambiar");
          }
          var orderRef = FirebaseFirestore.instance
              .collection("EstadoPagoCamionero")
              .doc(id_variable);
          await orderRef.set(PagoModel().toJsonBodyEStadoPago(
            id_variable,
            widget.censerModel.id,
            numPago,
            now,
            widget.censerModel.name,
            widget.censerModel.email,
            widget.censerModel.numberOwner,
            widget.censerModel.placa,
            'Aprobado',
            'Tu recarga se activara en 24 hrs despues de acreditar tu pago',
            event.data()['preference_id'],
          ));

          print("Estoy approved");
        } else if (response.status == 'in_process') {
          event.reference.update({
            //  'payment':response,
            'status': 'Pendiente',
            'message':
                'Tu pedido se enviara en 24 hrs despues de acreditar tu pago',
          });

          var orderRef = FirebaseFirestore.instance
              .collection("EstadoPagoCamionero")
              .doc(id_variable);
          await orderRef.set(PagoModel().toJsonBodyEStadoPagoActivaciones(
            id_variable,
            widget.censerModel.id,
            numPago,
            now,
            widget.censerModel.name,
            widget.censerModel.email,
            widget.censerModel.numberOwner,
            widget.censerModel.placa,
            'Pendiente',
            'Tu recarga se activara en 24 hrs despues de acreditar tu pago',
            event.data()['preference_id'],
            false,
          ));
        } else if (response.status == 'pending') {
          event.reference.update({
            //  'payment':response,
            'status': 'Pendiente',
            'message':
                'Tu recarga se activara en 24 hrs despues de acreditar tu pago',
          });

          var orderRef = FirebaseFirestore.instance
              .collection("EstadoPagoCamionero")
              .doc(id_variable);
          await orderRef.set(PagoModel().toJsonBodyEStadoPagoActivaciones(
              id_variable,
              widget.censerModel.id,
              numPago,
              now,
              widget.censerModel.name,
              widget.censerModel.email,
              widget.censerModel.numberOwner,
              widget.censerModel.placa,
              'Pendiente',
              'Tu recarga se activara en 24 hrs despues de acreditar tu pago',
              event.data()['preference_id'],
              false));
        } else {
          print(event.data());
          CenserModel adminmodel =
              await FetchData().getCamionero(widget.censerModel.id);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(censerModel: adminmodel)));
        }
      }
    }
  }
}
