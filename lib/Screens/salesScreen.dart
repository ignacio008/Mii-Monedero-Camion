import 'package:flutter/material.dart';
import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Items/salesItem.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/salesModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class SalesScreen extends StatefulWidget {

  CenserModel censerModel;
  SalesScreen({this.censerModel});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  bool _showSpinner = true;
  List<SalesModel> earningsList = [];

  void _getSales() async {

    setSpinnerStatus(true);
    final messages = await QuerysService().getMyLastSales(miId: widget.censerModel.id);
    earningsList = _getSalesItem(messages.docs);

    if(earningsList.length > 0){

      setSpinnerStatus(false);

    }
    else{
      setSpinnerStatus(false);
      Toast.show("No Tienes ninguna activacion realizada", context, duration: Toast.LENGTH_LONG);
    }
  }

  List<SalesModel> _getSalesItem(dynamic miInfo){

    List<SalesModel> miInfoList = [];

    String id;
    String storeId;
    String nameStore;
    String categoryStore;
    DateTime dateTime;
    String userId;
    String nameUser;
    String numberOwner;
    String nameOwner;
    String state;
    String locality;
    int numberSales;

    for(var datos in miInfo) {
      final id_ = datos.data()['id'];
      final storeId = datos.data()['storeId'] ?? '';
      final nameStore = datos.data()['nameStore'] ?? '';
      final dateTime = datos.data()['dateTime'];
      final categoryStore = datos.data()['categoryStore'] ?? '';
      final userId = datos.data()['userId'] ?? '';
      final nameUser = datos.data()['nameUser'] ?? '';
      final numberOwner = datos.data()['numberOwner'] ?? '';
      final nameOwner = datos.data()['nameOwner'];
      final state = datos.data()['state'];
      final locality = datos.data()['locality'] ?? '';

      SalesModel salesModel = SalesModel(
          id: id_,
          storeId: storeId,
          nameStore: nameStore,
          dateTime: dateTime.toDate(),
          categoryStore: categoryStore,
          userId: userId,
          nameUser: nameUser,
          numberOwner: numberOwner,
          nameOwner: nameOwner,
          state: state,
          locality: locality,
          numberSales: numberSales
      );
      miInfoList.add(salesModel);
    }
    return miInfoList;
  }

  void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSales();
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
                "Mii Monedero Chofer",
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              _earningsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _earningsList(){

    if(earningsList.length > 0){
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Flexible(
          child: ListView.builder(
              itemCount: earningsList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return SalesItem(salesModel: earningsList[index]);
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
