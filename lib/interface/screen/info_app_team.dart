import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InfoAppTeam extends StatefulWidget {
  final License license;
  final UserData userData;

  const InfoAppTeam({super.key, required this.license, required this.userData});

  @override
  InfoAppTeamState createState() => InfoAppTeamState();
}

class InfoAppTeamState extends State<InfoAppTeam> {
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
      nameController.text = widget.userData.name;
      surnameController.text = widget.userData.surname;
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
                          licenseId: widget.license.id,
                          uid: widget.userData.uid)
                      .updateUserSinglePersonalData(field: 'name', value: name);
                }
                if (surname.isNotEmpty) {
                  await DatabaseUser(
                          licenseId: widget.license.id,
                          uid: widget.userData.uid)
                      .updateUserSinglePersonalData(
                          field: 'surname', value: surname);
                }
              }
            },
            child: CupertinoPageScaffold(
              resizeToAvoidBottomInset: false,
              navigationBar: const CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                middle: Text('Impostazioni'),
              ),
              child: StreamBuilder<License>(
                  stream: DatabaseLicense(widget.license.id).stream,
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
                            addPaddingToBorder: false,
                          ),
                          CSDescription(
                              'This is an open-source software and free to use.'),
                          const CSHeader('LICENZA'),
                          CSControl(
                            nameWidget: const Text('Id'),
                            contentWidget: Text(
                              widget.license.id,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            nameWidget: const Text('Nome'),
                            contentWidget: Text(
                              widget.license.licenseName,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            nameWidget: const Text('Admin'),
                            contentWidget: StreamBuilder<UserData?>(
                                stream: DatabaseUser(
                                        licenseId: widget.license.id,
                                        uid: widget.license.adminUid)
                                    .userData,
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data?.name} ${snapshot.data?.surname}',
                                    style: kSettingsDescriptionStyle,
                                  );
                                }),
                          ),
                          if (widget.userData.role == Role.admin) ...[
                            CSControl(
                              nameWidget: const Text('Registrazione'),
                              contentWidget: CupertinoSwitch(
                                value: registration,
                                onChanged: (bool value) async {
                                  setState(() {
                                    registration = !registration;
                                  });
                                  await DatabaseLicense(widget.license.id)
                                      .editRegistration(
                                          registration: registration);
                                },
                              ),
                            ),
                            CSButton(
                                CSButtonType.DEFAULT,
                                "Ripristina lista",
                                () => DatabaseSpeaker(
                                        licenseId: widget.license.id)
                                    .enableAllForThisEvent()
                                    .whenComplete(
                                        () => Navigator.of(context).pop())),
                            const CSHeader('Evento'),
                            CSControl(
                              nameWidget: const Text('Bags'),
                              contentWidget: CupertinoSwitch(
                                value: bags,
                                onChanged: (bool value) async {
                                  setState(() {
                                    bags = !bags;
                                  });
                                  await DatabaseLicense(widget.license.id)
                                      .editBags(bags: bags);
                                },
                              ),
                            ),
                            CSControl(
                              nameWidget: const Text('Data'),
                              contentWidget: TextButton(
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
                                        await DatabaseLicense(widget.license.id)
                                            .editEventDate(date: eventDate);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  eventDate,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .actionTextStyle,
                                ),
                              ),
                              addPaddingToBorder: false,
                            ),
                          ],
                          const CSHeader('ACCOUNT'),
                          CSControl(
                            nameWidget: const Text('Ruolo'),
                            contentWidget: Text(
                              widget.userData.role.toString(),
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            nameWidget: const Text('Nome'),
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
                                            licenseId: widget.license.id,
                                            uid: widget.userData.uid)
                                        .updateUserSinglePersonalData(
                                            field: 'name', value: name);
                                  }
                                },
                              ),
                            ),
                          ),
                          CSControl(
                            nameWidget: const Text('Cognome'),
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
                                            licenseId: widget.license.id,
                                            uid: widget.userData.uid)
                                        .updateUserSinglePersonalData(
                                            field: 'surname', value: surname);
                                  }
                                },
                              ),
                            ),
                          ),
                          CSControl(
                            nameWidget: const Text('Email'),
                            contentWidget: Text(
                              widget.userData.email,
                              style: kSettingsDescriptionStyle,
                            ),
                            addPaddingToBorder: false,
                          ),
                          const CSHeader(''),
                          CSButton(
                            CSButtonType.DEFAULT_CENTER,
                            "Crea nuova licenza",
                            () async {
                              ///1. Create new licenseId
                              String newLicenseId = const Uuid()
                                  .v1()
                                  .substring(0, 5)
                                  .toUpperCase();

                              await DatabaseLicense(newLicenseId)
                                  .checkExistence
                                  .then((alreadyExist) {
                                if (alreadyExist) {
                                  //Set new ID
                                  newLicenseId = const Uuid()
                                      .v1()
                                      .substring(0, 5)
                                      .toUpperCase();
                                }
                              }).whenComplete(() {
                                ///2. Create a license
                                showCupertinoDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AddLicense(
                                      licenseId: newLicenseId,
                                      adminUid: widget.userData.uid,
                                      onLogin: () async {
                                        ///1. Create admin inside new license
                                        await DatabaseUser(
                                                licenseId: newLicenseId,
                                                uid: widget.userData.uid)
                                            .createAdmin(
                                          nameController.text,
                                          surnameController.text,
                                          widget.userData.email,
                                        );

                                        ///2. Clear license from session

                                        await SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setString(
                                              kLicenseIdKey, newLicenseId);

                                          //3. Logout
                                          Navigator.of(context).pop();

                                          ///4. Show success
                                          EasyLoading.showSuccess(
                                              'Ora sei dentro la nuova licenza!',
                                              duration:
                                                  const Duration(seconds: 4));
                                        });
                                      },
                                    );
                                  },
                                );
                              });
                            },
                          ),
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
