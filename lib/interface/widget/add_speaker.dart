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

  String licenseId = "NO_ID";
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
            title: Text(
              'Aggiungi speaker',
            ),
            content: Column(
              children: [
                Text(
                  'Inserisci dati dello speaker',
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        controller: nameController,
                        placeholder: 'Nome cognome',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(CupertinoIcons.mic),
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
                        placeholder: 'Email',
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
                                        .text = value?.text ?? "")))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        placeholder: 'Link',
                        keyboardType: TextInputType.url,
                        controller: linkController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Icon(CupertinoIcons.doc_on_clipboard),
                            onPressed: () =>
                                Clipboard.getData(Clipboard.kTextPlain).then(
                                    (value) => setState(() => linkController
                                        .text = value?.text ?? "")))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InputFieldWithController(
                        placeholder: 'Professione',
                        keyboardType: TextInputType.text,
                        controller: professionController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(CupertinoIcons.mic),
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
                        placeholder: 'Possibile argomento del talk',
                        keyboardType: TextInputType.text,
                        controller: topicController,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(CupertinoIcons.mic),
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
                    const Text('Public speaking'),
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

                                print(ratePublicSpeaking);
                              } else {
                                await EasyLoading.showToast(
                                    '0 è il valore minimo per il public speaking',
                                    duration: Duration(seconds: 2),
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

                                print(ratePublicSpeaking);
                              } else {
                                await EasyLoading.showToast(
                                    '5 è il valore massimo per il public speaking',
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
                    const Text('Ha già fatto speech a TEDx'),
                    CupertinoSwitch(
                        value: switchJustTEDx,
                        activeColor: Style.primaryColor,
                        onChanged: (val) => setState(() {
                              switchJustTEDx = !switchJustTEDx;
                              if (val) {
                                justTEDx = "${TextLabels.kAddSpeaker3}SI";
                              } else {
                                justTEDx = "${TextLabels.kAddSpeaker3}NO";
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
                  placeholder: 'Una breve biografia',
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Annulla',
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  )),
              TextButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (snapshot.hasData &&
                            snapshot.data!
                                .where((Speaker spk) =>
                                    TextLabels()
                                        .formatText(spk.name.toUpperCase()) ==
                                    TextLabels().formatText(
                                        nameController.text.toUpperCase()))
                                .isEmpty ||
                        !snapshot.hasData) {
                      await DatabaseSpeaker(licenseId: licenseId, id: id)
                          .addSpeaker(
                        uidCreator: widget.uid,
                        name: nameController.text,
                        email: TextLabels().formatEmail(emailController.text),
                        link: linkController.text,
                        description:
                            '${TextLabels.kAddSpeaker0}${professionController.text}\n${TextLabels.kAddSpeaker1}${topicController.text}\n${TextLabels.kAddSpeaker2}$ratePublicSpeaking\n$justTEDx\n${TextLabels.kAddSpeaker4}${bioController.text}',
                      );
                      Navigator.of(context).pop();
                    } else {
                      await EasyLoading.showToast('Speaker già presente',
                          duration: Duration(seconds: 2),
                          dismissOnTap: true,
                          toastPosition: EasyLoadingToastPosition.bottom);
                    }
                  },
                  child: Text(
                    'Aggiungi',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  )),
            ],
          );
        });
  }
}
