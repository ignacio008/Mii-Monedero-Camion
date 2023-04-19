


import 'package:mega_monedero_store/Firebase/querys.dart';
import 'package:mega_monedero_store/Models/censerModel.dart';
import 'package:mega_monedero_store/Models/lastScan.dart';
import 'package:mega_monedero_store/Models/pagoModel.dart';
import 'package:mega_monedero_store/Models/scaneosTotal.dart';
import 'package:mega_monedero_store/Models/stateCosto.dart';
import 'package:mega_monedero_store/Models/ventasTotal.dart';

class FetchData{

    
   

   Future<List>getVentas(id)async{
     List<ActivacionesTotal>iconlistVentas=[];
     final messages= await QuerysService().getVentasTotalesQuery(id);
     dynamic  miinfo=messages.docs;
     iconlistVentas=ActivacionesTotal().getActivacionesTotal(miinfo);
     return iconlistVentas;
    
   }
    Future<List>getStateCostp(state)async{
     List<StateCosto>iconlistVentas=[];
     final messages= await QuerysService().getStateCosto(state);
     dynamic  miinfo=messages.docs;
     iconlistVentas=StateCosto().getStateCosto(miinfo);
     return iconlistVentas;
    
   }
   Future<List>getScaneos(idCamion, idUsuario)async{
     List<ScaneosModel>iconlistScaneo=[];
     final messages= await QuerysService().getScaneosCaUsu(idCamion,idUsuario);
     dynamic  miinfo=messages.docs;
     iconlistScaneo=ScaneosModel().getScaner(miinfo);
     return iconlistScaneo;
    
   }
    Future <CenserModel> getCamionero(id)async{  
      final messages= await QuerysService().getAdimDocument(id);
      dynamic  miinfo=messages;
      print(miinfo.data().toString());
      CenserModel adminmodel = CenserModel().getUsuario(miinfo);
      return adminmodel;
     }

   Future<List>getPagosCamionero(id)async{
     List<PagoModel>iconlistPagos=[];
     final messages= await QuerysService().getMyPagos(id);
     dynamic  miinfo=messages.docs;
     iconlistPagos=PagoModel().getPago(miinfo);
     return iconlistPagos;
    
   }
   Future<List>getPagosCamioneroActivaciones(id)async{
     List<PagoModel>iconlistPagos=[];
     final messages= await QuerysService().getTopPagos(id);
     dynamic  miinfo=messages.docs;
     iconlistPagos=PagoModel().getPago(miinfo);
     return iconlistPagos;
    
   }
  // }
  // Future<List>getTopTienda()async{
  //   List<TiendaModel>iconlistTopChanel=[];
  //   final messages= await QuerysService().getTopTienda();
  //   dynamic  miinfo=messages.docs;
  //   iconlistTopChanel=TiendaModel().getTienda(miinfo);
  //   return iconlistTopChanel;
    
  // }
  
    
  
}