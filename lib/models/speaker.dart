enum Progress {
  backlog,
  selected,
  contacted,
  rejected,
  confirmed,
  ready,
}

class Speaker {
  const Speaker({
    ///Info
    required this.id,
    required this.uidCreator,
    required this.thisEvent,
    required this.progress,

    ///Account information
    this.accessID,
    this.accessPassword,

    ///Step
    required this.managementStep,
    required this.managementStepDate,
    required this.coachingStep,
    required this.coachingStepDate,

    ///Personal Info
    required this.name,
    required this.email,
    required this.link,
    this.instagram,
    this.facebook,
    this.linkedin,
    required this.description,
    this.company,
    this.job,
    this.dressSize,
    this.urlReleaseForm,

    ///Hotel and Logistics
    this.checkInDate,
    this.departureDate,
    this.roomType,
    this.companions,

    ///Coaching
    this.coach,
    this.talkDownloadLink,
    required this.coachEventId,
  });

  final String id;
  final String uidCreator;
  final bool thisEvent;
  final Progress progress;

  ///Account information
  final String? accessID;
  final String? accessPassword;

  ///Step
  final int managementStep;
  final String managementStepDate;
  final int coachingStep;
  final String coachingStepDate;

  ///Personal Info
  final String name;
  final String email;
  final String link;
  final String? instagram;
  final String? facebook;
  final String? linkedin;
  final String description;
  final String? company;
  final String? job;
  final String? dressSize;
  final String? urlReleaseForm;

  ///Hotel and Logistics
  final String? checkInDate;
  final String? departureDate;
  final String? roomType;
  final int? companions;

  ///Coaching
  final String? coach;
  final String? talkDownloadLink;
  final String? coachEventId;
}
