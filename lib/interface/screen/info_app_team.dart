import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tedxcommunity/services/imports.dart';

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

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(
        () => version = '${packageInfo.version}+${packageInfo.buildNumber}');
  }

  ///Edit UserData
  bool editingName = false;
  TextEditingController nameController = TextEditingController();

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
                if (nameController.text.isNotEmpty) {
                  await DatabaseUser(
                          licenseId: widget.license.id,
                          uid: widget.userData.uid)
                      .updateUserDataPersonal(
                          field: 'name', value: nameController.text);
                }
                if (surnameController.text.isNotEmpty) {
                  await DatabaseUser(
                          licenseId: widget.license.id,
                          uid: widget.userData.uid)
                      .updateUserDataPersonal(
                          field: 'surname', value: surnameController.text);
                }
              }
            },
            child: CupertinoPageScaffold(
              resizeToAvoidBottomInset: false,
              navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                middle: Text(AppLocalizations.of(context)!.settings),
              ),
              child: StreamBuilder<License>(
                  stream: DatabaseLicense(widget.license.id).stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      License appSettings = snapshot.data!;
                      bool registration = appSettings.registration;

                      DateTime eventDate = appSettings.eventDate;
                      bool bags = appSettings.bags;

                      return CupertinoSettings(
                        items: <Widget>[
                          CSHeader(AppLocalizations.of(context)!.settings),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.licenseId),
                            contentWidget: Text(
                              widget.license.id,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.name),
                            contentWidget: Text(
                              widget.license.licenseName,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            addPaddingToBorder:
                                widget.userData.role == Role.admin,
                            nameWidget:
                                Text(AppLocalizations.of(context)!.admin),
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
                              nameWidget: Text(AppLocalizations.of(context)!
                                  .userRegistration),
                              contentWidget: CupertinoSwitch(
                                value: registration,
                                activeColor: Style.primaryColor,
                                onChanged: (bool value) async {
                                  setState(() => registration = !registration);
                                  await DatabaseLicense(widget.license.id)
                                      .editRegistration(
                                          registration: registration);
                                },
                              ),
                            ),
                            CSLink(
                                title: AppLocalizations.of(context)!.editTeam,
                                onPressed: () => showCupertinoModalBottomSheet(
                                      backgroundColor:
                                          Style.backgroundColor(context),
                                      context: context,
                                      builder: (context) {
                                        return const EditTeam();
                                      },
                                    )),
                            CSControl(
                              nameWidget:
                                  Text(AppLocalizations.of(context)!.eventDate),
                              contentWidget: TextButton(
                                style: TextButton.styleFrom(
                                    //backgroundColor: Colors.red,
                                    padding: const EdgeInsets.all(0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                onPressed: () {
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    builder: (_) => DateTimePickerModal(
                                      pickerType: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (val) {
                                        setState(() => eventDate = val);
                                      },
                                      onPressed: () async {
                                        EasyLoading.show();
                                        await DatabaseLicense(widget.license.id)
                                            .editEventDate(date: eventDate)
                                            .whenComplete(() {
                                          EasyLoading.dismiss();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  DateFormat('dd-MM-yyyy').format(eventDate),
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .actionTextStyle,
                                ),
                              ),
                            ),
                            CSControl(
                              nameWidget:
                                  Text(AppLocalizations.of(context)!.bags),
                              contentWidget: CupertinoSwitch(
                                value: bags,
                                activeColor: Style.primaryColor,
                                onChanged: (bool value) async {
                                  setState(() {
                                    bags = !bags;
                                  });
                                  await DatabaseLicense(widget.license.id)
                                      .editBags(bags: bags);
                                },
                              ),
                            ),
                            CSButton(
                                CSButtonType.DEFAULT,
                                AppLocalizations.of(context)!.resetList,
                                () => DatabaseSpeaker(
                                        licenseId: widget.license.id)
                                    .enableAllForThisEvent()
                                    .whenComplete(
                                        () => Navigator.of(context).pop())),
                          ],
                          CSHeader(AppLocalizations.of(context)!.account),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.role),
                            contentWidget: Text(
                              TextLabels.userRoleToString(
                                  widget.userData.role, context),
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.name),
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
                                onTap: () =>
                                    setState(() => editingName = !editingName),
                                onEditingComplete: () async {
                                  if (nameController.text.isNotEmpty) {
                                    await DatabaseUser(
                                            licenseId: widget.license.id,
                                            uid: widget.userData.uid)
                                        .updateUserDataPersonal(
                                            field: 'name',
                                            value: nameController.text);
                                  }
                                },
                              ),
                            ),
                          ),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.surname),
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
                                onTap: () => setState(
                                    () => editingSurname = !editingSurname),
                                onEditingComplete: () async {
                                  if (surnameController.text.isNotEmpty) {
                                    await DatabaseUser(
                                            licenseId: widget.license.id,
                                            uid: widget.userData.uid)
                                        .updateUserDataPersonal(
                                            field: 'surname',
                                            value: surnameController.text);
                                  }
                                },
                              ),
                            ),
                          ),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.email),
                            contentWidget: Text(
                              widget.userData.email,
                              style: kSettingsDescriptionStyle,
                            ),
                            addPaddingToBorder: false,
                          ),
                          CSHeader(AppLocalizations.of(context)!.software),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.name),
                            contentWidget: Text(
                              AppLocalizations.of(context)!.appName,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSControl(
                            nameWidget:
                                Text(AppLocalizations.of(context)!.version),
                            contentWidget: Text(
                              version,
                              style: kSettingsDescriptionStyle,
                            ),
                          ),
                          CSLink(
                              title: AppLocalizations.of(context)!.sourceCode,
                              onPressed: () =>
                                  launchUrlString(kGitHubSourceCodeLink)),
                          CSLink(
                            title: AppLocalizations.of(context)!.credits,
                            onPressed: () => showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => CupertinoAlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .credits),
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .creditsDescription),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .close),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    )),
                            addPaddingToBorder: false,
                          ),
                          CSDescription(
                              '${AppLocalizations.of(context)!.developedWithLoveBy} ${AppLocalizations.of(context)!.developerName}.'),
                          const CSHeader(''),
                          CSButton(
                            CSButtonType.DEFAULT_CENTER,
                            AppLocalizations.of(context)!.createNewLicense,
                            () => showCupertinoDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .createNewLicense),
                                      content: Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!
                                              .createNewLicenseAlertDialog),
                                          Text(
                                              '\n${AppLocalizations.of(context)!.actual}:'),
                                          Text(
                                            '${widget.license.licenseName}: ${widget.license.id}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    Style.textColor(context)),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                              style: const TextStyle(
                                                  color: CupertinoColors
                                                      .destructiveRed),
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              ///1. Create new licenseId
                                              String newLicenseId = const Uuid()
                                                  .v1()
                                                  .substring(0, 5)
                                                  .toUpperCase();

                                              await DatabaseLicense(
                                                      newLicenseId)
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
                                                        adminUid:
                                                            widget.userData.uid,
                                                        onLogin: () async {
                                                          ///1. Create admin inside new license
                                                          await DatabaseUser(
                                                                  licenseId:
                                                                      newLicenseId,
                                                                  uid: widget
                                                                      .userData
                                                                      .uid)
                                                              .createAdmin(
                                                            nameController.text,
                                                            surnameController
                                                                .text,
                                                            widget
                                                                .userData.email,
                                                          );

                                                          ///2. Clear license from session

                                                          await SharedPreferences
                                                                  .getInstance()
                                                              .then((prefs) {
                                                            prefs.setString(
                                                                kLicenseIdKey,
                                                                newLicenseId);

                                                            //3. Logout
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            ///4. Show success
                                                            EasyLoading.showSuccess(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .nowYouAreInTheNewLicense);
                                                          });
                                                        },
                                                      );
                                                    });
                                              });
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .create,
                                              style: const TextStyle(
                                                  color: CupertinoColors
                                                      .activeBlue),
                                            )),
                                      ],
                                    )),
                          ),
                          const CSSpacer(),
                          CSButton(
                            CSButtonType.DESTRUCTIVE,
                            AppLocalizations.of(context)!.exit,
                            () async {
                              await AuthService().signOut().whenComplete(
                                  () => Navigator.of(context).pop());
                            },
                          ),
                          const CSSpacer(),
                        ],
                      );
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
