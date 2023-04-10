import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InfoAppTeam extends StatefulWidget {
  final License? license;
  final UserData? userData;

  const InfoAppTeam({super.key, required this.license, required this.userData});

  @override
  InfoAppTeamState createState() => InfoAppTeamState();
}

class InfoAppTeamState extends State<InfoAppTeam> {
  String licenseId = "NO_ID";

  ///Software version
  String version = '';

  void loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  ///Edit UserData
  late String name;
  bool editingName = false;
  TextEditingController nameController = TextEditingController();

  late String surname;
  bool editingSurname = false;
  TextEditingController surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVersion();
    setState(() {
      nameController.text = widget.userData?.name ?? '';
      surnameController.text = widget.userData?.surname ?? '';
      if (widget.license != null) {
        licenseId = widget.license!.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 8,
            horizontal: MediaQuery.of(context).size.width / 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: GestureDetector(
            onTap: () async {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                if (!Platform.isMacOS) {
                  currentFocus.unfocus();
                }
                setState(() {
                  editingName = false;
                  editingSurname = false;
                });
                if (name.isNotEmpty) {
                  await DatabaseUser(
                          licenseId: licenseId, uid: widget.userData?.uid)
                      .updateUserSinglePersonalData(field: 'name', value: name);
                }
                if (surname.isNotEmpty) {
                  await DatabaseUser(
                          licenseId: licenseId, uid: widget.userData?.uid)
                      .updateUserSinglePersonalData(
                          field: 'surname', value: surname);
                }
              }
            },
            child: CupertinoPageScaffold(
              resizeToAvoidBottomInset: false,
              navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                middle: Text('Impostazioni'),
              ),
              child: StreamBuilder<License>(
                  stream: DatabaseLicense(licenseId).stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      License appSettings = snapshot.data!;
                      bool registration = appSettings.registration;

                      //TODO FIXARE EVENT DATE
                      String eventDate = 'dd-MM-yyyy';
                      bool bags = appSettings.bags;

                      return CupertinoSettings(
                        items: <Widget>[
                          const CSHeader('SOFTWARE'),
                          CSControl(
                            nameWidget: Text(TextLabels.kAppName),
                            contentWidget: Text(
                              version,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          if (widget.userData?.role == Role.admin) ...[
                            CSControl(
                              nameWidget: Text('Registrazione'),
                              contentWidget: CupertinoSwitch(
                                value: registration,
                                onChanged: (bool value) async {
                                  setState(() {
                                    registration = !registration;
                                  });
                                  await DatabaseLicense(licenseId)
                                      .editRegistration(
                                          registration: registration);
                                },
                              ),
                            ),
                            CSButton(
                                CSButtonType.DEFAULT,
                                "Ripristina lista",
                                () => DatabaseSpeaker(licenseId: licenseId)
                                    .enableAllForThisEvent()
                                    .whenComplete(
                                        () => Navigator.of(context).pop())),
                            CSHeader('Evento'),
                            CSControl(
                              nameWidget: Text('Bags'),
                              contentWidget: CupertinoSwitch(
                                value: bags,
                                onChanged: (bool value) async {
                                  setState(() {
                                    bags = !bags;
                                  });
                                  await DatabaseLicense(licenseId)
                                      .editBags(bags: bags);
                                },
                              ),
                            ),
                            CSControl(
                              nameWidget: Text('Data'),
                              contentWidget: TextButton(
                                child: Text(
                                  eventDate,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .actionTextStyle,
                                ),
                                style: TextButton.styleFrom(
                                    //backgroundColor: Colors.red,
                                    padding: EdgeInsets.all(0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                onPressed: () {
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    builder: (_) => DateTimePickerModal(
                                      pickerType: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (val) {
                                        setState(() {
                                          eventDate = val.toIso8601String();
                                        });
                                      },
                                      onPressed: () async {
                                        await DatabaseLicense(licenseId)
                                            .editEventDate(date: eventDate);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              ),
                              addPaddingToBorder: false,
                            ),
                          ],
                          const CSHeader('Account'),
                          CSControl(
                            nameWidget: Text('Nome'),
                            contentWidget: Expanded(
                              child: CupertinoTextFormFieldRow(
                                padding: EdgeInsets.zero,
                                textAlign: TextAlign.end,
                                textCapitalization: TextCapitalization.words,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navActionTextStyle
                                    .copyWith(
                                        color: editingName
                                            ? kColorAccent
                                            : kColorGrey),
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                onSaved: (val) {
                                  print('SAVED $val');
                                },
                                onTap: () {
                                  setState(() {
                                    editingName = !editingName;
                                  });
                                },
                                onEditingComplete: () async {
                                  if (name.isNotEmpty) {
                                    await DatabaseUser(
                                            licenseId: licenseId,
                                            uid: widget.userData?.uid)
                                        .updateUserSinglePersonalData(
                                            field: 'name', value: name);
                                  }
                                },
                              ),
                            ),
                          ),
                          CSControl(
                            nameWidget: Text('Cognome'),
                            contentWidget: Expanded(
                              child: CupertinoTextFormFieldRow(
                                controller: surnameController,
                                padding: EdgeInsets.zero,
                                textAlign: TextAlign.end,
                                textCapitalization: TextCapitalization.words,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navActionTextStyle
                                    .copyWith(
                                        color: editingSurname
                                            ? kColorAccent
                                            : kColorGrey),
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  setState(() {
                                    surname = value;
                                  });
                                },
                                onSaved: (val) {
                                  print('SAVED $val');
                                },
                                onTap: () {
                                  setState(() {
                                    editingSurname = !editingSurname;
                                  });
                                },
                                onEditingComplete: () async {
                                  print('EDITING COMPLETE');
                                  if (surname.isNotEmpty) {
                                    await DatabaseUser(
                                            licenseId: licenseId,
                                            uid: widget.userData?.uid)
                                        .updateUserSinglePersonalData(
                                            field: 'surname', value: surname);
                                  }
                                },
                              ),
                            ),
                          ),
                          CSControl(
                            nameWidget: Text('Email'),
                            contentWidget: Text(
                              widget.userData?.email ?? '',
                              style: kSettingsDescriptionStyle,
                            ),
                            addPaddingToBorder: false,
                          ),
                          const CSHeader(''),
                          CSButton(
                            CSButtonType.DESTRUCTIVE,
                            "Disconnetti",
                            () async {
                              await AuthService().signOut().whenComplete(
                                  () => Navigator.of(context).pop());
                            },
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
