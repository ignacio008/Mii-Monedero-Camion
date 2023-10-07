import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Firebase/authentication.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero_store/Screens/loginScreen.dart';
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  List<CenserModel> censerList = [];

  // void getCurrentUser() async{
  //   var user = await Authentication().getCurrentUser();
  //   if (user != null) {
  //     _getMiInfo(user.uid);
  //   }
  //   else{
  //     Timer(
  //         Duration(
  //             milliseconds: 1000
  //         ), () {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => LoginScreen ()
  //           )
  //       );
  //     });
  //   }
  // }

  // void _getMiInfo(String idPropio) async {

  //   final messages = await QuerysService().getMiInfo(miId: idPropio);
  //   censerList = _getCenserItem(messages.docs);

  //   if(censerList.length > 0){

  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => MainScreen (censerModel: censerList[0])
  //         )
  //     );

  //   }
  //   else{
  //     Authentication().singOut();
  //     Toast.show("Ha ocurrido un error, por favor reinicie la aplicación", context, duration: Toast.LENGTH_LONG);
  //   }
  // }



   void getCurrentUserMio() async{
    int status=0;
    var user = await Authentication().getCurrentUser();
    if (user != null) {
     CenserModel adminmodel = await FetchData().getCamionero(user.uid);

    if(adminmodel!=null){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen (censerModel: adminmodel,)));
    }
    }
    else{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
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
      
  //     final activacionesRestantes_=datos.data()['activacionesRestantes']??'';



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
        
  //       activacionesRestantes:activacionesRestantes_,
  //     );


  //     miInfoList.add(censerModel);
  //   }
  //   return miInfoList;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getCurrentUserMio();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [MyColors.Colors.colorRedBackgroundDark, MyColors.Colors.colorRedBackgroundLight],
                  end: FractionalOffset.topCenter,
                  begin: FractionalOffset.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.repeated
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Mii Boletinaje",
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "Chofer",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
