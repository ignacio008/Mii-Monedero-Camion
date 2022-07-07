import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero_store/Models/salesModel.dart';

class SalesItem extends StatefulWidget {

  SalesModel salesModel;
  SalesItem({this.salesModel});

  @override
  _SalesItemState createState() => _SalesItemState();
}

class _SalesItemState extends State<SalesItem> {

  String formattedDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(widget.salesModel.dateTime);

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
                    widget.salesModel.nameUser[0]
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
                    widget.salesModel.nameUser,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),
                  ),
                  Text(
                    "Activado el: " + formattedDate,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                    ),
                  ),
                  Text(
                      widget.salesModel.locality + ", " + widget.salesModel.state
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
