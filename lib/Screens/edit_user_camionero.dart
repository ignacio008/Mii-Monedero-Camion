import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:toast/toast.dart';
import '../Dialog/dialogSubirFoto.dart';
import '../Firebase/authentication.dart';
import '../Firebase/fetch_data.dart';
import '../Firebase/firebase_referencias.dart';
import '../Firebase/querys.dart';
import '../Models/censerModel.dart';
import '../Models/localitiesModel.dart';
import '../Models/stateModel.dart';

class EditarUsuarioCamionero extends StatefulWidget {
  CenserModel censerModel;
  EditarUsuarioCamionero(this.censerModel);

  @override
  State<EditarUsuarioCamionero> createState() => _EditarUsuarioCamioneroState();
}

class _EditarUsuarioCamioneroState extends State<EditarUsuarioCamionero> {
  DateTime hoy;
  String idVariable = "";
  File imageCamion;
  TextEditingController nombreCamioneroController;
  TextEditingController phoneController;
  TextEditingController nombreRutaController;
  TextEditingController numUnidadController;
  TextEditingController horarioRutasController;
  String state = "Estado";
  String locality = "Municipio";
  List<StateModel> stateList = [];
  List<LocalityModel> localityList = [];
  List<LocalityModel> localityListFiltered = [];

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    idVariable =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return idVariable;
  }

  void getImageCameraCamionero() async {
    final picker = ImagePicker();
    var image = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      imageCamion = File(image.path);
    });
  }

  void getImageGalleryCamionero() async {
    final picker = ImagePicker();
    var image = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      imageCamion = File(image.path);
    });
  }

  void getImageCameraCamion() async {
    final picker = ImagePicker();
    var image = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      imageCamion = File(image.path);
    });
  }

  bool _showSpinner = false;
  void setSpinnerStatus(bool status) {
    setState(() {
      _showSpinner = status;
    });
  }

  Future<String> _loadASmaeAsset() async {
    return await rootBundle.loadString('assets/estados.json');
  }

  loadStates() async {
    String jsonString = await _loadASmaeAsset();
    var jsonResponse = json.decode(jsonString) as List;
    stateList = jsonResponse.map((i) => StateModel.fromJson(i)).toList();
    loadLocalities();
  }

  loadLocalities() async {
    String jsonString = await _loadLocalitiesAsset();
    var jsonResponse = json.decode(jsonString) as List;
    localityList = jsonResponse.map((i) => LocalityModel.fromJson(i)).toList();
  }

  Future<String> _loadLocalitiesAsset() async {
    return await rootBundle.loadString('assets/result.json');
  }

  @override
  void initState() {
    loadStates();
    nombreCamioneroController = TextEditingController();
    phoneController = TextEditingController();
    nombreRutaController = TextEditingController();
    numUnidadController = TextEditingController();
    horarioRutasController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nombreCamioneroController.dispose();
    phoneController.dispose();
    nombreRutaController.dispose();
    numUnidadController.dispose();
    horarioRutasController.dispose();
    super.dispose();
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
                    "Editar Perfil",
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
              height: MediaQuery.of(context).size.height * 0.75,
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DialogSubirFoto(
                                    cameraFunction: getImageCameraCamionero,
                                    galleryFunction: getImageGalleryCamionero,
                                  ));
                        },
                        child: Container(
                          height: 180.0,
                          width: 180.0,
                          decoration: imageCamion == null
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(150.0),
                                  color: Colors.white)
                              : null,
                          child: imageCamion == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 140,
                                          height: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(140.0),
                                            child: Image.network(
                                                "${widget.censerModel.photos}",
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 39,
                                            left: 20,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Actualizar Foto",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.add_a_photo,
                                                  color: Color.fromARGB(
                                                      169, 255, 255, 255),
                                                  size: 50,
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(150.0),
                                  child: Image.file(imageCamion,
                                      fit: BoxFit.cover)),
                        ),
                      ),

                      TextFormField(
                          controller: nombreCamioneroController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.supervised_user_circle_rounded,
                                  color: Color.fromARGB(106, 0, 0, 0),
                                ), // icon is 48px widget.
                              ),
                              labelText: "${widget.censerModel.name}"),
                          onChanged: (value) {},
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "El campo esta vacio";
                            }
                          }),

                      //TELEFONO
                      TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(106, 0, 0, 0),
                                ), // icon is 48px widget.
                              ),
                              labelText: "${widget.censerModel.numberOwner}"),
                          onChanged: (value) {},
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "El campo esta vacio";
                            }
                          }),

                      //NOMBRE RUTA
                      TextFormField(
                          controller: nombreRutaController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.directions_bus_rounded,
                                  color: Color.fromARGB(106, 0, 0, 0),
                                ),
                              ),
                              labelText: "${widget.censerModel.placa}"),
                          onChanged: (value) {},
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "El campo esta vacio";
                            }
                          }),

                      //NUMERO DE UNIDAD
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numUnidadController,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.numbers_rounded,
                                  color: Color.fromARGB(106, 0, 0, 0),
                                ),
                              ),
                              labelText: "${widget.censerModel.numUnidad}"),
                          onChanged: (value) {},
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "El campo esta vacio";
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),

                      //ESTADOS Y MUNICIPIOS
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                _showStatesDialog();
                              },
                              child: Container(
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      state,
                                      style: TextStyle(
                                          color: Color.fromARGB(195, 0, 0, 0)),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (state != "Estado") {
                                  _showLocalitiesDialog();
                                } else {
                                  Toast.show(
                                      "Debes seleccionar primero el estado",
                                      context,
                                      duration: Toast.LENGTH_LONG);
                                }
                              },
                              child: Container(
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      locality,
                                      style: TextStyle(
                                          color: Color.fromARGB(195, 0, 0, 0)),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 13,
                      ),

                      //BOTON
                      GestureDetector(
                        onTap: () {
                          actualizarUsuario();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 231, 18, 3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Actualizar Usuario",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 150,
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

  void _showStatesDialog() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "ESTADOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.80,
        child: ListView.builder(
            itemCount: stateList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      state = stateList[index].nombre;
                      locality = "Municipio";

                      localityListFiltered.clear();
                      for (int i = 0; i < localityList.length; i++) {
                        if (localityList[i].nombre_estado == state) {
                          localityListFiltered.add(localityList[i]);
                        }
                      }
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(stateList[index].nombre),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              );
            }),
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
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void _showLocalitiesDialog() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "MUNICIPIOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.80,
        child: ListView.builder(
            itemCount: localityListFiltered.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      locality = localityListFiltered[index].nombre_municipio;
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(localityListFiltered[index].nombre_municipio),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              );
            }),
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
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  actualizarUsuario() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String nombreCamionero = nombreCamioneroController.text.trim();
    String estado = state;
    String municipio = locality;
    String telefono = phoneController.text.trim();
    String nombreRuta = nombreRutaController.text.trim();
    String numUnidad = numUnidadController.text.trim();
    bool telefonoValido = RegExp(r'^\d{10}$').hasMatch(telefono);
    bool numeroUnidadValido = RegExp(r'^\d').hasMatch(numUnidad);
    String tiendaActualizada =
        "Felicidades su tienda a sido Actualizada con exito!!!";
    String error = "Error";

    if (state != "Estado" && locality == "Municipio") {
      Toast.show("Por favor, seleccione su Municipio", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    String url;
    User user = await Authentication().getCurrentUser();
    
    if (imageCamion != null) {
      String url = await QuerysService()
          .uploadProfileCamion(file: imageCamion, id: user.uid);
    }
     if (state != "Estado" && locality == "Municipio") {
      Toast.show("Por favor, seleccione su Municipio", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    bool erroguardar = await QuerysService().actualizarInfoUser(
        reference: FirebaseReferencias.REFERENCE_CENSERS,
        id: user.uid,
        collectionValues: CenserModel().toJsonBodyUserCamionero(
            user.uid,
            telefono.isEmpty ? widget.censerModel.numberOwner : telefono,
            url == null ? widget.censerModel.photos : url,
            nombreCamionero.isEmpty?widget.censerModel.name:nombreCamionero,
            numUnidad.isEmpty?widget.censerModel.numUnidad:numUnidad,
            estado == "Estado" ? widget.censerModel.state : estado,
           locality == "Municipio" ? widget.censerModel.locality : locality,
            ));

    if (erroguardar) {
      showToasterror(error);
    } else {
      _cargando(context);
      showToast(tiendaActualizada);
      CenserModel censerModel = await FetchData().getAdmin(user.uid);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(censerModel: censerModel)));
    }
  }

  void showToasterror(mensaje) {
    Toast.show("${mensaje}", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  void showToast(mensaje) {
    Toast.show("Felicidades", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  void _cargando(BuildContext context) {
    String cardEliminado = "Los datos se han actualizado con exito!!";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cargando... ",
                style: TextStyle(color: Colors.white, fontSize: 19)),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  Text("Por favor espere a que termine de subir los datos",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[],
            backgroundColor: Colors.grey[800],
          );
        });
  }
}
