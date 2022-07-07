import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'app_textfield_login.dart';

class DialogResetContrasena extends StatefulWidget {

  Function function;
  DialogResetContrasena({this.function});


  @override
  _DialogResetContrasenaState createState() => _DialogResetContrasenaState();
}

class _DialogResetContrasenaState extends State<DialogResetContrasena> {

  TextEditingController _emailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }
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
            "RECUPERAR CONTRASEÑA",
            style: TextStyle(
                color: Colors.black54,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w500,
                fontSize: 18.0
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              "Por favor, introduzca su correo electrónico de registro para reestablecer su contraseña",
              style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          _passwordField(),
          SizedBox(
            height: 30.0,
          ),
          _btnRegistrarse(),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _passwordField(){
    return AppTextField(
      autoValidate: false,
      obscureText: false,
      controller: _emailController,
      inputText: "ejemplo@gmail.com",
      onSaved: (value){

      },

    );
  }

  Widget _btnRegistrarse(){
    return Container(
      height: 42.0,
      width: 220.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: Colors.black, width: 2.0)),
        onPressed: () {
          if(_emailController.text.length > 4 && _emailController.text.contains("@")){
            widget.function(_emailController.text.trim());
            Navigator.of(context).pop();
          }
          else{
            Toast.show("Ingresa un correo válido", context, duration: Toast.LENGTH_LONG);
          }
        },
        color: Colors.black,
        textColor: Colors.white,
        child: Text("REESTABLECER".toUpperCase(),
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Futura'
            )
        ),
      ),
    );
  }


}
