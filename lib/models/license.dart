class License {
  const License({
    required this.id,
    required this.active,
    required this.adminUid,
    required this.licenseName,
    required this.registration,
    required this.eventDate,
    required this.bags,
    required this.urlReleaseForm,
  });

  final String id;
  final bool active;
  final String adminUid;
  final String licenseName;
  final bool registration;
  final String eventDate;
  final bool bags;
  final String urlReleaseForm;
}
