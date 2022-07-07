class ScaneosModel{
  String idScaneos;
  String idCamion;
  String idUsuario;
  String city;
  String state;
  DateTime createOn;
  String emailCamionScaneo;
  String emailUsuario;

  ScaneosModel({this.idScaneos,this.idCamion,this.idUsuario,this.city,this.state,this.createOn,this.emailCamionScaneo,this.emailUsuario});


    List  <ScaneosModel> getScaner(dynamic miInfo){
      List<ScaneosModel>iconmodelLits=[];

    
        for(var datos in miInfo){
      final idScaneos_ = datos.data()['idScaneos']?? null;
      final idCamion_ = datos.data()['idCamion']?? null;
      final idUsuario_ = datos.data()['idUsuario']?? null;
      final city_ =datos.data()['city']?? null;
      final state_ =datos.data()['state']?? null;
      final createOn_ =datos.data()['createOn']?? null;
      final emailCamionScaneo_ =datos.data()['emailCamionScaneo']?? null;
      final emailUsuario_ =datos.data()['emailUsuario']?? null;


      ScaneosModel scanerModel = ScaneosModel(
        idScaneos: idScaneos_,
        idCamion: idCamion_,
        idUsuario: idUsuario_,
        city:city_,
        state:state_,
        createOn: createOn_== null ? null :createOn_.toDate(),
        emailCamionScaneo:emailCamionScaneo_,
        emailUsuario:emailUsuario_,
      );

       iconmodelLits.add(scanerModel);
}
      return iconmodelLits;
     }

       Map<String, dynamic> toJsonBodyScaner(idScaneos,idCamion,idUsuario,city,state,createOn,emailCamionScaneo,emailUsuario) =>
          {
            'idScaneos': idScaneos,
            'idCamion': idCamion,
            'idUsuario':idUsuario,
            'city':city,
            'state':state,
            'createOn':createOn,
            'emailCamionScaneo':emailCamionScaneo,
            'emailUsuario':emailUsuario,
          };
}