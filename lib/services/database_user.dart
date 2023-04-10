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
      'role': Role.admin.toString(),
      'name': name,
      'surname': surname,
      'email': email,
    });
  }

  Future updateUserData(
    String name,
    String surname,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'role': Role.volunteer.toString(),
      'name': name,
      'surname': surname,
      'email': email,
    });
  }

  Future updateUserSinglePersonalData({
    required String field,
    required String value,
  }) async {
    return await userCollection.doc(uid).update({
      field: value,
    });
  }

  ///USER DATA FROM SNAPSHOT
  UserData userDataFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Role role = Role.volunteer;

    switch (snapshot.data()!['role']) {
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
      uid: uid!,
      role: role,
      name: snapshot.data()!['name'] ?? '',
      surname: snapshot.data()!['surname'] ?? '',
      email: snapshot.data()!['email'] ?? '',
    );
  }

  ///GET USER STREAM
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

  ///ALL USER
  Stream<QuerySnapshot<Map<String, dynamic>>> get allUserQuery {
    return userCollection.where('email', isNotEqualTo: email).snapshots();
  }

  ///COACH

  ///Stream coach
  Stream<QuerySnapshot<Map<String, dynamic>>> get coachQuery {
    return userCollection.where('role', isEqualTo: 'Role.coach').snapshots();
  }

  ///Coach list from snapshot
  List<UserData> userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((snapshot) {
      Role role = Role.volunteer;

      switch (snapshot.data()['role']) {
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
        default:
          {
            role = Role.volunteer;
          }
      }
      return UserData(
        uid: snapshot.id,
        role: role,
        name: snapshot.data()['name'] ?? '',
        surname: snapshot.data()['surname'] ?? '',
        email: snapshot.data()['email'] ?? '',
      );
    }).toList();
  }
}
