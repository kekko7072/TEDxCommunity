import 'package:tedxcommunity/services/imports.dart';

class StepService {
  BuildContext context;
  StepService(this.context);
  String loadStepManagementText(int step) {
    switch (step) {
      case 0:
        return AppLocalizations.of(context)!.start;
      case 1:
        return AppLocalizations.of(context)!.formWithInformation;
      case 2:
        return AppLocalizations.of(context)!.hotelAndLogistics;
      case 3:
        return AppLocalizations.of(context)!.completed;
    }
    return AppLocalizations.of(context)!.noOptionAvailable;
  }

  String loadStepCoachingTitle(int step) {
    switch (step) {
      case 0:
        return AppLocalizations.of(context)!.start;
      case 1:
        return AppLocalizations.of(context)!.firstMeeting;

      case 2:
        return AppLocalizations.of(context)!.prepareSpeech;
      case 3:
        return AppLocalizations.of(context)!.secondMeeting;
      case 4:
        return AppLocalizations.of(context)!.review;
      case 5:
        return AppLocalizations.of(context)!.completed;
    }
    return AppLocalizations.of(context)!.noOptionAvailable;
  }

  String loadStepCoachingDescription(int step) {
    switch (step) {
      case 0:
        return AppLocalizations.of(context)!.start;
      case 1:
        return AppLocalizations.of(context)!.firstMeetingWithSpeakerCoach;
      case 2:
        return AppLocalizations.of(context)!.secondMeetingWithSpeakerCoach;
      case 3:
        return AppLocalizations.of(context)!.finalReviewMeetingWithSpeakerCoach;
    }
    return AppLocalizations.of(context)!.noOptionAvailable;
  }
}
