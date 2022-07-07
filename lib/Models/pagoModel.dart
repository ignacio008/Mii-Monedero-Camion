import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

class PagoModel{

  String idPago;
  String idCamion;
  double numeroPago;
  DateTime fechaPago;
  String nameCamionero;
  String email;
  String numeroCamionero;
  String placa;
  String status;
  String message;
  PaymentResult result;
  bool activaciones;


  PagoModel({this.idPago, this.idCamion,this.numeroPago,this.fechaPago,this.nameCamionero,this.email,this.numeroCamionero,this.placa,this.status,this.message,this.result,this.activaciones});

     List  <PagoModel> getPago(dynamic miInfo){
      List<PagoModel>iconmodelLits=[];

    
        for(var datos in miInfo){
      final idPago_ = datos.data()['idPago']?? null;
      final idCamion_ = datos.data()['idCamion']?? null;
      final numeroPago_ = datos.data()['numeroPago']?? null;
      final fechaPago_ =datos.data()['fechaPago']?? null;
      final nameCamionero_ =datos.data()['nameCamionero']?? null;
      final email_ =datos.data()['email']?? null;
      final numeroCamionero_ =datos.data()['numeroCamionero']?? null;
      final placa_ =datos.data()['placa']?? null;
      final status_ =datos.data()['status']?? null;
      final message_ =datos.data()['message']?? null;
      final result_ =datos.data()['result']?? null;
      final activaciones_ =datos.data()['activaciones']?? null;


      PagoModel pagoModel = PagoModel(
        idPago: idPago_,
        idCamion: idCamion_,
        numeroPago: numeroPago_,
        fechaPago: fechaPago_== null ? null :fechaPago_.toDate(),
        nameCamionero:nameCamionero_,
        email:email_,
        numeroCamionero:numeroCamionero_,
        placa:placa_,
        status:status_,
        message:message_,
        result:result_,
        activaciones:activaciones_,
      );

       iconmodelLits.add(pagoModel);
}
      return iconmodelLits;
     }

      Map<String, dynamic> toJsonBody(idPago,idCamion,numeroPago,fechaPago,nameCamionero,email,numeroCamionero,placa) =>
          {
            'idPago': idPago,
            'idCamion': idCamion,
            'numeroPago':numeroPago,
            'fechaPago':fechaPago,
            'nameCamionero':nameCamionero,
            'email':email,
            'numeroCamionero':numeroCamionero,
            'placa':placa,


          };
          Map<String, dynamic> toJsonBodyActualizar(numeroPago,fechaPago) =>
          {
            'numeroPago':numeroPago,
            'fechaPago':fechaPago,
          };

           Map<String, dynamic> toJsonBodyStatus(status,message,) =>
          {
            'status': status,
            'message':message,


          };
           Map<String, dynamic> toJsonBodyEStadoPago(idPago,idCamion,numeroPago,fechaPago,nameCamionero,email,numeroCamionero,placa,status,message,preferenceId) =>
          {
            'idPago': idPago,
            'idCamion': idCamion,
            'numeroPago':numeroPago,
            'fechaPago':fechaPago,
            'nameCamionero':nameCamionero,
            'email':email,
            'numeroCamionero':numeroCamionero,
            'placa':placa,
            'status': status,
            'message':message,
            'preferenceId':preferenceId,

          };
           Map<String, dynamic> toJsonBodyEStadoPagoActivaciones(idPago,idCamion,numeroPago,fechaPago,nameCamionero,email,numeroCamionero,placa,status,message,preferenceId,activaciones) =>
          {
            'idPago': idPago,
            'idCamion': idCamion,
            'numeroPago':numeroPago,
            'fechaPago':fechaPago,
            'nameCamionero':nameCamionero,
            'email':email,
            'numeroCamionero':numeroCamionero,
            'placa':placa,
            'status': status,
            'message':message,
            'preferenceId':preferenceId,
            'activaciones':activaciones,
          };
          Map<String, dynamic> toJsonBodyEActivacionesActual(activaciones) =>
          {
            'activaciones':activaciones,
          };

}