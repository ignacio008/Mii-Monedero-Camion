import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget{

  final String inputText;
  final bool obscureText;
  final ValueChanged<String> onSaved;
  final TextInputType textInputType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;
  final AutovalidateMode  autoValidate;

  //final IconButton iconButton;

  const AppTextField({this.inputText, this.onSaved, this.obscureText, this.textInputType, this.controller, this.focusNode, this.validator, this.autoValidate});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
        elevation: 3.0,
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: TextFormField(
          autovalidateMode: autoValidate,
          validator: validator,
          focusNode: focusNode,
          controller: controller,
          keyboardType: textInputType,
          obscureText: obscureText == null ? false : obscureText,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Barlow',
            fontWeight: FontWeight.w500,
          ),
          //textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white70,
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            hintText: "",
            //suffixIcon: iconButton,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.white70, width: 0.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.white70, width: 0.0)
            ),
          ),
          onSaved: onSaved,
        )
    );
  }


}