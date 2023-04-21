import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

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

  static String userRoleToString(Role role, BuildContext context) {
    switch (role) {
      case Role.volunteer:
        return AppLocalizations.of(context)!.volunteer;
      case Role.master:
        return AppLocalizations.of(context)!.master;
      case Role.coach:
        return AppLocalizations.of(context)!.coach;
      case Role.admin:
        return AppLocalizations.of(context)!.admin;
    }
  }
}
