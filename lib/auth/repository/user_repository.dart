import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/main/globals.dart';
import '../model/user_model.dart';
import 'abstract_user_repository.dart';

class UserRepository extends AbstractUserRepository { 
  @override
  Future<bool> auth(String? login, String? password) async{
    try{
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(email: login!, password: password!);
      final user = await userReference.doc(response.user!.uid).get();
      userModel = userModel.copyWith(phoneNumber: user.get('phone_number'), username: user.get('username'), uid: response.user!.uid);
      talker.log(userModel.phoneNumber);
      return true;
    } on FirebaseAuthException{
      talker.log('error ');
      return false;
    } catch(e){
      talker.error(e);
      return false;
    }
  }
  
  @override
  Future<bool> regWithGoogle() async{
    try{
      // begin interactive process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      
      // make credential user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
      );
      
      //make final Sign in
      final response = await FirebaseAuth.instance.signInWithCredential(credential);
      talker.log(response.user!.uid);
      return true;
    }catch (e){
      talker.log(e);
      return false;
    }
  }
    @override
  Future<bool> authWithGoogle() async{
    try{
      // begin interactive process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      
      // make credential user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
      );
      
      //make final Sign in
      final response = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = await userReference.doc(response.user!.uid).get();
      userModel = userModel.copyWith(email: response.user!.email ,phoneNumber: user.get('phone_number') , username: user.get('username') );
      uid = response.user!.uid; 
      return true;
    }catch (e){
      talker.log(e);
      return false;
    }
  }
  
  @override
  Future<bool> registration(UserModel user) async{
    try{
      final response = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
      await userReference.doc(response.user!.uid).set(userModel.toJson());
      return true;
    } catch(e){
      talker.error(e);
      return false;
    }
  }
  
  @override
  Future<bool> registrationWithGoogle(UserModel user) async{
    try{ 
    await userReference.doc(uid).set(user.toJson());
    return true;
    } catch(e){
      talker.error(e);
      return false;
    }
  }
  
  @override
  Future<bool> resetPassword(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch(e){
      talker.error(e);
      return false;
    }
  }
  
  @override
  Future<bool> sharedAuth(String uid) async{
    try{
      final response = await userReference.doc(uid).get();
      userModel = userModel.copyWith(email: response['email'], password: response['password'], username: response['username'], phoneNumber: response['phone_number']);
      return true;
    } catch(e){
      talker.error(e);
      return false;
    }
  }
  
}