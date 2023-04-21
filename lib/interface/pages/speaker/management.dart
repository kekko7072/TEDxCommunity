import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class Management extends StatefulWidget {
  final Speaker speakerData;
  final bool showMobileTitle;

  const Management(
      {super.key, required this.speakerData, required this.showMobileTitle});

  @override
  ManagementState createState() => ManagementState();
}

class ManagementState extends State<Management> {
  int currentManagementStep = 0;
  bool showSecondCard = false;

  String checkInDate = '';
  String departureDate = '';

  bool _loadingPath = false;
  bool _loadingDone = false;

  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
    setState(() {
      currentManagementStep = widget.speakerData.managementStep;
      currentManagementStep > 1
          ? showSecondCard = true
          : showSecondCard = false;
    });
  }

  ///File Picker & Uploader
  Future<void> _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      FilePickerResult? picked = await FilePicker.platform.pickFiles();

      if (picked != null) {
        if (kIsWeb) {
          uploadFile(picked.files.first.bytes!, picked.files.first.extension!);
        } else {
          if (picked.files.first.path != '') {
            uploadFile(await File(picked.files.first.path!).readAsBytes(),
                picked.files.first.extension!);
          } else {
            print('PATH FILE NULL!');
          }
        }
      } else {
        setState(() => _loadingPath = false);
      }
    } on PlatformException catch (e) {
      print('ERROR Unsupported operation$e');
    } catch (ex) {
      print('EX ERROR$ex');
    }
  }

  Future<void> uploadFile(Uint8List data, String extension) async {
    Reference reference = FirebaseStorage.instance
        .ref('$licenseId/releaseForms/${widget.speakerData.id}.$extension');
    TaskSnapshot uploadTask = await reference.putData(data);

    String url = await uploadTask.ref.getDownloadURL();

    await DatabaseSpeaker(licenseId: licenseId, id: widget.speakerData.id)
        .editReleaseDownloadLink(link: url);
    if (uploadTask.state == TaskState.success) {
      setState(() {
        _loadingPath = false;
        _loadingDone = true;
      });
    } else {
      print(uploadTask.state);
      setState(() {
        _loadingPath = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ///Personal Info
    //-controller
    TextEditingController nameController =
        TextEditingController(text: widget.speakerData.name);
    TextEditingController emailController =
        TextEditingController(text: widget.speakerData.email);
    TextEditingController companyController =
        TextEditingController(text: widget.speakerData.company);
    TextEditingController jobController =
        TextEditingController(text: widget.speakerData.job);
    TextEditingController descriptionController =
        TextEditingController(text: widget.speakerData.description);
    //-variables
    late String name = widget.speakerData.name;
    late String email = widget.speakerData.email;
    late String instagram = widget.speakerData.instagram!.isEmpty
        ? ''
        : widget.speakerData.instagram!;
    late String facebook = widget.speakerData.facebook!.isEmpty
        ? ''
        : widget.speakerData.facebook!;
    late String linkedin = widget.speakerData.linkedin!.isEmpty
        ? ''
        : widget.speakerData.linkedin!;
    late String company =
        widget.speakerData.company!.isEmpty ? '' : widget.speakerData.company!;
    late String job =
        widget.speakerData.job!.isEmpty ? '' : widget.speakerData.job!;
    late String description = widget.speakerData.description;
    late String dressSize = '';

    ///Hotel and Logistics
    late String checkInDate = widget.speakerData.checkInDate!.isEmpty
        ? AppLocalizations.of(context)!.select
        : widget.speakerData.checkInDate!;
    late String departureDate = widget.speakerData.departureDate!.isEmpty
        ? AppLocalizations.of(context)!.select
        : widget.speakerData.departureDate!;

    TextEditingController roomTypeController =
        TextEditingController(text: widget.speakerData.roomType);

    late String roomType = roomTypeController.text;

    TextEditingController companionsController =
        TextEditingController(text: widget.speakerData.companions.toString());

    late int companions = int.parse(companionsController.text);

    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) settingState) {
      return CustomScrollView(
        semanticChildCount: 1,
        slivers: <Widget>[
          if (widget.showMobileTitle) ...[
            if (widget.showMobileTitle) ...[
              TopBarSpeaker(
                  speakerData: widget.speakerData,
                  title: AppLocalizations.of(context)!.account),
            ],
          ],

          ///http://52.28.135.217/eventsup/speaker-cortina/
          SliverFillRemaining(
              child: Column(
            children: [
              currentManagementStep == 1
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        color: Style.backgroundColor(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.data,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navTitleTextStyle,
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                controller: nameController,
                                placeholder: AppLocalizations.of(context)!.name,
                                keyboardType: TextInputType.name,
                                onChanged: (value) => name = value,
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                controller: emailController,
                                placeholder:
                                    AppLocalizations.of(context)!.email,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) => email = value,
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                controller: companyController,
                                placeholder: 'Azienda',
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  company = value;
                                },
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                controller: jobController,
                                placeholder: AppLocalizations.of(context)!.job,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  job = value;
                                },
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                placeholder: 'Instagram',
                                keyboardType: TextInputType.url,
                                onChanged: (value) {
                                  instagram = value;
                                },
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                placeholder: 'Facebook',
                                keyboardType: TextInputType.url,
                                onChanged: (value) {
                                  facebook = value;
                                },
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                placeholder: 'Linkedin',
                                keyboardType: TextInputType.url,
                                onChanged: (value) {
                                  linkedin = value;
                                },
                              ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                keyboardType: TextInputType.text,
                                placeholder:
                                    AppLocalizations.of(context)!.sizeClothes,
                                onChanged: (value) => dressSize = value,
                              ),
                              Builder(
                                builder: (BuildContext context) => Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .releaseForm,
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .actionTextStyle
                                            .copyWith(
                                              color:
                                                  CupertinoColors.inactiveGray,
                                            ),
                                      ),
                                      _loadingPath
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 16),
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Row(
                                              children: [
                                                StreamBuilder<License>(
                                                    stream: DatabaseLicense(
                                                            licenseId)
                                                        .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        License appSettings =
                                                            snapshot.data!;
                                                        return CupertinoButton(
                                                          onPressed: () async {
                                                            if (await canLaunchUrlString(
                                                                appSettings
                                                                    .urlReleaseForm)) {
                                                              await launchUrlString(
                                                                appSettings
                                                                    .urlReleaseForm,
                                                              );
                                                            } else {
                                                              throw 'Could not launch the url';
                                                            }
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .download),
                                                        );
                                                      } else {
                                                        return const CupertinoActivityIndicator();
                                                      }
                                                    }),
                                                CupertinoButton(
                                                  onPressed: () =>
                                                      _openFileExplorer(),
                                                  child: _loadingDone
                                                      ? Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .edit,
                                                          style: const TextStyle(
                                                              color: CupertinoColors
                                                                  .destructiveRed),
                                                        )
                                                      : Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .download,
                                                        ),
                                                )
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              _loadingDone
                                  ? Container()
                                  : Text(
                                      AppLocalizations.of(context)!
                                          .releaseFormMustBeCompletedAndSendHere,
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .navActionTextStyle
                                          .copyWith(
                                            fontSize: 12,
                                            color: CupertinoColors.inactiveGray,
                                          ),
                                    ),
                              CupertinoTextFormFieldRow(
                                decoration: BoxDecoration(
                                  color: Style.inputTextFieldColor(context),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Style.inputTextFieldRadius)),
                                ),
                                controller: descriptionController,
                                keyboardType: TextInputType.text,
                                minLines: 2,
                                maxLines: 5,
                                placeholder: AppLocalizations.of(context)!
                                    .shortBiography,
                                onChanged: (value) => description = value,
                              ),
                              CupertinoButton.filled(
                                  child:
                                      Text(AppLocalizations.of(context)!.send),
                                  onPressed: () async {
                                    setState(() {
                                      currentManagementStep = 2;
                                      showSecondCard = true;
                                    });
                                    await DatabaseSpeaker(
                                            licenseId: licenseId,
                                            id: widget.speakerData.id)
                                        .editPersonalInfo(
                                            name: name,
                                            email: email,
                                            link: '',
                                            instagram: instagram,
                                            facebook: facebook,
                                            linkedin: linkedin,
                                            description: description,
                                            company: company,
                                            job: job,
                                            dressSize: dressSize);
                                    await DatabaseSpeaker(
                                            licenseId: licenseId,
                                            id: widget.speakerData.id)
                                        .updateManagementStep(step: 2);
                                  }),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        color: Style.backgroundColor(context),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.data,
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .navTitleTextStyle,
                                    ),
                                    TextButton(
                                      child: Text(
                                          AppLocalizations.of(context)!.edit,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .navActionTextStyle),
                                      onPressed: () => setState(
                                          () => currentManagementStep = 1),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Icon(
                                  CupertinoIcons.check_mark_circled,
                                  color: CupertinoColors.activeGreen,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              showSecondCard
                  ? currentManagementStep == 2
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            color: Style.backgroundColor(context),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .hotelAndLogistics,
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .navTitleTextStyle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .checkInDate,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .actionTextStyle
                                              .copyWith(
                                                color: CupertinoColors
                                                    .inactiveGray,
                                              ),
                                        ),
                                        CupertinoButton(
                                            child: Text(checkInDate.isEmpty
                                                ? AppLocalizations.of(context)!
                                                    .select
                                                : checkInDate),
                                            onPressed: () {
                                              showCupertinoModalBottomSheet(
                                                backgroundColor:
                                                    Style.backgroundColor(
                                                        context),
                                                context: context,
                                                isDismissible: true,
                                                builder: (_) =>
                                                    DateTimePickerModal(
                                                  pickerType:
                                                      CupertinoDatePickerMode
                                                          .date,
                                                  onDateTimeChanged: (val) {
                                                    settingState(() {
                                                      checkInDate = val
                                                          .toIso8601String()
                                                          .substring(0, 10);
                                                    });
                                                  },
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .checkOutDate,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .actionTextStyle
                                              .copyWith(
                                                color: CupertinoColors
                                                    .inactiveGray,
                                              ),
                                        ),
                                        CupertinoButton(
                                            child: Text(departureDate),
                                            onPressed: () {
                                              showCupertinoModalBottomSheet(
                                                backgroundColor:
                                                    Style.backgroundColor(
                                                        context),
                                                context: context,
                                                isDismissible: true,
                                                builder: (_) =>
                                                    DateTimePickerModal(
                                                  pickerType:
                                                      CupertinoDatePickerMode
                                                          .date,
                                                  onDateTimeChanged: (val) =>
                                                      settingState(() =>
                                                          departureDate = val
                                                              .toIso8601String()
                                                              .substring(
                                                                  0, 10)),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .roomType,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .actionTextStyle
                                              .copyWith(
                                                color: CupertinoColors
                                                    .inactiveGray,
                                              ),
                                        ),
                                        CupertinoButton(
                                            child: Text(roomType.isEmpty
                                                ? AppLocalizations.of(context)!
                                                    .select
                                                : roomType),
                                            onPressed: () {
                                              showCupertinoModalBottomSheet(
                                                  backgroundColor:
                                                      Style.backgroundColor(
                                                          context),
                                                  context: context,
                                                  isDismissible: true,
                                                  builder: (_) => SafeArea(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: 200,
                                                              child:
                                                                  CupertinoPicker(
                                                                onSelectedItemChanged:
                                                                    (value) {
                                                                  switch (
                                                                      value) {
                                                                    case 0:
                                                                      settingState(() =>
                                                                          roomType =
                                                                              AppLocalizations.of(context)!.select);
                                                                      break;
                                                                    case 1:
                                                                      settingState(() =>
                                                                          roomType =
                                                                              AppLocalizations.of(context)!.roomSingle);
                                                                      break;
                                                                    case 2:
                                                                      settingState(() =>
                                                                          roomType =
                                                                              AppLocalizations.of(context)!.roomDouble);
                                                                      break;
                                                                    case 3:
                                                                      settingState(() =>
                                                                          roomType =
                                                                              AppLocalizations.of(context)!.roomTriple);
                                                                      break;
                                                                    case 4:
                                                                      settingState(() =>
                                                                          roomType =
                                                                              AppLocalizations.of(context)!.roomQuadruple);
                                                                      break;
                                                                  }
                                                                },
                                                                itemExtent:
                                                                    32.0,
                                                                children: [
                                                                  Text(AppLocalizations.of(
                                                                          context)!
                                                                      .select),
                                                                  Text(AppLocalizations.of(
                                                                          context)!
                                                                      .roomSingle),
                                                                  Text(AppLocalizations.of(
                                                                          context)!
                                                                      .roomDouble),
                                                                  Text(AppLocalizations.of(
                                                                          context)!
                                                                      .roomTriple),
                                                                  Text(AppLocalizations.of(
                                                                          context)!
                                                                      .roomQuadruple),
                                                                ],
                                                              ),
                                                            ),
                                                            CupertinoButton(
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .save),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            )
                                                          ],
                                                        ),
                                                      ));
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .companions,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .actionTextStyle
                                              .copyWith(
                                                color: CupertinoColors
                                                    .inactiveGray,
                                              ),
                                        ),
                                        CupertinoButton(
                                            child: Text(companions
                                                    .toString()
                                                    .isEmpty
                                                ? AppLocalizations.of(context)!
                                                    .select
                                                : companions.toString()),
                                            onPressed: () {
                                              showCupertinoModalBottomSheet(
                                                  backgroundColor:
                                                      Style.backgroundColor(
                                                          context),
                                                  context: context,
                                                  isDismissible: true,
                                                  builder: (_) => SafeArea(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: 200,
                                                              child:
                                                                  CupertinoPicker(
                                                                onSelectedItemChanged:
                                                                    (value) {
                                                                  settingState(() =>
                                                                      companions =
                                                                          value);
                                                                },
                                                                itemExtent:
                                                                    32.0,
                                                                children: const [
                                                                  Text('0'),
                                                                  Text('1'),
                                                                  Text('2'),
                                                                  Text('3'),
                                                                ],
                                                              ),
                                                            ),
                                                            CupertinoButton(
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .save),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            )
                                                          ],
                                                        ),
                                                      ));
                                            }),
                                      ],
                                    ),
                                  ),
                                  CupertinoButton.filled(
                                      child: Text(
                                          AppLocalizations.of(context)!.send),
                                      onPressed: () async {
                                        setState(() {
                                          currentManagementStep = 3;
                                        });
                                        await DatabaseSpeaker(
                                                licenseId: licenseId,
                                                id: widget.speakerData.id)
                                            .editHotelAndLogistics(
                                                checkInDate: checkInDate,
                                                departureDate: departureDate,
                                                roomType: roomType,
                                                companions: companions);
                                        await DatabaseSpeaker(
                                                licenseId: licenseId,
                                                id: widget.speakerData.id)
                                            .updateManagementStep(step: 3);
                                      }),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            color: Style.backgroundColor(context),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .hotelAndLogistics,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .navTitleTextStyle,
                                        ),
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .edit,
                                              style: CupertinoTheme.of(context)
                                                  .textTheme
                                                  .navActionTextStyle),
                                          onPressed: () async {
                                            setState(() {
                                              currentManagementStep = 2;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Icon(
                                      CupertinoIcons.check_mark_circled,
                                      color: CupertinoColors.activeGreen,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                  : Container(),
            ],
          ))
        ],
      );
    });
  }
}
