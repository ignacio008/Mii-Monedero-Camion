import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Screens/edit_user_camionero.dart';
import 'package:mega_monedero_store/Screens/status_camionero.dart';

import '../Firebase/authentication.dart';
import '../Models/censerModel.dart';
import 'loginScreen.dart';

class DrawerMenu extends StatefulWidget {
  CenserModel censerModel;
  DrawerMenu(this.censerModel);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
             
                UserAccountsDrawerHeader(
                accountName: Text("Bienvenido ${widget.censerModel.name}"),
                 accountEmail: Text("Correo: ${widget.censerModel.email}"),
                 
                 currentAccountPicture:  

            CircleAvatar(   
                radius: 30.0,
               backgroundImage:
               widget.censerModel.photos!=null?     NetworkImage(
                      "${widget.censerModel.photos}",)
                      :AssetImage("assets/images/user3.png"),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                ),
                otherAccountsPictures: <Widget>[
                
                ],
                
                // onDetailsPressed: (){
                //    Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateUser(widget.iconmodel)));
                
                // },
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors:[Color.fromARGB(255, 209, 4, 1), Color.fromARGB(255, 91, 9, 9)] ),
                  ),                 
                 
                 ),
                 
                ListTile(title: Text("Inicio"),
                leading: Icon(Icons.home, color:Colors.blueGrey[400]),
                onTap:(){
                   Navigator.pop(context);
                },
                ),

                
                
                ListTile(title: Text("Edite su Usuario"),
                leading: Icon(Icons.people, color:Colors.blueGrey[400]),
                onTap:
                ()=> irEditarUsuario(context)
                 
                ),

                // codigo qr vinculado
                // ListTile(title: Text("Codigo QR"),
                // leading: Icon(Icons.qr_code_2_rounded, color:Colors.black),
                // onTap:()=>ir_qr(context),
                // ),
              ListTile(
                title: Text("Estatus del camionero"),
                leading: Icon(Icons.addchart, color: Colors.blueGrey[400],),
                onTap: () => irStatusCamionero(context),
              ),

              

                

                ListTile(title: Text("Cerrar Sesion"),
                leading: Icon(Icons.power_settings_new, color:Colors.red),
                onTap:()=>mostrarDialogo(context),
                ),
            ], 
          ),
      ); 
  }

  irEditarUsuario(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditarUsuarioCamionero(widget.censerModel)));
  }irStatusCamionero(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>StatusCamionero(widget.censerModel)));
  }

   void cerrarSesion() async{
     Authentication().singOut();
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void mostrarDialogo(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
              title: Text("Cerrar Sesion"),
              content: Text("¿Estas Seguro que deseas cerrar sesion?"),
              actions: <Widget>[
                TextButton(
                  child: Text("No", style: (TextStyle(color: Colors.blue))),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Si"),
                  onPressed: (){
                    cerrarSesion();
                  },
                ),

                
              ],
          );//alertdialogo
       },//finshowdialog
          barrierDismissible: false);
      
  }
}