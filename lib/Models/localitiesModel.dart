class LocalityModel{

  int id;
  double latitud;
  double longitud;
  String localidades_nombre;
  String nombre_estado;
  String nombre_municipio;

  LocalityModel({this.id, this.latitud, this.longitud, this.localidades_nombre, this.nombre_estado, this.nombre_municipio});

  LocalityModel.fromMap(Map<dynamic, dynamic> map) : // notice Map<dynamic, dynamic> here
        id = map['id'],
        latitud = map['latitud'],
        longitud = map['longitud'],
        localidades_nombre = map['localidades_nombre'],
        nombre_estado = map['nombre_estado'],
        nombre_municipio = map['nombre_municipio'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'latitud': latitud,
    'longitud': longitud,
    'localidades_nombre': localidades_nombre,
    'nombre_estado': nombre_estado,
    'nombre_municipio': nombre_municipio,
  };

  LocalityModel.deserialize(Map json) :
        id = json["id"].toInt(),
        latitud = json["latitud"].toDouble(),
        longitud = json["longitud"].toDouble(),
        localidades_nombre = json["localidades_nombre"].toString(),
        nombre_estado = json["nombre_estado"].toString(),
        nombre_municipio = json["nombre_municipio"].toString();

      factory LocalityModel.fromJson(Map<String, dynamic> parsedJson){
    return LocalityModel(
      id:parsedJson['id'].toInt(),
      latitud:parsedJson['latitud'].toDouble(),
      longitud:parsedJson['longitud'].toDouble(),
      localidades_nombre:parsedJson['localidades_nombre'].toString(),
      nombre_estado:parsedJson['nombre_estado'].toString(),
      nombre_municipio:parsedJson['nombre_municipio'].toString(),

    );
  }
}