import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Screens/screen_pago.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import '../Models/censerModel.dart';
import '../Models/stateCosto.dart';

class StatusCamionero extends StatefulWidget {
  CenserModel censerModel;
  StatusCamionero(this.censerModel);

  @override
  State<StatusCamionero> createState() => _StatusCamioneroState();
}

class _StatusCamioneroState extends State<StatusCamionero> {
  bool _showSpinner = false;
  void setSpinnerStatus(bool status) {
    setState(() {
      _showSpinner = status;
    });
  }

  DateTime now = DateTime.now();
  List<StateCosto> stateCosto = [];
  @override
  void initState() {
    if (widget.censerModel.detailSum == null) {
      widget.censerModel.detailSum = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      MyColors.Colors.colorEditUser,
                      Color.fromARGB(255, 119, 4, 4)
                    ],
                    end: FractionalOffset.topRight,
                    begin: FractionalOffset.topLeft,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.repeated),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                      child: Text(
                    "Status Camionero",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
            containerWhite(),
            containerInputs()
          ],
        ),
      ),
    );
  }

  Widget containerWhite() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        color: Colors.white,
      ),
    );
  }

  Widget containerInputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.19,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Bienvenido a tu Status ${widget.censerModel.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 140.0,
                        width: 140.0,
                        decoration: widget.censerModel.photos == null
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(150.0),
                                color: Color.fromARGB(255, 0, 0, 0))
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(150.0),
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150.0),
                          child: Image.network(
                            "${widget.censerModel.photos}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          widget.censerModel.activacionesRestantes == 0
                              ? "DEUDA"
                              : "Te quedan ${widget.censerModel.activacionesRestantes} activaciones, ¿Deseas recargar +12?",
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
                      SizedBox(
                        height: 10,
                      ),

                      //BOTON
                      GestureDetector(
                        onTap: () {
                          pagoView();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 231, 18, 3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "PAGAR",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          widget.censerModel.detailSum <= 0
                              ? "Tienes ${widget.censerModel.detailSum}"
                              : "Tienes ${widget.censerModel.detailSum} pasajes por adelantado",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: widget.censerModel.detailSum <= 0
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 450,
                      )
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
  }
}
