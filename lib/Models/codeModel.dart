class CodeModel {
  String id;
  String dateTime;
  String locality;
  String state;

  CodeModel({this.id, this.dateTime,this.locality,this.state});

  Map<String, dynamic> toMap() => {
        'id': id,
        'dateTime': dateTime,
      };

  CodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateTime = json['dateTime'],
        locality=json['locality'],
        state=json['state']
        ;
}
