import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class AddSpeaker extends StatefulWidget {
  final String uid;

  const AddSpeaker({
    super.key,
    required this.uid,
  });

  @override
  State<AddSpeaker> createState() => _AddSpeakerState();
}

class _AddSpeakerState extends State<AddSpeaker> {
  String licenseId = 'NO_ID';

  final String id = const Uuid().v1();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  int ratePublicSpeaking = 3;
  bool switchJustTEDx = false;
  String justTEDx = '';

  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Speaker>?>(
        stream: DatabaseSpeaker(licenseId: licenseId).allQuery,
        builder: (context, snapshot) {
          return CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context)!.addSpeaker),
            content: Column(
              children: [
                Text(AppLocalizations.of(context)!.insertSpeakerData),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        controller: nameController,
                        placeholder:
                            '${AppLocalizations.of(context)!.name} ${AppLocalizations.of(context)!.surname}',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.mic),
                          onPressed: () => showCupertinoDialog(
                              context: context,
                              builder: (_) => VocalAssistant(
                                  onCompleted: (value) => setState(
                                      () => nameController.text = value))),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        placeholder: AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: const Icon(CupertinoIcons.doc_on_clipboard),
                            onPressed: () =>
                                Clipboard.getData(Clipboard.kTextPlain).then(
                                    (value) => setState(() => emailController
                                        .text = value?.text ?? '')))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        placeholder: AppLocalizations.of(context)!.link,
                        keyboardType: TextInputType.url,
                        controller: linkController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: const Icon(CupertinoIcons.doc_on_clipboard),
                            onPressed: () =>
                                Clipboard.getData(Clipboard.kTextPlain).then(
                                    (value) => setState(() => linkController
                                        .text = value?.text ?? '')))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        placeholder: AppLocalizations.of(context)!.job,
                        keyboardType: TextInputType.text,
                        controller: professionController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.mic),
                          onPressed: () => showCupertinoDialog(
                              context: context,
                              builder: (_) => VocalAssistant(
                                  onCompleted: (value) => setState(() =>
                                      professionController.text = value))),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        placeholder:
                            AppLocalizations.of(context)!.possibleTopicOfTalk,
                        keyboardType: TextInputType.text,
                        controller: topicController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.mic),
                          onPressed: () => showCupertinoDialog(
                              context: context,
                              builder: (_) => VocalAssistant(
                                  onCompleted: (value) => setState(
                                      () => topicController.text = value))),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.of(context)!.publicSpeaking),
                          const SizedBox(width: 10),
                          const Icon(Icons.info)
                        ],
                      ),
                      onTap: () => showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                                content: Text(AppLocalizations.of(context)!
                                    .publicSpeakingDescription),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: const TextStyle(
                                            color: CupertinoColors.activeBlue),
                                      )),
                                ],
                              )),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.minus_circled,
                              color: ratePublicSpeaking == 0
                                  ? CupertinoColors.inactiveGray
                                  : CupertinoColors.activeBlue,
                            ),
                            onPressed: () async {
                              if (ratePublicSpeaking > 0) {
                                setState(() => --ratePublicSpeaking);
                              } else {
                                await EasyLoading.showToast(
                                    AppLocalizations.of(context)!
                                        .thisIsMinValueForPublicSpeaking,
                                    duration: const Duration(seconds: 2),
                                    dismissOnTap: true,
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
                              }
                            }),
                        Text('$ratePublicSpeaking'),
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              CupertinoIcons.add_circled,
                              color: ratePublicSpeaking >= 5
                                  ? CupertinoColors.inactiveGray
                                  : CupertinoColors.activeBlue,
                            ),
                            onPressed: () async {
                              if (ratePublicSpeaking < 5) {
                                setState(() => ++ratePublicSpeaking);
                              } else {
                                await EasyLoading.showToast(
                                    AppLocalizations.of(context)!
                                        .thisIsMaxValueForPublicSpeaking,
                                    duration: const Duration(seconds: 2),
                                    dismissOnTap: true,
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
                              }
                            }),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.alreadyTEDx),
                    CupertinoSwitch(
                        value: switchJustTEDx,
                        activeColor: Style.primaryColor,
                        onChanged: (val) => setState(() {
                              switchJustTEDx = !switchJustTEDx;
                              if (val) {
                                justTEDx =
                                    '${TextLabels.kAddSpeaker3}${AppLocalizations.of(context)!.yes}';
                              } else {
                                justTEDx =
                                    '${TextLabels.kAddSpeaker3}${AppLocalizations.of(context)!.no}';
                              }
                            }))
                  ],
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: bioController,
                  decoration: BoxDecoration(
                    color: Style.inputTextFieldColor(context),
                    borderRadius: BorderRadius.all(
                        Radius.circular(Style.inputTextFieldRadius)),
                  ),
                  suffix: IconButton(
                    icon: const Icon(CupertinoIcons.mic),
                    onPressed: () => showCupertinoDialog(
                        context: context,
                        builder: (_) => VocalAssistant(
                            onCompleted: (value) =>
                                setState(() => bioController.text = value))),
                  ),
                  enableSuggestions: false,
                  minLines: 2,
                  maxLines: 5,
                  maxLength: 200,
                  placeholder: AppLocalizations.of(context)!.shortBiography,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed),
                  )),
              TextButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (snapshot.hasData &&
                            snapshot.data!
                                .where((Speaker spk) =>
                                    TextLabels.formatText(
                                        spk.name.toUpperCase()) ==
                                    TextLabels.formatText(
                                        nameController.text.toUpperCase()))
                                .isEmpty ||
                        !snapshot.hasData) {
                      await DatabaseSpeaker(licenseId: licenseId, id: id)
                          .addSpeaker(
                            uidCreator: widget.uid,
                            name: nameController.text,
                            email: TextLabels.formatEmail(emailController.text),
                            link: linkController.text,
                            description:
                                '${TextLabels.kAddSpeaker0}${professionController.text}\n${TextLabels.kAddSpeaker1}${topicController.text}\n${TextLabels.kAddSpeaker2}$ratePublicSpeaking\n$justTEDx\n${TextLabels.kAddSpeaker4}${bioController.text}',
                          )
                          .whenComplete(() => Navigator.of(context).pop());
                    } else {
                      await EasyLoading.showToast(
                          AppLocalizations.of(context)!.speakerAlreadyAdded,
                          duration: const Duration(seconds: 2),
                          dismissOnTap: true,
                          toastPosition: EasyLoadingToastPosition.bottom);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.add,
                    style: const TextStyle(color: CupertinoColors.activeBlue),
                  )),
            ],
          );
        });
  }
}
