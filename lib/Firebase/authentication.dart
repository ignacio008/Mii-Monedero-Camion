import 'package:firebase_auth/firebase_auth.dart';
import 'package:mega_monedero_store/Models/auth_request.dart';

class Authentication{

  final _auth = FirebaseAuth.instance;

  Future<AuthenticationRequest> createUser({String email = "", String password = ""}) async {

    AuthenticationRequest authenticationRequest = AuthenticationRequest();

    try{
      var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(user != null){
        authenticationRequest.succes = true;
      }
    }
    catch(e){
      _mapErrorMessage(authenticationRequest, e.code);
    }
    return authenticationRequest;
  }

  @override
  Future<void> resetPassword({String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<AuthenticationRequest> logingUser({String email = "", String password = ""}) async {

    AuthenticationRequest authenticationRequest = AuthenticationRequest();

    try{
      var user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(user != null){
        authenticationRequest.succes = true;
      }
    }
    catch(e){
      _mapErrorMessage(authenticationRequest, e.code);
    }
    return authenticationRequest;
  }

  Future<User> getCurrentUser() async{

    try {
      var user = await _auth.currentUser;
      return user;
    }
    catch(e){
      print(e);
    }

    return null;
  }

  Future<void> singOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e);
    }
  }

  void _mapErrorMessage(AuthenticationRequest authenticationRequest, String code){
    switch(code){
      case 'ERROR_USER_NOT_FOUND':
        authenticationRequest.errorMessage = "Usuario no encontrado";
        break;

      case 'ERROR_WRONG_PASSWORD':
        authenticationRequest.errorMessage = "Contraseña inválida";
        break;

      case 'ERROR_NETWORK_REQUEST_FAILED':
        authenticationRequest.errorMessage = "Error de red";
        break;

      case 'ERROR_EMAIL_ALREADY_IN_USE':
        authenticationRequest.errorMessage = "El usuario ya está registrado";
        break;

      case 'ERROR_INVALID_EMAIL':
        authenticationRequest.errorMessage = "Verifique que su correo esté escrito correctamente";
        break;

      default:
        authenticationRequest.errorMessage = code;
        break;
    }
  }
}

