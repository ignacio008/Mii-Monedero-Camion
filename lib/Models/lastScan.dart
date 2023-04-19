class LastScan{
  String idScaneos;
  String idCamion;
  String idUsuario;
  String city;
  String state;
  DateTime createOn;
  String photoUser;
  String emailUsuario;
  String idCamionBus;
  DateTime isActiveDate;

  LastScan({this.idScaneos,this.idCamion,this.idUsuario,this.city,this.state,this.createOn,this.photoUser,this.emailUsuario,this.idCamionBus,this.isActiveDate});


    List  <LastScan> getScaner(dynamic miInfo){
      List<LastScan>iconmodelLits=[];

    
        for(var datos in miInfo){
      final idScaneos_ = datos.data()['idScaneos']?? null;
      final idCamion_ = datos.data()['idCamion']?? null;
      final idUsuario_ = datos.data()['idUsuario']?? null;
      final city_ =datos.data()['city']?? null;
      final state_ =datos.data()['state']?? null;
      final createOn_ =datos.data()['createOn']?? null;
      final photoUser_ =datos.data()['photoUser']?? null;
      final emailUsuario_ =datos.data()['emailUsuario']?? null;
      final idCamionBus_ = datos.data()['idCamionBus']?? null;
      final isActiveDate_ =datos.data()['isActiveDate']?? null;


      LastScan scanerModel = LastScan(
        idScaneos: idScaneos_,
        idCamion: idCamion_,
        idUsuario: idUsuario_,
        city:city_,
        state:state_,
        createOn: createOn_== null ? null :createOn_.toDate(),
        photoUser:photoUser_,
        emailUsuario:emailUsuario_,
        idCamionBus:idCamionBus_,
        isActiveDate: isActiveDate_== null ? null :isActiveDate_.toDate(),
      );

       iconmodelLits.add(scanerModel);
}
      return iconmodelLits;
     }

       Map<String, dynamic> toJsonBodyScaner(idScaneos,idCamion,idUsuario,city,state,createOn,photoUser,emailUsuario,idCamionBus,isActiveDate) =>
          {
            'idScaneos': idScaneos,
            'idCamion': idCamion,
            'idUsuario':idUsuario,
            'city':city,
            'state':state,
            'createOn':createOn,
            'photoUser':photoUser,
            'emailUsuario':emailUsuario,
            'idCamionBus':idCamionBus,
            'isActiveDate':isActiveDate,
          };
}