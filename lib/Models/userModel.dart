class UserModel{

  String id;
  String name;
  String email;
  String state;
  String locality;
  DateTime createdOn;
  String urlProfile;
  DateTime activeUntil;
  DateTime activeProductosUntil;
  int renovations;
  bool suspended;

  UserModel({this.id, this.name, this.activeProductosUntil, this.state, this.locality, this.suspended, this.email, this.createdOn, this.urlProfile, this.activeUntil, this.renovations});

   
}