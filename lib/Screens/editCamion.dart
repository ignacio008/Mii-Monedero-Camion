import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_monedero_store/Dialog/dialogSubirFoto.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/localitiesModel.dart';
import 'package:mega_monedero_store/Models/stateModel.dart';
import 'package:mega_monedero_store/Models/userModel.dart';


import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero_store/Screens/mainScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class EditCamion extends StatefulWidget {
  CenserModel censerModel;
  EditCamion(this.censerModel);

  @override
  State<EditCamion> createState() => _EditCamionState();
}

class _EditCamionState extends State<EditCamion> {
  bool _suspended;
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Text(
            "Editar Camion"
        ),
      ),
      body: widget.censerModel==null?Center(child: CircularProgressIndicator()):
       ModalProgressHUD(
        color:Colors.red[800],
        progressIndicator :const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
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
                      SizedBox(height: 35.0),
                      
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Colors.grey[300],
                          ) ,
                          child : _image == null ? Stack(
                            children: [
                                 Container(
                          height: 180.0,
                          width: 180.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Colors.white,                      
                          ) ,
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(150.0),
                                     child: Image.network(widget.censerModel.photos,fit: BoxFit.cover, 
                loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
                   if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: Container(
              width:200,
              height:200,
              child: Transform.scale(
                scale:0.7,
                child: CircularProgressIndicator(
                ),
              ),
            ),
          );
                },    
                  ),
                                   ),
                                 ),

                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      color: Colors.white,
                                      size: 65.0,
                                    ),
                                    SizedBox(height: 5,),
                                    Text("Foto de perfil",
                                    style:TextStyle(
                                      color: Colors.white,
                                    )),
                                  ],
                                ),
                              ),

                           
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
                                    //obscureText: true,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: widget.censerModel.name,
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
                      // SizedBox(height: 15.0),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //         flex: 1,
                      //         child: GestureDetector(
                      //           onTap: (){
                      //             _showStatesDialog();
                      //           },
                      //           child: Container(
                      //               height: 42.0,
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(30.0),
                      //                 border: Border.all(
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //               child: Center(
                      //                 child: Text(
                      //                   widget.censerModel.state,
                      //                   style: TextStyle(
                      //                     color: Colors.white
                      //                   ),
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               )
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 10.0,
                      //       ),
                      //       Expanded(
                      //         flex: 1,
                      //         child: GestureDetector(
                      //           onTap: (){
                      //             if(_state != "Estado"){
                      //               _showLocalitiesDialog();
                      //             }
                      //             else{
                      //               Toast.show("Debes seleccionar primero el estado", context, duration: Toast.LENGTH_LONG);
                      //             }
                      //           },
                      //           child: Container(
                      //             height: 42.0,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(30.0),
                      //               border: Border.all(
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //             child:  Center(
                      //               child: Text(
                      //                 widget.censerModel.locality,
                      //                 style: TextStyle(
                      //                     color: Colors.white
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             )
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                                    controller: _phoneController,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: widget.censerModel.numberOwner,
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
                                            style: TextStyle(
                                              fontFamily: 'Futura',
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                                hintText: widget.censerModel.numUnidad,
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
                                            style: TextStyle(
                                              fontFamily: 'Futura',
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                                hintText: widget.censerModel.placa,
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            image:DecorationImage(
                              image :NetworkImage(widget.censerModel.photoPLaca),
                              fit:BoxFit.cover,
                            ),
                          ) ,
                          child : _imagePlaca == null ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color:Colors.white,
                                size: 40.0,
                              ),
                              SizedBox(height: 5,),
                              Text("Placa del Camion",
                              style:TextStyle(
                                color: Colors.white,
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                            image:DecorationImage(
                              image :NetworkImage(widget.censerModel.photoLicencia),
                              fit:BoxFit.cover,
                            ),
                          ) ,
                          child : _imageLicencia == null ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                                size: 40.0,
                              ),
                              SizedBox(height: 5,),
                              Text("Foto de Licencia",
                              style:TextStyle(
                                color: Colors.white,
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    image:DecorationImage(
                              image :NetworkImage(widget.censerModel.imagenCamion),
                              fit:BoxFit.cover,
                            ),
                                  ) ,
                                  child : _imageCamion == null ? Stack(
                                    children: [
                                          Container(
                          height: 180.0,
                          width: 280.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,                      
                          ) ,
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(10.0),
                                     child: Image.network(widget.censerModel.imagenCamion,fit: BoxFit.cover, 
                loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
                   if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: Container(
              width:200,
              height:200,
              child: Transform.scale(
                scale:0.78,
                child: CircularProgressIndicator(
                ),
              ),
            ),
          );
                },    
                  ),
                                   ),
                                 ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.white,
                                              size: 65.0,
                                            ),
                                            SizedBox(height: 5,),
                                            Text("Foto del Camion",
                                            style:TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            )),
                                          ],
                                        ),
                                      ),
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
                                              _statenombreRta=='Nombre de la ruta'?widget.censerModel.nameRuta:_statenombreRta,
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
                      //obscureText: true,
                     style: TextStyle(
                        fontFamily: 'Futura',
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText:widget.censerModel.paraderoRuta,
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
                      //obscureText: true,
                     style: TextStyle(
                        fontFamily: 'Futura',
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText:widget.censerModel.openHours,
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

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
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

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }


void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  _processCenserRegister() async {

    FocusScope.of(context).requestFocus(FocusNode());

   String _NameConductor = _nameController.text;
    String _estado = _state;
    String _municipio  = _locality;
    String _Telefono = _phoneController.text.trim();
    String _Email = _emailController.text.trim();
    String _NumUnidad = _numUnidadController.text.trim();
    String _Placa = _placaController.text.trim();

    String _nameRuta=_statenombreRta;
    String _paraderos=_ParaderosRutasController.text.trim();
    String _horarioRutas=_horarioRutasController.text.trim();
    String urls;
    String urlsPlaca;
    String urlsLicencia;
    String urlsCamion;

setSpinnerStatus(true);

      if(_image!=null){
      final Reference storageRef =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_CENSERS).child("Perfil" + "-perfil-1"+widget.censerModel.id);
        final UploadTask uploadTaske = storageRef.putFile(
          File(_image.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrl = (await uploadTaske.whenComplete(() => null));
          urls = (await downloadUrl.ref.getDownloadURL());
        print("imagen subida"+urls);
      }else{
        print("imagen no subida");
      }

       if(_imagePlaca!=null){
        final Reference storageRefPlaca =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_Placa).child("PLaca" + "-perfil-1"+widget.censerModel.id);
        final UploadTask uploadTaskePlca = storageRefPlaca.putFile(
          File(_imagePlaca.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrlPlaca = (await uploadTaskePlca.whenComplete(() => null));
       urlsPlaca = (await downloadUrlPlaca.ref.getDownloadURL());
       }
      /////////////////////////
       if(_imageLicencia!=null){
         final Reference storageRefLicencia =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_Licencia).child("Licencia" + "-perfil-1"+widget.censerModel.id);
        final UploadTask uploadTaskeLicencia = storageRefLicencia.putFile(
          File(_imageLicencia.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrlLicencia = (await uploadTaskeLicencia.whenComplete(() => null));
      urlsLicencia = (await downloadUrlLicencia.ref.getDownloadURL());
       }
        //////////////////////////////////
         if(_imageCamion!=null){
         final Reference storageRefCamion =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_Camion).child("Camion" + "-perfil-1"+widget.censerModel.id);
        final UploadTask uploadTaskeCamion = storageRefCamion.putFile(
          File(_imageCamion.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );
        final TaskSnapshot downloadUrlCamion = (await uploadTaskeCamion.whenComplete(() => null));
         urlsCamion = (await downloadUrlCamion.ref.getDownloadURL());
         }




    

    QuerysService().UpdateCenser(idCenser: widget.censerModel.id, errorFunction: _cancelSpinnerError, function: _cancelSpinnerSuccesful(widget.censerModel.id), context: context, collectionValues: {
      'id' : widget.censerModel.id,
      'name' : _NameConductor.isEmpty?widget.censerModel.name:_NameConductor,
      'email' : widget.censerModel.email,
      'createdOn' : widget.censerModel.createdOn,
      'state' : _state,
      'locality' : _locality,
      'suspended' : widget.censerModel.suspended,
      'paraderoRuta':_paraderos.isEmpty?widget.censerModel.paraderoRuta:_paraderos,
      'nameRuta':_nameRuta=='Nombre de la ruta'?widget.censerModel.nameRuta:_nameRuta,
      'numUnidad':_NumUnidad.isEmpty?widget.censerModel.numUnidad:_NumUnidad,
      'placa':_Placa.isEmpty?widget.censerModel.placa:_Placa.toUpperCase(),
      'numberOwner':_Telefono.isEmpty?widget.censerModel.numberOwner:_Telefono,
      'openHours' : _horarioRutas.isEmpty?widget.censerModel.openHours:_horarioRutas,
      'photos':urls==null?widget.censerModel.photos:urls,
      'photoPLaca':urlsPlaca==null?widget.censerModel.photoPLaca:urlsPlaca,
      'photoLicencia':urlsLicencia==null?widget.censerModel.photoLicencia:urlsLicencia,
      'camion':urlsCamion==null?widget.censerModel.imagenCamion:urlsCamion,
      'distanceTo' : '',
    });
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

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen (censerModel: censerList[0])
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
      final imagenCamion_=datos.data()['camion']??'';
    


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