class ActivacionesTotal{
  String idActicacion;
  String idCamion;
  int numeroActivacion;
  DateTime fechaNuevaVenta;
  String nameCamionero;
  String email;
  int ciclosDoce;


  ActivacionesTotal({this.idActicacion, this.idCamion,this.numeroActivacion,this.fechaNuevaVenta,this.nameCamionero,this.email,this.ciclosDoce});

     List  <ActivacionesTotal> getActivacionesTotal(dynamic miInfo){
      List<ActivacionesTotal>iconmodelLits=[];

    
        for(var datos in miInfo){
      final idActicacion_ = datos.data()['idActicacion']?? null;
      final idCamion_ = datos.data()['idCamion']?? null;
      final numeroActivacion_ = datos.data()['numeroActivacion']?? null;
      final fechaNuevaVenta_ =datos.data()['fechaNuevaVenta']?? null;
      final nameCamionero_ =datos.data()['nameCamionero']?? null;
      final email_ =datos.data()['email']?? null;
      final ciclosDoce_ =datos.data()['ciclosDoce']?? null;


      ActivacionesTotal ventasmodel = ActivacionesTotal(
        idActicacion: idActicacion_,
        idCamion: idCamion_,
        numeroActivacion: numeroActivacion_,
        fechaNuevaVenta: fechaNuevaVenta_== null ? null :fechaNuevaVenta_.toDate(),
        nameCamionero:nameCamionero_,
        email:email_,
        ciclosDoce:ciclosDoce_,
      );

       iconmodelLits.add(ventasmodel);
}
      return iconmodelLits;
     }

      Map<String, dynamic> toJsonBody(idActicacion,idCamion,ciclosDoce,numeroActivacion,fechaNuevaVenta,nameCamionero,email) =>
          {
            'idActicacion': idActicacion,
            'idCamion': idCamion,
            'ciclosDoce':ciclosDoce,
            'numeroActivacion':numeroActivacion,
            'fechaNuevaVenta':fechaNuevaVenta,
            'nameCamionero':nameCamionero,
            'email':email,


          };
          Map<String, dynamic> toJsonBodyActualizar(ciclosDoce,numeroActivacion,fechaNuevaVenta) =>
          {
            'ciclosDoce':ciclosDoce,
            'numeroActivacion':numeroActivacion,
            'fechaNuevaVenta':fechaNuevaVenta,
          };
           Map<String, dynamic> toJsonBodyCamionActivaciones(idActicacion,idCamion,fechaNuevaVenta,email, nameCamionero) =>
          {
            'idActicacion':idActicacion,
            'idCamion':idCamion,
            'fechaNuevaVenta':fechaNuevaVenta,
            'email':email,
            'nameCamionero':nameCamionero,
          };
           Map<String, dynamic> toJsonBodyActualizarPago(ciclosDoce,numeroActivacion,fechaNuevaVenta,idPago) =>
          {
            'ciclosDoce':ciclosDoce,
            'numeroActivacion':numeroActivacion,
            'fechaNuevaVenta':fechaNuevaVenta,
            'idPago':idPago,
          };
          
}