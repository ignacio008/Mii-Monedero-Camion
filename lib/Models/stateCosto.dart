class StateCosto{
  String state;
  String locality;
  int costo;
  int costoPorPasaje;


  StateCosto({this.state,this.locality,this.costo,this.costoPorPasaje});

  List  <StateCosto> getStateCosto(dynamic miInfo){
      List<StateCosto>iconmodelLits=[];

    
        for(var datos in miInfo){
      final state_ = datos.data()['state']?? null;
      final locality_ = datos.data()['locality']?? null;
      final costo_ = datos.data()['costo']?? null;
      final costoPorPasaje_ = datos.data()['costoPorPasaje']?? null;


      StateCosto ventasmodel = StateCosto(
        state: state_,
        locality: locality_,
        costo: costo_,
        costoPorPasaje:costoPorPasaje_,
      );

       iconmodelLits.add(ventasmodel);
}
      return iconmodelLits;
     }
}