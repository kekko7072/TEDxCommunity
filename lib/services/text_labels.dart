class TextLabels {
  ///App
  static String kAppName = 'TEDxCommunity';

  ///Menu
  static String kMenuList = 'Lista';
  static String kMenuElaboration = 'Elaborazione';
  static String kMenuConfirmed = 'Confermati';
  static String kMenuBags = 'Bags';

  ///Speaker Description
  static String kAddSpeaker0 = 'Professione: ';
  static String kAddSpeaker1 = 'Topic: ';
  static String kAddSpeaker2 = 'Public-Speaking: ';
  static String kAddSpeaker3 = 'Precedenti-TEDx: ';
  static String kAddSpeaker4 = 'Biografia: ';

  String formatText(String str) {
    str = str.replaceAll(' ', '');
    str = str.replaceAll('.', '');
    return str;
  }

  String formatEmail(String str) {
    str = str.replaceAll(' ', '');
    return str;
  }
}
