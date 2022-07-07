class CodeModel{

  String id;
  String dateTime;

  CodeModel({this.id, this.dateTime});

  Map<String, dynamic> toMap() => {
    'id': id,
    'dateTime': dateTime,
  };

  CodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateTime = json['dateTime'];
}