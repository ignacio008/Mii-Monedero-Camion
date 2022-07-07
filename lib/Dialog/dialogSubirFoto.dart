import 'package:flutter/material.dart';

class DialogSubirFoto extends StatefulWidget {

  Function cameraFunction;
  Function galleryFunction;
  DialogSubirFoto({this.cameraFunction, this.galleryFunction});

  @override
  _DialogSubirFotoState createState() => _DialogSubirFotoState();
}

class _DialogSubirFotoState extends State<DialogSubirFoto> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // para hacer la carta compacta
        children: <Widget>[
          Text(
            "SUBIR FOTO",
            style: TextStyle(
                fontFamily: 'Futura',
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Por favor, seleccione si desea subir su foto desde la cámara o desde la galería",
              style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: IconButton(
                      icon: Icon(
                          Icons.camera_alt,
                        size: 65.0,
                        color: Colors.grey,
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                        widget.cameraFunction();
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.photo,
                        size: 65.0,
                          color: Colors.grey
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                        widget.galleryFunction();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }
}
