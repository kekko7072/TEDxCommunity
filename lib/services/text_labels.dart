import '../models/user.dart';

class TextLabels {
  ///Speaker Description
  static String kAddSpeaker0 = 'Profession: ';
  static String kAddSpeaker1 = 'Topic: ';
  static String kAddSpeaker2 = 'Public-Speaking: ';
  static String kAddSpeaker3 = 'Precedent-TEDx: ';
  static String kAddSpeaker4 = 'Biography: ';

  static String formatText(String str) {
    str = str.replaceAll(' ', '');
    str = str.replaceAll('.', '');
    return str;
  }

  static String formatEmail(String str) {
    str = str.replaceAll(' ', '');
    return str;
  }

  static String userRoleToString(Role role) {
    switch (role) {
      case Role.volunteer:
        return 'Volunteer';
      case Role.master:
        return 'Master';
      case Role.coach:
        return 'Coach';
      case Role.admin:
        return 'Admin';
    }
  }
}
