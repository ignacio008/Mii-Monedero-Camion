class CenserModel{

  String id;
  String name;
  String email;
  DateTime createdOn;
  String description;
  String services;
  String category;
  String addres;
  String openHours;
  String distanceTo;
  double latitude;
  double longitude;
  String state;
  String locality;
  String nameOwner;
  String numberOwner;
  bool suspended;
  String photos;

  String numUnidad;
  String placa;
  String photoPLaca;
  String photoLicencia;
  String nameRuta;
  String paraderoRuta;
  String imagenCamion;
  int activacionesRestantes;
  String idCamion;


  CenserModel({this.id, this.name, this.nameOwner, this.suspended, this.numberOwner, this.email, this.createdOn, this.description, this.state, this.locality, this.services, this.category, this.addres, this.openHours, this.distanceTo, this.photos, this.latitude, this.longitude, this.numUnidad, this.placa, this.photoPLaca,this.photoLicencia,this.nameRuta,this.paraderoRuta, this.imagenCamion,this.activacionesRestantes, this.idCamion});





  CenserModel getUsuario(dynamic datos){

      final id_ = datos.data()['id'];
      final name_ = datos.data()['name'] ?? '';
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final description_ = datos.data()['description'] ?? '';
      final category_ = datos.data()['category'] ?? '';
      final addres_ = datos.data()['addres'] ?? '';
      final openHours_ = datos.data()['openHours'] ?? '';
      final latitude_ = datos.data()['latitude'];
      final longitude_ = datos.data()['longitude'];
      final state_ = datos.data()['state'] ?? '';
      final locality_ = datos.data()['locality'] ?? '';
      final nameOwner_ = datos.data()['nameOwner'] ?? '';
      final numberOwner_ = datos.data()['numberOwner'] ?? '';
      final suspended_ = datos.data()['suspended'];
      final photos_ = datos.data()['photos'];
      final services_ = datos.data()['services'];
      final distanceTo_ = datos.data()['distanceTo'] ?? '';
      final numUnidad_ =datos.data()['numUnidad']??'';
      final placa_ = datos.data()['placa']??'';
      final photoPLaca_ = datos.data()['photoPLaca']??'';
      final photoLicencia_ = datos.data()['photoLicencia']??'';
      final nameRuta_ = datos.data()['nameRuta']??'';
      final paraderoRuta_ = datos.data()['paraderoRuta']??'';
      final imagenCamion_=datos.data()['camion']??'';
      
      final activacionesRestantes_=datos.data()['activacionesRestantes']??'';

      final idCamion_=datos.data()['idCamion']??'';

       CenserModel usuariosModel = CenserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_.toDate(),
        locality: locality_,
        state: state_,
        suspended: suspended_,
        description: description_,
        category: category_,
        addres: addres_,
        openHours: openHours_,
        latitude: latitude_,
        longitude: longitude_,
        nameOwner: nameOwner_,
        numberOwner: numberOwner_,
        photos: photos_  ,
        services: services_  ,
        distanceTo: distanceTo_,
        numUnidad:numUnidad_,
        placa:placa_,
        photoPLaca:photoPLaca_,
        photoLicencia:photoLicencia_,
        nameRuta:nameRuta_,
        paraderoRuta:paraderoRuta_,
        imagenCamion:imagenCamion_,
        
        activacionesRestantes:activacionesRestantes_,
        idCamion:idCamion_,
      );

    return usuariosModel;
  }


    Map<String, dynamic> toJsonBodyCamionActivacion(activacionesRestantes) =>
          {
            'activacionesRestantes': activacionesRestantes,
            
          };
          String photoLicencia2;
           Map<String, dynamic> toJsonBodyCamio(id,name,email,createdOn,description,category,addres,openHours,latitude,longitude,state,locality,nameOwner,numberOwner,suspended,photos,services,photoLicencia,distanceTo,numUnidad,placa,photoPLaca,photoLicencia2,nameRuta,paraderoRuta,activacionesRestantes,imagenCamion,) =>
          {
            'id' : id,
           'name' : name,
           'email' : email,
           'createdOn' : createdOn,
           'description' : description,
           'category' : category,
           'addres' : addres,
           'openHours' : openHours,
           'latitude' : latitude,
           'longitude' : longitude,
           'state' : state,
           'locality' : locality,
           'nameOwner' : nameOwner,
           'numberOwner' : numberOwner,
           'suspended' : suspended,
           'photos' : photos,
           'services' : services,
           'licencia':photoLicencia,
           'distanceTo' : distanceTo,
           'numUnidad':numUnidad,
           'placa':placa,
           'photoPLaca':photoPLaca,
           'photoLicencia':photoLicencia,
           'nameRuta':nameRuta,
           'paraderoRuta':paraderoRuta,
           'activacionesRestantes':activacionesRestantes,
           'camion':imagenCamion,
            
          };
}