import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'firebase_referencias.dart';

class QuerysService{

  final _fireStore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getAllCategories() async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_CATEGORIES).get();
  }

  Future<QuerySnapshot> getAllUsers() async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).get();
  }
    Future<QuerySnapshot>getStateCosto(String state)async{
    return await _fireStore.collection("PrecioEstados").where("state",isEqualTo:state).get();
  }

  Future<QuerySnapshot> getAllCensersByCategory({String category}) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_CENSERS).where('category', isEqualTo: category).where("active", isEqualTo: true).where("completed", isEqualTo: true).get();
  }
  Future<DocumentSnapshot> getAdimDocument(id) async{
   return await _fireStore.collection("Censers").doc(id).get();
   }

  Future<QuerySnapshot> getMiInfo({String miId}) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_CENSERS).where('id', isEqualTo: miId).get();
  }

  Future<QuerySnapshot> getMyLastSales({String miId}) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_EARNINGS).where('storeId', isEqualTo: miId).orderBy('dateTime', descending: true).limit(30).get();
  }
  

  Future<QuerySnapshot> getUserbyID({String miId}) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).where('id', isEqualTo: miId).get();
  }
  Future<QuerySnapshot> getTopPagos(String miId) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_EstadoPagoCamionero).where('idCamion', isEqualTo: miId).get();
  }

  void SaveUsuario({String idUsuario,BuildContext context, Function function, Function errorFunction, Map<String, dynamic> collectionValues}) async {
    bool error = false;

    await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).doc(idUsuario).set(collectionValues).catchError((onError){
      Toast.show("Ha ocurrido un error, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
    }).then((onValue){
      if(!error){
        Toast.show("¡Información subida exitosamente!", context, duration: Toast.LENGTH_LONG);
        function();
      }
      else{
        errorFunction();
      }
    });
  }

  void SaveSale({String idSale,BuildContext context, Function function, Function errorFunction, Map<String, dynamic> collectionValues}) async {
    bool error = false;

    await _fireStore.collection(FirebaseReferencias.REFERENCE_EARNINGS).doc(idSale).set(collectionValues).catchError((onError){
      Toast.show("Ha ocurrido un error guardando la venta, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
    }).then((onValue){
      if(!error){
        Toast.show("¡Información subida exitosamente!", context, duration: Toast.LENGTH_LONG);
        function();
      }
      else{
        errorFunction();
      }
    });
  }


  void updateUserDataServices({String idUser, BuildContext context, Function errorFunction, Function succesfulFunction, DateTime collectionValues}) async{
    bool error = false;
    await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).doc(idUser).update({"activeUntil": collectionValues}).catchError((onError){
      Toast.show("Ha ocurrido un error, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
      errorFunction();
    }).then((onValue){
      if(!error){
        Toast.show("¡Información actualizada exitosamente!", context, duration: Toast.LENGTH_LONG);
        succesfulFunction();
      }
    });
  }

  Future<String> uploadProfilePhoto({File file, String id}) async {

    final Reference storageReference = FirebaseStorage.instance.ref().child("Users").child(id + "-profile.png");
    final UploadTask uploadTask = storageReference.putFile(file);
    var dowurl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    String url = dowurl.toString();
    return url;
  }

  void updateFotosEstablecimientoData({String idEstablecimiento, BuildContext context, List<String> collectionValues}) async{
    bool error = false;
    await _fireStore.collection(FirebaseReferencias.REFERENCE_CENSERS).doc(idEstablecimiento).update({"photos": collectionValues}).catchError((onError){
      Toast.show("Ha ocurrido un error, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
    }).then((onValue){
      if(!error){
        Toast.show("¡Información actualizada exitosamente!", context, duration: Toast.LENGTH_LONG);
      }
    });
  }

  void SaveCenser({String idCenser,BuildContext context, Future function, Function errorFunction, Map<String, dynamic> collectionValues}) async {
    bool error = false;

     _fireStore.collection(FirebaseReferencias.REFERENCE_CENSERS).doc(idCenser).set(collectionValues).catchError((onError){
      Toast.show("Ha ocurrido un error, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
    }).then((onValue){
      if(!error){
        Toast.show("¡Información subida exitosamente!", context, duration: Toast.LENGTH_LONG);
        Future;
      }
      else{
        errorFunction();
      }
    });
  }
   void UpdateCenser({String idCenser,BuildContext context, Future function, Function errorFunction, Map<String, dynamic> collectionValues}) async {
    bool error = false;

     _fireStore.collection(FirebaseReferencias.REFERENCE_CENSERS).doc(idCenser).update(collectionValues).catchError((onError){
      Toast.show("Ha ocurrido un error, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
    }).then((onValue){
      if(!error){
        Toast.show("¡Información actualizada exitosamente!", context, duration: Toast.LENGTH_LONG);
        Future;
      }
      else{
        errorFunction();
      }
    });
  }

   Future<QuerySnapshot>getVentasTotalesQuery(String idCamion)async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_ActivacionesTotalCamionero).where("idCamion",isEqualTo:idCamion).get();
  }
   Future<QuerySnapshot>getScaneosCaUsu(String idCamion, String idUsuario)async{
    
     DateTime now=DateTime.now();
     DateTime nuevaHour= DateTime(now.year,now.month,now.day,now.hour,now.minute-58);
     print(nuevaHour);
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_Scaneos).where("idCamion",isEqualTo:idCamion).where("idUsuario",isEqualTo:idUsuario).where("createOn",isGreaterThan:nuevaHour).get();
  }

  Future<QuerySnapshot> getMyPagos(String miId) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_EstadoPagoCamionero).where('idCamion', isEqualTo: miId).orderBy('fechaPago', descending: true).get();
  }
  // Future<QuerySnapshot> getMyEstadoPagos(String miId) async{
  //   return await _fireStore.collection(FirebaseReferencias.REFERENCE_EstadoPagoCamionero).where('idCamion', isEqualTo: miId).orderBy('fechaPago', descending: true).get();
  // }




   Future<bool> SaveCenserVentas({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues, setOptions).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }

  Future<bool> UpdateCenserVentas({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).update(collectionValues,).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }
  Future<bool> UpdateCenserCamion({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).update(collectionValues,).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }
 
   Future<bool> UpdateCenserActivaciones({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues,).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }
   Future<bool> UpdateCamionCenserActivaciones({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).update(collectionValues,).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }

  Future<bool> SavePago({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues, setOptions).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }

  Future<bool> actualizarInfo({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    return await _fireStore.collection(reference).doc(id).update(collectionValues).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }

  Future<bool> SaveGeneralInfoScaneos({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues, setOptions).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }
  Future<bool> SaveGeneralInfoUsuarios({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues, setOptions).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }


}