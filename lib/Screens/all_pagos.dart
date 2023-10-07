import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Firebase/fetch_data.dart';
import 'package:mega_monedero_store/Items/widget_all_pagos.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class TodosPagos extends StatefulWidget {
  CenserModel censerModel;
  TodosPagos(this.censerModel);

  @override
  State<TodosPagos> createState() => _TodosPagosState();
}

class _TodosPagosState extends State<TodosPagos> {
   List<PagoModel> iconModelList=[];
    bool _showSpinner = true;

  String statusNoPagado="No pagado";
  String statusPagado="pagada";
 void getlista(String idusuario)async{
    iconModelList=await FetchData().getPagosCamionero(idusuario);
    print('Tengo ${iconModelList.length} cards');
    
    if(iconModelList.length > 0){

      setSpinnerStatus(false);

    }
    else{
      setSpinnerStatus(false);
      Toast.show("No Tienes ninguna compra realizada", context, duration: Toast.LENGTH_LONG);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    
    getlista(widget.censerModel.id);
    super.initState();
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Mii Boletinaje",
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              _pagos(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _pagos(){

    if(iconModelList.length > 0){
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Flexible(
          child: ListView.builder(
              itemCount: iconModelList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return WidgetAllPagos(widget.censerModel, iconModelList[index]);
              }
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }
}