import 'package:tedxcommunity/services/imports.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String error = '';

  //Create user object based on Firebase user
  CurrentUser? _userFromFirebaseUser(User? user) {
    return CurrentUser(uid: user?.uid);
  }

  // Auth change user stream
  Stream<CurrentUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Sign in email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  //Register email & password
  Future registerWithEmailAndPassword(
      String licenseId,
      String name,
      String surname,
      String email,
      String password,
      BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      await DatabaseUser(licenseId: licenseId, uid: user.uid).updateUserData(
        name,
        surname,
        email,
      );

      return _userFromFirebaseUser(user);
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  //Register email & password
  Future<String> registerAdminWithEmailAndPassword(
      String licenseId,
      String name,
      String surname,
      String email,
      String password,
      BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      await DatabaseUser(licenseId: licenseId, uid: user.uid).createAdmin(
        name,
        surname,
        email,
      );

      _auth.signOut();

      return user.uid;
    } catch (e) {
      error = e.toString();
      return '';
    }
  }

  //Register email & password

  Future registerSpeakerWithEmailAndPassword({
    required String licenseId,
    required String uidCreator,
    required String accessID,
    required String accessPassword,
    required Progress progress,
    required String name,
    required String email,
    required String link,
    required String description,
    required BuildContext context,
  }) async {
    //name della nuova app deve cambiare senno non va.
    FirebaseApp app = await Firebase.initializeApp(
        name: accessID, options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: '$accessID@$kTEDxCommunityCustomSpeakerDomain',
              password: accessPassword);
      await DatabaseSpeaker(licenseId: licenseId, id: userCredential.user!.uid)
          .createSpeakerCredential(
        newId: userCredential.user!.uid,
        uidCreator: uidCreator,
        progress: progress,

        ///Account information
        accessID: accessID,
        accessPassword: accessPassword,

        ///Step
        managementStep: 1,
        managementStepDate: DateTime.now().toIso8601String(),
        coachingStep: 1,
        coachingStepDate: '',

        ///Personal Info
        name: name,
        email: email,
        link: link,
      );
    } on FirebaseAuthException catch (e) {
      error = e.toString();
    }
    await app.delete();
  }

  //Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  //Reset Password
  Future sendPasswordResetEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      error = e.toString();
    }
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhJjKkLMmNnPpQqRrTtXxYyZz123456789'; //REMOVED I i l O o 0 S s V v U u W w
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
