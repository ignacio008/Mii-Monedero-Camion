import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_monedero_store/Dialog/dialogSubirFoto.dart';
import 'package:mega_monedero_store/Firebase/firebase_referencias.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:toast/toast.dart';

class ItemFotoEstablecimiento extends StatefulWidget {

  double widthPantalla;
  String urlFoto;
  int numero;
  Function function;
  Function update;
  File fileWidget;
  CenserModel censerModel;
  ItemFotoEstablecimiento({this.widthPantalla, this.urlFoto, this.numero, this.function, this.update, this.fileWidget, this.censerModel});

  @override
  _ItemFotoEstablecimientoState createState() => _ItemFotoEstablecimientoState();
}

class _ItemFotoEstablecimientoState extends State<ItemFotoEstablecimiento> {

  String agregarTexto;
  File _image;

  void _getImageGallery() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 480);

    setState(() {
      widget.function(File(image.path), widget.numero, false);
      _image ==File(image.path);
    });
  }

  void _getImageCamera() async {
     final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera, maxHeight: 480);

    setState(() {
      widget.function(File(image.path), widget.numero, false);
      _image ==File(image.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = widget.fileWidget;
  }

  @override
  Widget build(BuildContext context) {

    if(widget.urlFoto != "https://firebasestorage.googleapis.com/v0/b/mega-monedero.appspot.com/o/photo_default.jpg?alt=media&token=02df7823-7d9d-42d2-84c9-218eca5b9c74"){
      return _foto();
    }
    else{
      return _espacioVacio();
    }
  }


  Widget _foto(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/fondo_negro.jpg",
              image: widget.urlFoto,
              fit: BoxFit.cover,
              width: widget.widthPantalla/2,
              height: (widget.widthPantalla/2) * 0.6,
              fadeInDuration: Duration(milliseconds: 1000),
            ),
          ),
          GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: Text("Eliminar Foto"),
                    content: Text("¿Desea eliminar esta foto?"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child: new Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: new Text("Eliminar"),
                        onPressed: () {
                          // AQUI HAY QUE ACTUALIZAR
                          FirebaseStorage.instance.ref().child(FirebaseReferencias.REFERENCE_CENSERS).child(widget.censerModel.name + "-perfil-" + widget.numero.toString()).delete().then((_){
                            Toast.show("Foto eliminada correctamente", context);
                            widget.update(widget.numero, false);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 1.0,
                    top: 1.0,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.delete,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _espacioVacio(){

    agregarTexto = "Agregar imagen número " + widget.numero.toString();
    return GestureDetector(
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogSubirFoto(
              cameraFunction: _getImageCamera,
              galleryFunction: _getImageGallery,
            )
        );
      },
      child: _image == null ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: widget.widthPantalla/2,
            height: (widget.widthPantalla/2) * 0.6,
            decoration: BoxDecoration(
              color: Colors.black
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    agregarTexto,
                    style: TextStyle(
                      fontFamily: 'Futura',
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ) :  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.file(_image, width: widget.widthPantalla/2,
              height: (widget.widthPantalla/2) * 0.6, fit: BoxFit.cover),
          ),
          ) ,
    );
  }
}
