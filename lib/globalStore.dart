import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
var userDatabaseReference;
var articleDatabaseReference;
FirebaseUser currentUser;

Future<Null> ensureLoggedIn() async {
  currentUser = await auth.currentUser(); 
  
  if (currentUser  == null){
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential( 
        accessToken: googleSignInAuthentication.accessToken,
        idToken:googleSignInAuthentication.idToken
    );

    currentUser = await auth.signInWithCredential(credential);
  }   

  print("Signed In" + currentUser.displayName);
  userDatabaseReference= databaseReference.child(currentUser.uid);
  articleDatabaseReference = databaseReference.child(currentUser.uid).child('articles');     
}

var logIn = ensureLoggedIn();