import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';

class WidgetAllPagos extends StatefulWidget {
  CenserModel iconmodelCamionero;
  PagoModel iconmodelPago;
  WidgetAllPagos(this.iconmodelCamionero,this.iconmodelPago);

  @override
  State<WidgetAllPagos> createState() => _WidgetAllPagosState();
}

class _WidgetAllPagosState extends State<WidgetAllPagos> {
  String formattedDate = "";

  @override
  void initState() {
    // TODO: implement initState
     formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(widget.iconmodelPago.fechaPago);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CircleAvatar(
                child: Text(
                    widget.iconmodelPago.nameCamionero[0]
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Fecha de pago: " + formattedDate ,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    ),
                  ),
                  Text(
                   "Folio: ${widget.iconmodelPago.idPago}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                    ),
                  ),
                  Text(
                      "Total \$355 MXN"
                  ),
                  Text(
                      "${widget.iconmodelPago.status}"
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}