import 'package:tedxcommunity/services/imports.dart';

class DatabaseSpeaker {
  final String licenseId;
  final String? id;
  final Progress? progress;

  DatabaseSpeaker({required this.licenseId, this.id, this.progress});

  ///COLLECTION SPEAKERS
  late CollectionReference<Map<String, dynamic>> speakersCollection =
      DatabaseLicense(licenseId).licenseDoc.collection('speakers');

  Future addSpeaker({
    ///INFO
    required String name,
    required String uidCreator,
    required String email,
    required String link,
    required String description,
  }) async {
    return await speakersCollection.doc(id).set({
      ///INFO
      'id': id,
      'uidCreator': uidCreator,
      'thisEvent': true,
      'progress': Progress.backlog.toString(),
      'name': name,
      'email': email,
      'link': link,
      'description': description,
    });
  }

  Future createSpeakerCredential({
    required String newId,
    required String uidCreator,
    required Progress progress,

    ///Account information
    required String accessID,
    required String accessPassword,

    ///Step
    required int managementStep,
    required String managementStepDate,
    required int coachingStep,
    required String coachingStepDate,

    ///Personal Info
    required String name,
    required String email,
    required String link,
  }) async {
    return await speakersCollection.doc(newId).set({
      'id': newId,
      'uidCreator': uidCreator,
      'thisEvent': true,
      'progress': progress.toString(),

      ///Account information
      'accessID': accessID,
      'accessPassword': accessPassword,

      ///Step
      'managementStep': managementStep,
      'managementStepDate': managementStepDate,
      'coachingStep': coachingStep,
      'coachingStepDate': coachingStepDate,

      ///Personal info
      'name': name,
      'email': email,
      'link': link,
      'instagram': '',
      'facebook': '',
      'linkedin': '',
      'description': '',
      'company': '',
      'job': '',
      'dressSize': '',

      ///Hotel and Logistics
      'checkInDate': '',
      'departureDate': '',
      'roomType': '',
      'companions': 0,

      ///Coaching
      'coach': '',
      'talkDownloadLink': '',
      'coachEventId': '',
    });
  }

  Future deleteSpeaker() async {
    return await speakersCollection.doc(id.toString()).delete();
  }

  Future editSpeaker(
      {required String name,
      required String email,
      required String link,
      required String description}) async {
    return await speakersCollection.doc(id).update({
      'name': name,
      'email': email,
      'link': link,
      'description': description
    });
  }

  Future editSpeakerEmail({
    required String email,
  }) async {
    return await speakersCollection.doc(id).update({
      'email': email,
    });
  }

  Future editSpeakerLinkAndEventID(
      {required String link, required String eventId}) async {
    return await speakersCollection.doc(id).update({
      'link': link,
      'coachEventId': eventId,
    });
  }

  Future updateProgress({required Progress progress}) async {
    return await speakersCollection
        .doc(id)
        .update({'progress': progress.toString()});
  }

  ///Step
  Future updateManagementStep({required int step}) async {
    return await speakersCollection.doc(id!).update({
      'managementStep': step,
      'managementStepDate': DateTime.now().toIso8601String()
    });
  }

  Future updateCoachingStep({required int step}) async {
    return await speakersCollection
        .doc(id!)
        .update({'coachingStep': step, 'coachingStepDate': ''});
  }

  Future updateCoachingStepDate({required String date}) async {
    return await speakersCollection.doc(id!).update({
      'coachingStepDate': date,
    });
  }

  Future editPersonalInfo({
    ///Personal Info
    required String name,
    required String email,
    required String link,
    required String instagram,
    required String facebook,
    required String linkedin,
    required String description,
    required String company,
    required String job,
    required String dressSize,
  }) async {
    return await speakersCollection.doc(id!).update({
      ///Personal info
      'name': name,
      'email': email,
      'link': link,
      'instagram': instagram,
      'facebook': facebook,
      'linkedin': linkedin,
      'description': description,
      'company': company,
      'job': job,
      'dressSize': dressSize,
    });
  }

  Future<void> editReleaseDownloadLink({
    required String link,
  }) async {
    return await speakersCollection.doc(id).update({
      'urlReleaseForm': link,
    });
  }

  Future editHotelAndLogistics({
    ///Hotel and Logistics
    required String checkInDate,
    required String departureDate,
    required String roomType,
    required int companions,
  }) async {
    return await speakersCollection.doc(id!).update({
      ///Hotel and Logistics
      'checkInDate': checkInDate,
      'departureDate': departureDate,
      'roomType': roomType,
      'companions': companions,
    });
  }

  ///Coaching
  Future editSpeakerCoach({
    required String uidCoach,
  }) async {
    return await speakersCollection.doc(id).update({
      'coach': uidCoach,
    });
  }

  Future editSpeakerUidCreator({
    required String uidTeam,
  }) async {
    return await speakersCollection.doc(id).update({
      'uidCreator': uidTeam,
    });
  }

  Future editTalkDownloadLink({
    required String link,
  }) async {
    return await speakersCollection.doc(id).update({
      'talkDownloadLink': link,
    });
  }

  Future removeFromThisEvent() async {
    return await speakersCollection
        .doc(id)
        .update({'thisEvent': false, 'progress': Progress.backlog.toString()});
  }

  Future enableAllForThisEvent() async {
    QuerySnapshot eventsQuery =
        await speakersCollection.where('thisEvent', isEqualTo: false).get();
    for (QueryDocumentSnapshot eachDoc in eventsQuery.docs) {
      eachDoc.reference.update({'thisEvent': true});
    }
  }

  ///SPEAKER list from snapshot

  Speaker speakersFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Progress progress = Progress.backlog;

    switch (snapshot.data()!['progress']) {
      case 'Progress.backlog':
        {
          progress = Progress.backlog;
        }
        break;

      case 'Progress.selected':
        {
          progress = Progress.selected;
        }
        break;

      case 'Progress.contacted':
        {
          progress = Progress.contacted;
        }
        break;
      case 'Progress.confirmed':
        {
          progress = Progress.confirmed;
        }
        break;
      case 'Progress.ready':
        {
          progress = Progress.ready;
        }
        break;
    }
    return Speaker(
      id: snapshot.data()?['id'] ?? '',
      uidCreator: snapshot.data()?['uidCreator'] ?? '',
      thisEvent: snapshot.data()?['thisEvent'] ?? false,
      progress: progress,

      ///Account information
      accessID: snapshot.data()?['accessID'] ?? '',
      accessPassword: snapshot.data()?['accessPassword'] ?? '',

      ///Step
      managementStep: snapshot.data()?['managementStep'] ?? 0,
      managementStepDate: snapshot.data()?['managementStepDate'] ?? '',
      coachingStep: snapshot.data()?['coachingStep'] ?? 0,
      coachingStepDate: snapshot.data()?['coachingStepDate'] ?? '',

      ///Personal Info
      name: snapshot.data()?['name'] ?? '',
      email: snapshot.data()?['email'] ?? '',
      link: snapshot.data()?['link'] ?? '',
      instagram: snapshot.data()?['instagram'] ?? '',
      facebook: snapshot.data()?['facebook'] ?? '',
      linkedin: snapshot.data()?['linkedin'] ?? '',
      description: snapshot.data()?['description'] ?? '',
      company: snapshot.data()?['company'] ?? '',
      job: snapshot.data()?['job'] ?? '',
      dressSize: snapshot.data()?['dressSize'] ?? '',
      urlReleaseForm: snapshot.data()?['urlReleaseForm'] ?? '',

      ///Hotel and Logistics
      checkInDate: snapshot.data()?['checkInDate'] ?? '',
      departureDate: snapshot.data()?['departureDate'] ?? '',
      roomType: snapshot.data()?['roomType'] ?? '',
      companions: snapshot.data()?['companions'] ?? 0,

      ///Coaching
      coach: snapshot.data()?['coach'] ?? '',
      talkDownloadLink: snapshot.data()?['talkDownloadLink'] ?? '',
      coachEventId: snapshot.data()?['coachEventId'] ?? '',
    );
  }

  List<Speaker> speakersListFromSnapshot(
          QuerySnapshot<Map<String, dynamic>> snapshot) =>
      snapshot.docs.map((snapshot) => speakersFromSnapshot(snapshot)).toList();

  ///GET SPEAKERS STREAM
  Stream<Speaker> get speakerData {
    return speakersCollection.doc(id).snapshots().map(speakersFromSnapshot);
  }

  ///QUERY FOR PROCESS PAGE
  Stream<QuerySnapshot<Map<String, dynamic>>> get progressQuery {
    return speakersCollection
        .where('progress', isEqualTo: progress.toString())
        .where('thisEvent', isEqualTo: true)
        .orderBy('name')
        .snapshots();
  }

  ///QUERY FOR PROCESS PAGE
  Stream<List<Speaker>?> get allQuery {
    return speakersCollection
        .where('thisEvent', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(speakersListFromSnapshot);
  }
}
