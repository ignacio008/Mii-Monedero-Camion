import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';

import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero_store/Screens/mainScreen.dart';

class VincularCamion extends StatefulWidget {
  CenserModel censerModel;
  VincularCamion(this.censerModel);

  @override
  State<VincularCamion> createState() => _VincularCamionState();
}

class _VincularCamionState extends State<VincularCamion> {
  int counter = 2;
  Timer countTimer;
  void startTimer() {
    counter = 2;
    countTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          countTimer.cancel();
          print("exito mensaje");
         Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(censerModel:widget.censerModel)));
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 253, 111, 111),
                  Color.fromARGB(255, 154, 25, 25)
                ],
                end: FractionalOffset.topCenter,
                begin: FractionalOffset.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated),
          ),
        ),
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 140,
                  color: Colors.green,
                ),
                Text(
                  "Camion Vinculado con exito!!!",
                  style: TextStyle(
                      color: Color.fromARGB(255, 186, 255, 187), fontSize: 20),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
