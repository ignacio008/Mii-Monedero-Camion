class StateModel{

  String abrev;
  int activo;
  String clave;
  int id;
  String nombre;

  StateModel({this.activo, this.abrev, this.clave, this.id, this.nombre});

  StateModel.fromMap(Map<dynamic, dynamic> map) : // notice Map<dynamic, dynamic> here
        id = map['id'],
        nombre = map['nombre'],
        abrev = map['abrev'],
        clave = map['clave'],
        activo = map['activo'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'abrev': abrev,
    'activo': activo,
    'clave': clave
  };

  StateModel.deserialize(Map json) :
        id = json["id"].toInt(),
        nombre = json["nombre"].toString(),
        abrev = json["abrev"].toString(),
        clave = json["clave"].toString(),
        activo = json["activo"].toInt();

  factory StateModel.fromJson(Map<String, dynamic> parsedJson){
    return StateModel(
      id:parsedJson['id'].toInt(),
      nombre:parsedJson['nombre'].toString(),
      abrev:parsedJson['abrev'].toString(),
      clave:parsedJson['clave'].toString(),
      activo:parsedJson['activo'].toInt(),
    );
  }
}