import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/userModel.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero_store/Screens/scanCodeScreen.dart';
import 'package:soundpool/soundpool.dart';

class ScreenLastScaner extends StatefulWidget {
  CenserModel censerModel;

  List<PagoModel> iconmodellistTienda = [];
  ScreenLastScaner({this.censerModel, this.iconmodellistTienda});

  @override
  State<ScreenLastScaner> createState() => _ScreenLastScanerState();
}

class _ScreenLastScanerState extends State<ScreenLastScaner> {
  List<UserModel> usuarios = [];
  Color colores = Colors.red[800];
  Color coloresRed=Color.fromARGB(255, 255, 96, 107);
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Scaneos')
        .where('idCamion', isEqualTo: widget.censerModel.id)
        .orderBy('createOn', descending: true)
        .limit(1)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos del pasajero"),
  elevation: 0.0,
        flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.5, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
          colors: <Color>[MyColors.Colors.colorRedBackgroundDark,
                      MyColors.Colors.colorRedBackgroundLight]),
      ),
    ),
  

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.red,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 120,
                  ),
                  Text(
                    'Algo salió mal, por favor recargue la app',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
                    child: CircularProgressIndicator(
              color: Colors.white,
            )));
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String photoUser = data['photoUser'] ?? 'default value';
              String emailUsuario =
                  data['emailUsuario'] ?? 'Valor No Encontrado';
              DateTime dateCreate =
                  data['createOn'].toDate() ?? 'No hay valor';
              DateTime isActiveDate =
                  data['isActiveDate'].toDate() ?? 'No hay valor';
              DateTime now = DateTime.now();
              String idUsuario = data['idUsuario'] ?? 'Valor No Encontrado';
              String idCamionBus =
                  data['idCamionBus'] ?? 'Valor No Encontrado';
              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(isActiveDate);
              int isActive = now.compareTo(isActiveDate);

              if (isActive == 1) {
                sound();
                  colores = Colors.red[800];
                  coloresRed=Color.fromARGB(255, 255, 96, 107);
              } else {
                soundActivo();
                colores = Colors.green[700];
                coloresRed=Color.fromARGB(255, 32, 171, 130);
              }
              return Container(
                decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      coloresRed,
                      colores
                    ],
                    end: FractionalOffset.topCenter,
                    begin: FractionalOffset.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.repeated),
              ),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/fondo_negro.jpg",
                          image: photoUser,
                          fit: BoxFit.cover,
                          width: 140.0,
                          height: 140.0,
                          fadeInDuration: Duration(milliseconds: 1000),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        "Email: ${emailUsuario}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        "Fecha de vencimiento: ${formattedDate}",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      isActive == 1
                          ? ElevatedButton.icon(
                              onPressed: () {
                                activateUsers(idUsuario, photoUser,
                                    isActiveDate, idCamionBus);
                              },
                              icon: Icon(
                                Icons.local_activity_sharp,
                                color: Colors.black,
                              ),
                              label: Text(
                                "Activar suscripción",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.all(20.0),
                                  shadowColor: Colors.black,
                                  side: BorderSide(
                                      color: Colors.black, width: 1),
                                  shape: StadiumBorder()),
                            )
                          : Column(
                              children: [
                                Text(
                                  "Activo",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02,
                                ),
                                Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.white,
                                  size: 130,
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
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

  void activateUsers(String idPropio, String photoUser, DateTime isActiveDate,
      String idCamionBus) async {
    final messages = await QuerysService().getUserbyID(miId: idPropio);
    usuarios = _getUserItem(messages.docs);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScanCodeScreen(
                usuarios[0],
                false,
                widget.censerModel,
                widget.iconmodellistTienda,
                photoUser,
                isActiveDate,
                idCamionBus)));
  }

  void sound() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle
        .load("assets/images/SonidoDenegado.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  soundActivo() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle
        .load("assets/images/Sonido_aceptado.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }
}
