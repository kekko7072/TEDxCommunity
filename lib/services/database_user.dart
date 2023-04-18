import 'imports.dart';

class DatabaseUser {
  final String licenseId;
  final String? uid;
  final String? email;

  DatabaseUser({required this.licenseId, this.uid, this.email});

  ///USER COLLECTION
  late CollectionReference<Map<String, dynamic>> userCollection =
      DatabaseLicense(licenseId).licenseDoc.collection('users');

  Future createAdmin(
    String name,
    String surname,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'active': true,
      'role': Role.admin.toString(),
      'name': name,
      'surname': surname,
      'email': email,
    });
  }

  Future createUserData(
    String name,
    String surname,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'active': false,
      'role': Role.volunteer.toString(),
      'name': name,
      'surname': surname,
      'email': email,
    });
  }

  Future updateUserDataPersonal({
    required String field,
    required String value,
  }) async {
    return await userCollection.doc(uid).update({
      field: value,
    });
  }

  Future updateUserDataRole({required Role role}) async {
    return await userCollection.doc(uid).update({
      'role': role.toString(),
    });
  }

  Future updateUserDataActive({required bool value}) async {
    return await userCollection.doc(uid).update({
      'active': value,
    });
  }

  Future get delete async {
    return await userCollection.doc(uid).delete();
  }

  ///USER DATA FROM SNAPSHOT
  UserData userDataFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Role role = Role.volunteer;
    bool active = snapshot.data()?['active'] ?? false;

    switch (snapshot.data()?['role']) {
      case 'Role.volunteer':
        {
          role = Role.volunteer;
        }
        break;

      case 'Role.master':
        {
          role = Role.master;
        }
        break;
      case 'Role.coach':
        {
          role = Role.coach;
        }
        break;

      case 'Role.admin':
        {
          role = Role.admin;
        }
        break;
    }
    return UserData(
      uid: snapshot.id,
      active: active,
      role: role,
      name: snapshot.data()?['name'] ?? '',
      surname: snapshot.data()?['surname'] ?? '',
      email: snapshot.data()?['email'] ?? '',
    );
  }

  ///GET USER STREAM
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

  ///ALL USER
  Stream<List<UserData>> get streamAllUsers {
    return userCollection
        .where('email', isNotEqualTo: email)
        .snapshots()
        .map(userListFromSnapshot);
  }

  ///COACH

  ///Stream coach
  Stream<List<UserData>> get streamAllCoach {
    return userCollection
        .where('role', isEqualTo: 'Role.coach')
        .snapshots()
        .map(userListFromSnapshot);
  }

  ///Coach list from snapshot
  List<UserData> userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map(userDataFromSnapshot).toList();
  }
}
