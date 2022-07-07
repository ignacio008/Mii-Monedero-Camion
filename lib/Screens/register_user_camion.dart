import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_monedero_store/Dialog/dialogSubirFoto.dart';
import 'package:mega_monedero_store/Firebase/authentication.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/localitiesModel.dart';
import 'package:mega_monedero_store/Models/stateModel.dart';
import 'package:mega_monedero_store/Models/userModel.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';

import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class RegisterUserCamion extends StatefulWidget {
  RegisterUserCamion({Key key}) : super(key: key);

  @override
  State<RegisterUserCamion> createState() => _RegisterUserCamionState();
}

class _RegisterUserCamionState extends State<RegisterUserCamion> {
  bool mostrarContrasena=false;
  bool ConfirmarMostrarContrasena=false;
  double screenHeight;
  TextEditingController _phoneController;
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;
  
  TextEditingController _numUnidadController;
  TextEditingController _placaController;
  
  TextEditingController _nombreRutaController;
  
  TextEditingController _ParaderosRutasController;
  
  TextEditingController _horarioRutasController;

  String _state = "Estado";
  String _locality = "Municipio";
  bool _showSpinner = false;
  File _image;
  File _imagePlaca;
  File _imageLicencia;
  File _imageCamion;
  UserModel myUser;
  String myId;
  DateTime _now;
  DateTime _yesterday;
  String myUrl;
List<CenserModel> censerList = [];
  String _statenombreRta="Nombre de la ruta";
  List _stateListRutasList=["Ruta numero 1", "Ruta numero 2"];
  


   List<StateModel> stateList = [];
   List<LocalityModel> localityList = [];
   List<LocalityModel> localityListFiltered = [];
   String id_variable="";
String generateRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  id_variable= List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  return id_variable;
}

  void _getImageGallery() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    setState(() {
     _image=File(image.path);
    });
  }

  void _getImageCamera() async {
     final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      _image=File(image.path);
    });
  }




  void _getImageGalleryPlaca() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    setState(() {
     _imagePlaca=File(image.path);
    });
  }

  void _getImageCameraPlaca() async {
     final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      _imagePlaca=File(image.path);
    });
  }




  void _getImageGalleryLicencia() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    setState(() {
     _imageLicencia=File(image.path);
    });
  }

  void _getImageCameraLicencia() async {
     final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      _imageLicencia=File(image.path);
    });
  }

   void _getImageGalleryCamion() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    setState(() {
     _imageCamion=File(image.path);
    });
  }

  void _getImageCameraCamion() async {
     final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      _imageCamion=File(image.path);
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
   Future<String> _loadLocalitiesAsset() async {
    return await rootBundle.loadString('assets/result.json');
  }

  loadLocalities() async {
    String jsonString = await _loadLocalitiesAsset();
    var jsonResponse = json.decode(jsonString) as List;

    localityList = jsonResponse.map((i) => LocalityModel.fromJson(i)).toList();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    loadStates();

    _nameController = TextEditingController();
    _phoneController= TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _numUnidadController= TextEditingController();
    _placaController=TextEditingController();
    
  _nombreRutaController = TextEditingController();
  _ParaderosRutasController= TextEditingController() ;
  _horarioRutasController= TextEditingController() ;
  generateRandomString(5);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneController.dispose();
    _numUnidadController.dispose();
    _placaController.dispose();
    // _nombreRutaController.dispose();
    // _ParaderosRutasController.dispose();
    // _horarioRutasController.dispose();
  }

  void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [MyColors.Colors.colorRedBackgroundDarkF, Colors.red[800]],
                    end: FractionalOffset.topCenter,
                    begin: FractionalOffset.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.repeated),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 65.0),
                      Text(
                        "REGÍSTRATE AQUÍ",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogSubirFoto(
                                cameraFunction: _getImageCamera,
                                galleryFunction: _getImageGallery,
                              )
                          );
                        },
                        child: Container(
                          height: 180.0,
                          width: 180.0,
                          decoration: _image == null ? BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Colors.white
                          ) : null,
                          child : _image == null ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: MyColors.Colors.colorBackgroundDark,
                                size: 80.0,
                              ),
                              SizedBox(height: 5,),
                              Text("Foto de perfil",
                              style:TextStyle(
                                color: MyColors.Colors.colorBackgroundDark,
                              )),
                            ],
                          ) : ClipRRect(
                              borderRadius: BorderRadius.circular(150.0),
                              child: Image.file(
                                  _image,
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Container(
                            height: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    controller: _nameController,
                                    textCapitalization: TextCapitalization.words,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    //obscureText: true,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Nombre del conductor",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Futura',
                                          color: Colors.white54,
                                        )
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  _showStatesDialog();
                                },
                                child: Container(
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _state,
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  if(_state != "Estado"){
                                    _showLocalitiesDialog();
                                  }
                                  else{
                                    Toast.show("Debes seleccionar primero el estado", context, duration: Toast.LENGTH_LONG);
                                  }
                                },
                                child: Container(
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child:  Center(
                                    child: Text(
                                      _locality,
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Container(
                            height: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.phone,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    controller: _phoneController,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Telefono",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Futura',
                                          color: Colors.white54,
                                        )
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Container(
                            height: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    //obscureText: true,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Correo electrónico",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Futura',
                                          color: Colors.white54,
                                        )
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Container(
                            height: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    controller: _passwordController,
                                    obscureText: !mostrarContrasena,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Contraseña",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Futura',
                                          color: Colors.white54,
                                        ),
                                         suffixIcon: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: IconButton(
                                      icon: Icon(mostrarContrasena?Icons.visibility:Icons.visibility_off,
                                      color:Colors.white54),
                                      onPressed: (){
                                        setState(() {
                                          mostrarContrasena= !mostrarContrasena;
                                        });
                                    }
                                  ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Container(
                            height: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    controller: _passwordConfirmController,
                                    obscureText: !ConfirmarMostrarContrasena,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                       suffixIcon: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: IconButton(
                                      icon: Icon(ConfirmarMostrarContrasena?Icons.visibility:Icons.visibility_off,
                                      color:Colors.white54),
                                      onPressed: (){
                                        setState(() {
                                          ConfirmarMostrarContrasena= !ConfirmarMostrarContrasena;
                                        });
                                    }
                                  ),
                                      ),
                                        hintText: "Confirmar contraseña",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Futura',
                                          color: Colors.white54,
                                        )
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),


                    SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Row(
                          children: <Widget>[
                             Expanded(
                                  child: Container(
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                    child: 
                                    Row(
                                      children: [
                                        SizedBox(
                                  width: 15.0,
                                ),
                                        Expanded(
                                          child: TextFormField(
                                            textInputAction: TextInputAction.done,
                                            controller: _numUnidadController,
                                             keyboardType: TextInputType.phone,
                                             cursorColor:MyColors.Colors.colorBackgroundDark,
                                            style: TextStyle(
                                              fontFamily: 'Futura',
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                                hintText: "# de Unidad",
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Futura',
                                                  color: Colors.white54,
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            SizedBox(
                              width: 10.0,
                            ),

                            Expanded(
                                  child: Container(
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                    child: 
                                    Row(
                                      children: [
                                              SizedBox(
                                  width: 15.0,
                                ),
                                        Expanded(
                                          child: TextFormField(
                                            textInputAction: TextInputAction.done,
                                            controller: _placaController,
                                            cursorColor:MyColors.Colors.colorBackgroundDark,
                                            style: TextStyle(
                                              fontFamily: 'Futura',
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                                hintText: "Placa",
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Futura',
                                                  color: Colors.white54,
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    SizedBox(height:15),







    Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Row(
                          children: <Widget>[
                             Expanded(
                                  child:
                    GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogSubirFoto(
                                cameraFunction: _getImageCameraPlaca,
                                galleryFunction: _getImageGalleryPlaca,
                              )
                          );
                        },
                        child: Container(
                          height: 100.0,
                          decoration: _imagePlaca == null ? BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white
                          ) : null,
                          child : _imagePlaca == null ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: MyColors.Colors.colorBackgroundDark,
                                size: 40.0,
                              ),
                              SizedBox(height: 5,),
                              Text("Placa del Camion",
                              style:TextStyle(
                                color: MyColors.Colors.colorBackgroundDark,
                              )),
                            ],
                          ) : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.file(
                                  _imagePlaca,
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                                ),
                            SizedBox(
                              width: 10.0,
                            ),

                            Expanded(
                                  child: 
                                  GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogSubirFoto(
                                cameraFunction: _getImageCameraLicencia,
                                galleryFunction: _getImageGalleryLicencia,
                              )
                          );
                        },
                        child: Container(
                          height: 100.0,
                          decoration: _imageLicencia == null ? BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white
                          ) : null,
                          child : _imageLicencia == null ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: MyColors.Colors.colorBackgroundDark,
                                size: 40.0,
                              ),
                              SizedBox(height: 5,),
                              Text("Foto de Licencia",
                              style:TextStyle(
                                color: MyColors.Colors.colorBackgroundDark,
                              )),
                            ],
                          ) : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.file(
                                  _imageLicencia,
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                                ),
                          ],
                        ),
                      ),

                       SizedBox(height: 20.0),
                      Padding(
                          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => DialogSubirFoto(
                                        cameraFunction: _getImageCameraCamion,
                                        galleryFunction: _getImageGalleryCamion,
                                      )
                                  );
                                },
                                child: Container(
                                  height: 180.0,
                                  width: 280.0,
                                  decoration: _imageCamion == null ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white
                                  ) : null,
                                  child : _imageCamion == null ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        color: MyColors.Colors.colorBackgroundDark,
                                        size: 80.0,
                                      ),
                                      SizedBox(height: 5,),
                                      Text("Foto del Camion",
                                      style:TextStyle(
                                        color: MyColors.Colors.colorBackgroundDark,
                                      )),
                                    ],
                                  ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.file(
                                          _imageCamion,
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                   
                    SizedBox(height:15),

                      Padding( 
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: (){
                                        _showStatesDialogRutas();
                                      },
                                      child: Container(
                                          height: 42.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _statenombreRta,
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height:15),
                       Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                         child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _ParaderosRutasController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      cursorColor:MyColors.Colors.colorBackgroundDark,
                      //obscureText: true,
                     style: TextStyle(
                        fontFamily: 'Futura',
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText:"Paraderos",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontFamily: 'Futura',
                              color: Colors.white54,
                            )
                      ),
                    ),
                  ),
                ),
                       ),
                SizedBox(
                  height: 15.0,
                ),


                
                       Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                         child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _horarioRutasController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      cursorColor:MyColors.Colors.colorBackgroundDark,
                      //obscureText: true,
                     style: TextStyle(
                        fontFamily: 'Futura',
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText:"Horario de la ruta",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontFamily: 'Futura',
                              color: Colors.white54,
                            )
                      ),
                    ),
                  ),
                ),
                       ),
                SizedBox(
                  height: 5.0,
                ),




                      GestureDetector(
                        onTap: (){
                        _processCenserRegister();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top:20.0, left: 40.0, right: 40.0),
                          child: Container(
                            height: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "FINALIZAR REGISTRO",
                                style: TextStyle(
                                    color: MyColors.Colors.colorBackgroundDark,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:75),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showStatesDialogRutas(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Ruta",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.20,
        child: ListView.builder(
            itemCount: _stateListRutasList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _statenombreRta = _stateListRutasList[index];
                     
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          _stateListRutasList[index]
                      ),
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
            }
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
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }


  
  void _showStatesDialog(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "ESTADOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.80,
        child: ListView.builder(
            itemCount: stateList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _state = stateList[index].nombre;
                      _locality = "Municipio";
      
                      localityListFiltered.clear();
                      for(int i = 0; i < localityList.length; i++){
                        if(localityList[i].nombre_estado == _state){
                          localityListFiltered.add(localityList[i]);
                        }
                      }
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          stateList[index].nombre
                      ),
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
            }
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
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }
   void _showLocalitiesDialog(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "MUNICIPIOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.80,
        child: ListView.builder(
            itemCount: localityListFiltered.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _locality = localityListFiltered[index].nombre_municipio;
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          localityListFiltered[index].nombre_municipio
                      ),
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
            }
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
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }





   _processCenserRegister() async {

    FocusScope.of(context).requestFocus(FocusNode());

    String _NameConductor = _nameController.text;
    String _estado = _state;
    String _municipio  = _locality;
    String _Telefono = _phoneController.text.trim();
    String _Email = _emailController.text.trim();
    String _Contrasena = _passwordController.text.trim();
    String _ConfirmarContrasena = _passwordConfirmController.text.trim();
    String _NumUnidad = _numUnidadController.text.trim();
    String _Placa = _placaController.text.trim();

    String _nameRuta=_statenombreRta;
    String _paraderos=_ParaderosRutasController.text.trim();
    String _horarioRutas=_horarioRutasController.text.trim();

    bool telefonoValido = RegExp(r'^\d{10}$').hasMatch(_Telefono);
    bool numeroUnidadValido = RegExp(r'^\d').hasMatch(_NumUnidad);



     FocusScope.of(context).requestFocus(FocusNode());
      if(_NameConductor.length < 3){
      Toast.show("Debes introducir un nombre válido", context, duration: Toast.LENGTH_LONG);
      return;
    }

     if(_image == null){
       Toast.show("Por favor, necesita subir su foto para continuar", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }
    
     if(_state == "Estado"){
       Toast.show("Por favor, seleccione su estado", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }
     if(_locality == "Municipio"){
       Toast.show("Por favor, seleccione su municipio", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }
     if(_Telefono != null && telefonoValido==false){
      Toast.show("El telefono debe tener 10 digitos y solo puede contener numeros", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
   
    
     if(_Email.length < 3){
       Toast.show("Debes introducir un email del centro de servicio válido", context, duration: Toast.LENGTH_LONG);
       return;
     }
     if(!_Email.contains("@")){
       Toast.show("Debes introducir un email del centro de servicio válido", context, duration: Toast.LENGTH_LONG);
       return;
     }
      if(_Contrasena.length < 6 ){
       Toast.show("Su contraseña debe ser minimo de 6 caracteres, por favor, verifíquela", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }
     else{
       if(_Contrasena != _ConfirmarContrasena){
         Toast.show("Sus contraseñas no coinciden", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
         return;
       }
     }

     if(_NumUnidad.isEmpty){
       Toast.show("El numero de unidad del camion no puede estar vacio", context, duration: Toast.LENGTH_LONG);
       return;
     }
     if( numeroUnidadValido==false){
      Toast.show("Solo debe contener Numeros", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
     if(_Placa.isEmpty){
       Toast.show("La placa no puede estar vacio", context, duration: Toast.LENGTH_LONG);
       return;
     }

     if(_imagePlaca == null){
       Toast.show("Por favor, necesita subir la foto de la placa para continuar", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }
     if(_imageLicencia == null){
       Toast.show("Por favor, necesita subir la foto de su licencia para continuar", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }

     if(_nameRuta == "Nombre de la ruta"){
       Toast.show("Por favor, seleccione una ruta", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       return;
     }

     if(_paraderos.length < 10){
       Toast.show("Debes introducir paraderos válidos con al menos 10 caracteres", context, duration: Toast.LENGTH_LONG);
       return;
     }
   
     if(_horarioRutas.length < 3){
       Toast.show("Debes introducir el horario de la ruta correctamente", context, duration: Toast.LENGTH_LONG);
       return;
     }
    
   
  String _Latitiude= "20.991467";
  String _Longitude= "-89.649143";
    
    setSpinnerStatus(true);
     var auth = await Authentication().createUser(email: _Email, password: _Contrasena);

     if(auth.succes){
       var user = await Authentication().getCurrentUser();
       if (user != null) {
         var now = DateTime.now();
     final Reference storageRef =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_CENSERS).child("Perfil" + "-perfil-1"+id_variable);
        final UploadTask uploadTaske = storageRef.putFile(
          File(_image.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrl = (await uploadTaske.whenComplete(() => null));
        final String urls = (await downloadUrl.ref.getDownloadURL());
        //////////
        final Reference storageRefPlaca =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_Placa).child("PLaca" + "-perfil-1"+id_variable);
        final UploadTask uploadTaskePlca = storageRefPlaca.putFile(
          File(_imagePlaca.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrlPlaca = (await uploadTaskePlca.whenComplete(() => null));
        final String urlsPlaca = (await downloadUrlPlaca.ref.getDownloadURL());
      /////////////////////////
         final Reference storageRefLicencia =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_Licencia).child("Licencia" + "-perfil-1"+id_variable);
        final UploadTask uploadTaskeLicencia = storageRefLicencia.putFile(
          File(_imageLicencia.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrlLicencia = (await uploadTaskeLicencia.whenComplete(() => null));
        final String urlsLicencia = (await downloadUrlLicencia.ref.getDownloadURL());
        //////////////////////////////////
        
         final Reference storageRefCamion =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_Camion).child("Camion" + "-perfil-1"+id_variable);
        final UploadTask uploadTaskeCamion = storageRefCamion.putFile(
          File(_imageCamion.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrlCamion = (await uploadTaskeCamion.whenComplete(() => null));
        final String urlsCamion = (await downloadUrlCamion.ref.getDownloadURL());
        



         QuerysService().SaveCenser(idCenser: user.uid, errorFunction: _cancelSpinnerError, function: _cancelSpinnerSuccesful(user.uid), context: context, collectionValues: {
           'id' : user.uid,
           'name' : _NameConductor,
           'email' : _Email,
           'createdOn' : now,
           'description' : _paraderos,
           'category' : _NumUnidad,
           'addres' : _Placa,
           'openHours' : _horarioRutas,
           'latitude' : double.parse(_Latitiude),
           'longitude' : double.parse(_Longitude),
           'state' : _state,
           'locality' : _locality,
           'nameOwner' : _nameRuta,
           'numberOwner' : _Telefono,
           'suspended' : false,
           'photos' : urls,
           'services' : urlsPlaca,
           'licencia':urlsLicencia,
           'distanceTo' : '',
           'numUnidad':_NumUnidad,
           'placa':_Placa.toUpperCase(),
           'photoPLaca':urlsPlaca,
           'photoLicencia':urlsLicencia,
           'nameRuta':_nameRuta,
           'paraderoRuta':_paraderos,
           'camion':urlsCamion,
           'activacionesRestantes':12,
           

         });
         bool erroguardar=await QuerysService().SaveCenserVentas(reference: FirebaseReferencias.REFERENCE_ActivacionesTotalCamionero, id:user.uid, collectionValues:ActivacionesTotal().toJsonBody(
        id_variable,
        user.uid,
        1,
        12,
        now,
        _NameConductor,
        _Email,
        ),
        );
        
       }
     }
     else{
       Toast.show("Ha ocurrido un problema, Verifique su correo electronico", context, duration: Toast.LENGTH_LONG);
       _cancelSpinnerError();
     }

  
   }
   _cancelSpinnerError(){
    setState(() {
      _showSpinner = false;
    });
  }

  _cancelSpinnerSuccesful(idPropio)async{
    setState(() {
      _showSpinner = false;
      
    });
   final messages = await QuerysService().getMiInfo(miId: idPropio);
    censerList = _getCenserItem(messages.docs);

    if(censerList.length > 0){
 CenserModel adminmodel = await FetchData().getCamionero(idPropio);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen (censerModel: adminmodel)
          )
      );
      setSpinnerStatus(false);

    }
  }
}

List<CenserModel> _getCenserItem(dynamic miInfo){

    List<CenserModel> miInfoList = [];

    for(var datos in miInfo) {
      final id_ = datos.data()['id'];
      final name_ = datos.data()['name'] ?? '';
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final description_ = datos.data()['description'] ?? '';
      final category_ = datos.data()['category'] ?? '';
      final addres_ = datos.data()['addres'] ?? '';
      final openHours_ = datos.data()['openHours'] ?? '';
      final latitude_ = datos.data()['latitude'];
      final longitude_ = datos.data()['longitude'];
      final state_ = datos.data()['state'] ?? '';
      final locality_ = datos.data()['locality'] ?? '';
      final nameOwner_ = datos.data()['nameOwner'] ?? '';
      final numberOwner_ = datos.data()['numberOwner'] ?? '';
      final suspended_ = datos.data()['suspended'];
      final photos_ = datos.data()['photos'];
      final services_ = datos.data()['services'];
      final distanceTo_ = datos.data()['distanceTo'] ?? '';
      final numUnidad_ =datos.data()['numUnidad']??'';
      final placa_ = datos.data()['placa']??'';
      final photoPLaca_ = datos.data()['photoPLaca']??'';
      final photoLicencia_ = datos.data()['photoLicencia']??'';
      final nameRuta_ = datos.data()['nameRuta']??'';
      final paraderoRuta_ = datos.data()['paraderoRuta']??'';
      final imagenCamion_=datos.data()['imagenCamion']??'';
    


      CenserModel censerModel = CenserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_.toDate(),
        locality: locality_,
        state: state_,
        suspended: suspended_,
        description: description_,
        category: category_,
        addres: addres_,
        openHours: openHours_,
        latitude: latitude_,
        longitude: longitude_,
        nameOwner: nameOwner_,
        numberOwner: numberOwner_,
        photos: photos_  ,
        services: services_  ,
        distanceTo: distanceTo_,
        numUnidad:numUnidad_,
        placa:placa_,
        photoPLaca:photoPLaca_,
        photoLicencia:photoLicencia_,
        nameRuta:nameRuta_,
        paraderoRuta:paraderoRuta_,
        imagenCamion:imagenCamion_,

      );


      miInfoList.add(censerModel);
    }
    return miInfoList;
  }


