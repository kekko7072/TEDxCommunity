class CurrentUser {
  final String? uid;

  CurrentUser({
    this.uid,
  });
}

enum Role {
  volunteer,
  master,
  coach,
  admin,
}

class UserData {
  UserData({
    required this.uid,
    required this.role,
    required this.name,
    required this.surname,
    required this.email,
  });

  final String uid;
  final Role role;
  final String name;
  final String surname;
  final String email;
}
