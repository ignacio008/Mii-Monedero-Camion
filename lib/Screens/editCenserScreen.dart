import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Items/itemFotosEstablecimiento.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/localitiesModel.dart';
import 'package:mega_monedero_store/Models/stateModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mega_monedero_store/MyColors/Colors.dart' as MyColors;
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class EditCenserScreen extends StatefulWidget {

  CenserModel censerModel;
  EditCenserScreen({this.censerModel});

  @override
  _EditCenserScreenState createState() => _EditCenserScreenState();
}

class _EditCenserScreenState extends State<EditCenserScreen> {

  TextEditingController _controllerNameCenser;
  TextEditingController _controllerNameOwner;
  TextEditingController _controllerNumberOwner;
  TextEditingController _controllerEmail;
  TextEditingController _controllerDescription;
  TextEditingController _controllerAddres;
  TextEditingController _controllerLatitiude;
  TextEditingController _controllerLongitude;
  TextEditingController _controllerHours;
  TextEditingController _controllerService1;
  TextEditingController _controllerService2;
  TextEditingController _controllerService3;
  TextEditingController _controllerService4;
  TextEditingController _controllerService5;
  bool _showSpinner = true;
  String _category = "";
  String _state = "Agregar estado";
  String _locality = "Agregar municipio";
  List<String> servicesList = [];
  List<String> categories = [];
  List<StateModel> stateList = [];
  List<LocalityModel> localityList = [];
  List<LocalityModel> localityListFiltered = [];
  bool _suspended;
  double widthScreen;
  List<String> imagesNetwork = [];
  File file1, file2, file3;
  bool isUploaded1, isUploaded2, isUploaded3;
  List<String> urlFotos = ["","",""];

  Future<String> _loadASmaeAsset() async {
    return await rootBundle.loadString('assets/estados.json');
  }

  loadStates() async {
    String jsonString = await _loadASmaeAsset();
    var jsonResponse = json.decode(jsonString) as List;

    stateList = jsonResponse.map((i) => StateModel.fromJson(i)).toList();

  }

  Future<String> _loadLocalitiesAsset() async {
    return await rootBundle.loadString('assets/result.json');
  }

  loadLocalities() async {
    String jsonString = await _loadLocalitiesAsset();
    var jsonResponse = json.decode(jsonString) as List;

    localityList = jsonResponse.map((i) => LocalityModel.fromJson(i)).toList();

    setState(() {
      _showSpinner = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStates();
    loadLocalities();

    _controllerNameCenser = TextEditingController();
    _controllerNameOwner = TextEditingController();
    _controllerNumberOwner = TextEditingController();
    _controllerEmail = TextEditingController();
    _controllerDescription = TextEditingController();
    _controllerAddres = TextEditingController();
    _controllerLatitiude = TextEditingController();
    _controllerLongitude = TextEditingController();
    _controllerHours = TextEditingController();
    _controllerService1 = TextEditingController();
    _controllerService2 = TextEditingController();
    _controllerService3 = TextEditingController();
    _controllerService4 = TextEditingController();
    _controllerService5 = TextEditingController();

    categories.add("AUTOLAVADO");
    categories.add("BAÑOS PÚBLICOS");
    categories.add("CERRAJERÍAS");
    categories.add("CIBER");
    categories.add("DENTISTA");
    categories.add("ELÉCTRICO");
    categories.add("ELECTRICISTA");
    categories.add("ESCUELA DE BAILE");
    categories.add("ESCUELA DE BELLEZA");
    categories.add("ESCUELA DE DANZA");
    categories.add("ESCUELA DE IDIOMAS");
    categories.add("ESCUELA DE NATACIÓN");
    categories.add("ESTACIONAMIENTO");
    categories.add("ESTÉTICA");
    categories.add("GIMNASIO");
    categories.add("JARDINERO");
    categories.add("LABORATORIO CLÍNICO");
    categories.add("LAVANDERÍAS");
    categories.add("LUSTADOR DE ZAPATOS");
    categories.add("MECÁNICO AUTOMOTRIZ");
    categories.add("MÉDICO");
    categories.add("MODISTA");
    categories.add("ÓPTICAS");
    categories.add("PINTOR");
    categories.add("PLOMERO");
    categories.add("REPARACIÓN DE CALZADO");
    categories.add("SPA");
    categories.add("TALLER DE BICICLETAS");
    categories.add("TÉCNICO EN REPARACIÓN DE CELULARES");
    categories.add("TÉCNICO EN REPARACIÓN DE ELECTRODOMÉSTICOS");
    categories.add("VETERINARIO");
    categories.add("VULCANIZADORA");

    _category = widget.censerModel.category;
    _state = widget.censerModel.state;
    _locality = widget.censerModel.locality;
    _suspended = widget.censerModel.suspended;
    
    for(int i = 0; i < widget.censerModel.photos.length; i++){
      imagesNetwork.add(widget.censerModel.photos);
    }
    urlFotos = imagesNetwork;

    _controllerNameCenser.text = widget.censerModel.name;
    _controllerNameOwner.text = widget.censerModel.nameOwner;
    _controllerNumberOwner.text = widget.censerModel.numberOwner;
    _controllerEmail.text = widget.censerModel.email;
    _controllerDescription.text = widget.censerModel.description;
    _controllerAddres.text = widget.censerModel.addres;
    _controllerLatitiude.text = widget.censerModel.latitude.toString();
    _controllerLongitude.text = widget.censerModel.longitude.toString();
    _controllerHours.text = widget.censerModel.openHours;
    _controllerService1.text = widget.censerModel.services[0];

    if(widget.censerModel.services.length == 2){
      _controllerService2.text = widget.censerModel.services[1];
    }
    else if(widget.censerModel.services.length == 3){
      _controllerService2.text = widget.censerModel.services[1];
      _controllerService3.text = widget.censerModel.services[2];
    }
    else if(widget.censerModel.services.length == 4){
      _controllerService2.text = widget.censerModel.services[1];
      _controllerService3.text = widget.censerModel.services[2];
      _controllerService4.text = widget.censerModel.services[3];
    }
    else if(widget.censerModel.services.length == 5){
      _controllerService2.text = widget.censerModel.services[1];
      _controllerService3.text = widget.censerModel.services[2];
      _controllerService4.text = widget.censerModel.services[3];
      _controllerService5.text = widget.censerModel.services[4];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controllerNameCenser.dispose();
    _controllerNameOwner.dispose();
    _controllerNumberOwner.dispose();
    _controllerEmail.dispose();
    _controllerDescription.dispose();
    _controllerAddres.dispose();
    _controllerLatitiude.dispose();
    _controllerLongitude.dispose();
    _controllerHours.dispose();
    _controllerService1.dispose();
    _controllerService2.dispose();
    _controllerService3.dispose();
    _controllerService4.dispose();
    _controllerService5.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Editar CENSER"
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Fotos del establecimiento"
                ),
                // Container(
                //   height: (widthScreen/2) * 0.6,
                //   child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: 1,
                //       itemBuilder: (BuildContext ctxt, int index) {
                //         if(index == 0){
                //           return ItemFotoEstablecimiento(widthPantalla: widthScreen, urlFoto: imagesNetwork[index], numero: index + 1, function: _getFile, update: _updateUploaded, fileWidget: file1, censerModel: widget.censerModel);
                //         }
                //         else if(index == 1){
                //           return ItemFotoEstablecimiento(widthPantalla: widthScreen, urlFoto: imagesNetwork[index], numero: index + 1, function: _getFile, update: _updateUploaded, fileWidget: file2, censerModel: widget.censerModel);
                //         }
                //         else{
                //           return ItemFotoEstablecimiento(widthPantalla: widthScreen, urlFoto: imagesNetwork[index], numero: index + 1, function: _getFile, update: _updateUploaded, fileWidget: file3, censerModel: widget.censerModel);
                //         }


                //       }
                //   ),
                // ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Categoría del centro de servicio"
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child: Text(
                            _category,
                            style: TextStyle(
                                color: MyColors.Colors.colorBackgroundDark
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        _showCategories();
                      },
                      child: Container(
                        height: 40.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]
                        ),
                        child: Center(
                          child: Text(
                              "Agregar"
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Nombre del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerNameCenser,
                      textCapitalization: TextCapitalization.words,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                /*
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Nombre del dueño o dueña del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerNameOwner,
                      textCapitalization: TextCapitalization.words,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Número de teléfono del dueño o dueña del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerNumberOwner,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),

                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Correo electrónico del dueño o dueña del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),

                 */
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Descripción del centro de servicio"
                ),
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerDescription,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                /*
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Estado y municipio del centro de servicio"
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          _showStatesDialog();
                        },
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]
                          ),
                          child: Center(
                            child: Text(
                              _state,
                              style: TextStyle(
                                  color: MyColors.Colors.colorBackgroundDark
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          if(_state == "Agregar estado"){
                            Toast.show("Debes seleccionar el estado primero", context, duration: Toast.LENGTH_LONG);
                          }
                          else{
                            _showLocalitiesDialog();
                          }
                        },
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]
                          ),
                          child: Center(
                            child: Text(
                              _locality,
                              style: TextStyle(
                                  color: MyColors.Colors.colorBackgroundDark
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    )
                  ],
                ),

                 */
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Dirección del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerAddres,
                      textCapitalization: TextCapitalization.sentences,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                /*
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Latitud del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerLatitiude,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Longitud del centro de servicio"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerLongitude,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),

                 */
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Horario en el que está abierto el centro de servicio"
                ),
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerHours,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Servicio 1 que ofrece (obligatorio)"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerService1,
                      textCapitalization: TextCapitalization.sentences,
                      //obscureText: true,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Servicio 2 que ofrece (opcional)"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerService2,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Servicio 3 que ofrece (opcional)"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerService3,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Servicio 4 que ofrece (opcional)"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerService4,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Servicio 5 que ofrece (opcional)"
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _controllerService5,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontFamily: 'Futura',
                          color: MyColors.Colors.colorBackgroundDark
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Futura',
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: (){
                    _processCenserRegister();
                  },
                  child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Center(
                        child: Text(
                          "Actualizar Información",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(
                  height: 25.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategories(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "CATEGORÍAS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.9,
        height:MediaQuery.of(context).size.height*0.8,
        child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _category = categories[index];
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          categories[index]
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

  void _showStatesDialog(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "ESTADOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: ListView.builder(
          itemCount: stateList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _state = stateList[index].nombre;
                    _locality = "Agregar municipio";

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
      content: ListView.builder(
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

  _processCenserRegister() async {

    FocusScope.of(context).requestFocus(FocusNode());

    String _NameCenser = _controllerNameCenser.text;
    String _NameOwner = _controllerNameOwner.text;
    String _NumberOwner  = _controllerNumberOwner.text;
    String _Email = _controllerEmail.text.trim();
    String _Description = _controllerDescription.text;
    String _Addres = _controllerAddres.text;
    String _Latitiude = _controllerLatitiude.text;
    String _Longitude = _controllerLongitude.text;
    String _Hours = _controllerHours.text;
    String _Service1 = _controllerService1.text;
    String _Service2 = _controllerService2.text;
    String _Service3 = _controllerService3.text;
    String _Service4 = _controllerService4.text;
    String _Service5 = _controllerService5.text;

    if(_NameCenser.length < 3){
      Toast.show("Debes introducir un nombre del centro de servicio válido", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_NameOwner.length < 3){
      Toast.show("Debes introducir un nombre del propietario del centro de servicio válido", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_NumberOwner.length < 6){
      Toast.show("Debes introducir un número del propietario del centro de servicio válido", context, duration: Toast.LENGTH_LONG);
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
    if(_Description.length < 10){
      Toast.show("Debes introducir una descripción del centro de servicio válida", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_Addres.length < 10){
      Toast.show("Debes introducir una dirección del centro de servicio válida", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_Latitiude.length < 5){
      Toast.show("Debes introducir la latitud centro de servicio correctamente", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_Longitude.length < 3){
      Toast.show("Debes introducir la longitud del centro de servicio correctamente", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_Hours.length < 3){
      Toast.show("Debes introducir el horario del centro de servicio correctamente", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_Service1.length < 3){
      Toast.show("Debes introducir por lo menos un servicio del centro de servicio", context, duration: Toast.LENGTH_LONG);
      return;
    }

    servicesList.add(_Service1);
    if(_Service2.length > 3){
      servicesList.add(_Service2);
    }
    if(_Service3.length > 3){
      servicesList.add(_Service3);
    }
    if(_Service4.length > 3){
      servicesList.add(_Service4);
    }
    if(_Service5.length > 3){
      servicesList.add(_Service5);
    }

    setSpinnerStatus(true);

    QuerysService().SaveCenser(idCenser: widget.censerModel.id, errorFunction: _cancelSpinnerError, function: _cancelSpinnerSuccesful(), context: context, collectionValues: {
      'id' : widget.censerModel.id,
      'name' : _NameCenser,
      'email' : widget.censerModel.email,
      'createdOn' : widget.censerModel.createdOn,
      'description' : _Description,
      'category' : _category,
      'addres' : _Addres,
      'openHours' : _Hours,
      'latitude' : double.parse(_Latitiude),
      'longitude' : double.parse(_Longitude),
      'state' : _state,
      'locality' : _locality,
      'nameOwner' : _NameOwner,
      'numberOwner' : _NumberOwner,
      'suspended' : _suspended,
      'photos' : urlFotos,
      'services' : servicesList,
      'distanceTo' : '',
    });
  }

  _cancelSpinnerError(){
    setState(() {
      _showSpinner = false;
    });
  }

  _cancelSpinnerSuccesful(){
    setState(() {
      _showSpinner = false;
    });
    Navigator.of(context).pop();
  }

  void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  _getFile(File filePath, int number, bool isUploaded)async{

    setState(()   {
      });
      if(number == 1){
        file1 = filePath;
        if(isUploaded){
          isUploaded1= true;
        }
        else{
          isUploaded1 = false;
        }

        final Reference storageRef =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_CENSERS).child(widget.censerModel.name + "-perfil-1");
    //en lugar de settableMetadata es StorageMetadata
        final UploadTask uploadTask = storageRef.putFile(
          File(file1.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );

        final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
        final String url = (await downloadUrl.ref.getDownloadURL());
        urlFotos[0] = url;
        imagesNetwork[0] = urlFotos[0];
        Toast.show("Foto 1 subida con éxito", context, duration: Toast.LENGTH_SHORT);
        QuerysService().updateFotosEstablecimientoData(idEstablecimiento: widget.censerModel.id, context: context, collectionValues: imagesNetwork);
        setState(() {
          isUploaded1 = true;
        });
      }
      if(number == 2){
        if(isUploaded){
          isUploaded2= true;
        }
        else{
          isUploaded2 = false;
        }
        file2 = filePath;

        final Reference storageRef =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_CENSERS).child(widget.censerModel.name + "-perfil-2");
//en lugar de settableMetadata es StorageMetadata
        final UploadTask uploadTask = storageRef.putFile(
          File(file2.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );

        final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
        final String url = (await downloadUrl.ref.getDownloadURL());
        urlFotos[1] = url;
        imagesNetwork[1] = urlFotos[1];
        Toast.show("Foto 2 subida con éxito", context, duration: Toast.LENGTH_SHORT);
        QuerysService().updateFotosEstablecimientoData(idEstablecimiento: widget.censerModel.id, context: context, collectionValues: imagesNetwork);
        setState(() {
          isUploaded2 = true;
        });
      }
      if(number == 3){
        if(isUploaded){
          isUploaded3 = true;
        }
        else{
          isUploaded3 = false;
        }
        file3 = filePath;

        final Reference storageRef =
        FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_CENSERS).child(widget.censerModel.name + "-perfil-3");

        final UploadTask uploadTask = storageRef.putFile(
          File(file3.path),
          SettableMetadata(
            contentType: "image" + '/' + "png",
          ),
        );

        final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
        final String url = (await downloadUrl.ref.getDownloadURL());
        urlFotos[2] = url;
        imagesNetwork[2] = urlFotos[2];
        Toast.show("Foto 3 subida con éxito", context, duration: Toast.LENGTH_SHORT);
        QuerysService().updateFotosEstablecimientoData(idEstablecimiento: widget.censerModel.id, context: context, collectionValues: imagesNetwork);

        setState(() {
          isUploaded3 = true;
        });
      }
    

  }

  _updateUploaded(int number, bool isUploaded){
    setState(() {

      if(number == 1){
        if(isUploaded){
          isUploaded1 = true;
        }
        else{
          imagesNetwork[0] = "https://firebasestorage.googleapis.com/v0/b/mega-monedero.appspot.com/o/photo_default.jpg?alt=media&token=02df7823-7d9d-42d2-84c9-218eca5b9c74";
          isUploaded1 = false;
        }
      }
      if(number == 2){
        if(isUploaded){
          isUploaded2= true;
        }
        else{
          imagesNetwork[1] = "https://firebasestorage.googleapis.com/v0/b/mega-monedero.appspot.com/o/photo_default.jpg?alt=media&token=02df7823-7d9d-42d2-84c9-218eca5b9c74";
          isUploaded2 = false;
        }
      }
      if(number == 3){
        if(isUploaded){
          isUploaded3 = true;
        }
        else{
          imagesNetwork[2] = "https://firebasestorage.googleapis.com/v0/b/mega-monedero.appspot.com/o/photo_default.jpg?alt=media&token=02df7823-7d9d-42d2-84c9-218eca5b9c74";
          isUploaded3 = false;
        }
      }

      QuerysService().updateFotosEstablecimientoData(idEstablecimiento: widget.censerModel.id, context: context, collectionValues: imagesNetwork);
    });
  }


}
