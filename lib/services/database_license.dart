import 'imports.dart';

class DatabaseLicense {
  final String id;
  DatabaseLicense(this.id);

  ///COLLECTION APP_SETTINGS
  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('licenses');

  late DocumentReference<Map<String, dynamic>> licenseDoc =
      FirebaseFirestore.instance.collection('licenses').doc(id);

  Future create({required String adminUid, required String licenseName}) async {
    return await collectionReference.doc(id).set({
      'active': true,
      'adminUid': adminUid,
      'licenseName': licenseName,
      'registration': true,
      'eventDate': DateTime.now(),
      'bags': true,
      'urlReleaseForm': '',
    });
  }

  Future editRegistration({required bool registration}) async {
    return await collectionReference.doc(id).update({
      'registration': registration,
    });
  }

  Future editEventDate({required DateTime date}) async {
    return await collectionReference.doc(id).update({
      'eventDate': Timestamp.fromDate(date),
    });
  }

  Future editBags({required bool bags}) async {
    return await collectionReference.doc(id).update({
      'bags': bags,
    });
  }

  /*
    This method is used to check if an id already exist.
   */
  Future<bool> get checkExistence async {
    DocumentSnapshot value = await collectionReference.doc(id).get();
    return value.exists;
  }

  ///APP_SETTINGS DATA FROM SNAPSHOT
  License appSettingsFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return License(
      id: snapshot.id,
      active: snapshot.data()?['registration'] ?? false,
      adminUid: snapshot.data()?['adminUid'] ?? '',
      licenseName: snapshot.data()?['licenseName'] ?? '',
      registration: snapshot.data()!['registration'] ?? false,
      eventDate: snapshot.data()?['eventDate'] != null
          ? snapshot.data()!['eventDate'].toDate()
          : DateTime.now(),
      bags: snapshot.data()?['bags'] ?? false,
      urlReleaseForm: snapshot.data()!['urlReleaseForm'] ?? '',
    );
  }

  ///LOAD FROM SETTINGS
  static Future<String> get loadLicenseId async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kLicenseIdKey) ?? '';
  }

  ///GET APP_SETTINGS STREAM
  Stream<License> get stream {
    return collectionReference.doc(id).snapshots().map(appSettingsFromSnapshot);
  }
}
