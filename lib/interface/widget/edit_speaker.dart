import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class EditSpeaker extends StatefulWidget {
  const EditSpeaker(
      {super.key,
      required this.speaker,
      required this.canDelete,
      required this.progress});

  final Speaker speaker;
  final bool canDelete;
  final Progress progress;

  @override
  State<EditSpeaker> createState() => _EditSpeakerState();
}

class _EditSpeakerState extends State<EditSpeaker> {
  TextEditingController controllerName = TextEditingController();

  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerLink = TextEditingController();

  String description = "";
  TextEditingController controllerDescription = TextEditingController();

  String profession = '';
  TextEditingController controllerProfession = TextEditingController();

  String topic = '';
  TextEditingController controllerTopic = TextEditingController();

  String ratePublicSpeaking = '';
  TextEditingController controllerRatePublicSpeaking = TextEditingController();

  String justTEDx = '';
  TextEditingController controllerJustTEDx = TextEditingController();

  String bio = '';
  TextEditingController controllerBio = TextEditingController();

  String licenseId = "";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));

    controllerName = TextEditingController(text: widget.speaker.name);

    controllerEmail = TextEditingController(text: widget.speaker.email);

    controllerLink = TextEditingController(text: widget.speaker.link);

    ///Profession
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker0) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker1)) {
      int startIndexProfession =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker0);
      int endIndexProfession = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker1,
          startIndexProfession + TextLabels.kAddSpeaker0.length);
      /*profession = widget.speaker.description.substring(
          startIndexProfession + TextLabels.kAddSpeaker0.length,
          endIndexProfession);

       */
      controllerProfession = TextEditingController(
          text: widget.speaker.description.substring(
              startIndexProfession + TextLabels.kAddSpeaker0.length,
              endIndexProfession));
    }

    ///TOPIC
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker1) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker2)) {
      int startIndexTopic =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker1);
      int endIndexTopic = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker2,
          startIndexTopic + TextLabels.kAddSpeaker1.length);
      /*topic = widget.speaker.description.substring(
          startIndexTopic + TextLabels.kAddSpeaker1.length, endIndexTopic);
       */
      controllerTopic = TextEditingController(
          text: widget.speaker.description.substring(
              startIndexTopic + TextLabels.kAddSpeaker1.length, endIndexTopic));
    }

    ///Rate
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker2) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker3)) {
      int startIndexRate =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker2);
      int endIndexRate = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker3,
          startIndexRate + TextLabels.kAddSpeaker2.length);
      /*ratePublicSpeaking = widget.speaker.description.substring(
          startIndexRate + TextLabels.kAddSpeaker2.length, endIndexRate);

       */
      controllerRatePublicSpeaking = TextEditingController(
          text: widget.speaker.description.substring(
              startIndexRate + TextLabels.kAddSpeaker2.length, endIndexRate));
    }

    ///JustTEDx
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker3) &&
        widget.speaker.description.contains(TextLabels.kAddSpeaker4)) {
      int startIndexJustTEDx =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker3);
      int endIndexJustTEDx = widget.speaker.description.indexOf(
          TextLabels.kAddSpeaker4,
          startIndexJustTEDx + TextLabels.kAddSpeaker3.length);
      /*justTEDx = widget.speaker.description.substring(
          startIndexJustTEDx + TextLabels.kAddSpeaker3.length,
          endIndexJustTEDx);

       */

      controllerJustTEDx = TextEditingController(
          text: widget.speaker.description.substring(
              startIndexJustTEDx + TextLabels.kAddSpeaker3.length,
              endIndexJustTEDx));
    }

    ///Bio
    if (widget.speaker.description.contains(TextLabels.kAddSpeaker4)) {
      int startIndexBio =
          widget.speaker.description.indexOf(TextLabels.kAddSpeaker4);

      /* bio = widget.speaker.description.substring(
          startIndexBio + TextLabels.kAddSpeaker4.length,
          widget.speaker.description.length);

      */
      controllerBio = TextEditingController(
          text: widget.speaker.description.substring(
              startIndexBio + TextLabels.kAddSpeaker4.length,
              widget.speaker.description.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(AppLocalizations.of(context)!.edit),
          onPressed: () {
            Navigator.pop(context);
            showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(AppLocalizations.of(context)!.edit),
                  content: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.edit),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        enableSuggestions: true,
                        controller: controllerName,
                        decoration: BoxDecoration(
                          color: CupertinoDynamicColor.resolve(
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFF0F0F0),
                                darkColor: Color(0xBF1E1E1E),
                              ),
                              context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        //placeholder: speaker.name,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        enableSuggestions: true,
                        controller: controllerEmail,
                        decoration: BoxDecoration(
                          color: CupertinoDynamicColor.resolve(
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFF0F0F0),
                                darkColor: Color(0xBF1E1E1E),
                              ),
                              context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      widget.progress == Progress.confirmed
                          ? Container()
                          : CupertinoTextField(
                              enableSuggestions: true,
                              controller: controllerLink,
                              decoration: BoxDecoration(
                                color: CupertinoDynamicColor.resolve(
                                    const CupertinoDynamicColor.withBrightness(
                                      color: Color(0xFFF0F0F0),
                                      darkColor: Color(0xBF1E1E1E),
                                    ),
                                    context),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              placeholder: 'Link',
                              keyboardType: TextInputType.url,
                            ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        enableSuggestions: true,
                        controller: controllerProfession,
                        decoration: BoxDecoration(
                          color: CupertinoDynamicColor.resolve(
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFF0F0F0),
                                darkColor: Color(0xBF1E1E1E),
                              ),
                              context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        placeholder: 'Professione',
                        keyboardType: TextInputType.text,
                        onChanged: (val) => profession = val,
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        enableSuggestions: true,
                        controller: controllerTopic,
                        decoration: BoxDecoration(
                          color: CupertinoDynamicColor.resolve(
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFF0F0F0),
                                darkColor: Color(0xBF1E1E1E),
                              ),
                              context),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        placeholder: 'Argomento-Talk',
                        keyboardType: TextInputType.text,
                        onChanged: (val) => topic = val,
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        enableSuggestions: true,
                        controller: controllerRatePublicSpeaking,
                        decoration: BoxDecoration(
                          color: CupertinoDynamicColor.resolve(
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFF0F0F0),
                                darkColor: Color(0xBF1E1E1E),
                              ),
                              context),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        placeholder: 'Valuta public speaking da 1 a 5',
                        keyboardType: TextInputType.text,
                        onChanged: (val) => ratePublicSpeaking = val,
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        enableSuggestions: true,
                        controller: controllerJustTEDx,
                        decoration: BoxDecoration(
                          color: CupertinoDynamicColor.resolve(
                              const CupertinoDynamicColor.withBrightness(
                                color: Color(0xFFF0F0F0),
                                darkColor: Color(0xBF1E1E1E),
                              ),
                              context),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        placeholder:
                            'Ha già fatto TEDx? SI/NO, se si quando e dove',
                        keyboardType: TextInputType.text,
                        onChanged: (val) => justTEDx = val,
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        decoration: BoxDecoration(
                          color: Style.inputTextFieldColor(context),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Style.inputTextFieldRadius)),
                        ),
                        enableSuggestions: false,
                        controller: controllerBio,
                        minLines: 2,
                        maxLines: 5,
                        placeholder: 'Una breve biografia',
                        keyboardType: TextInputType.text,
                        onChanged: (value) => bio = value,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(
                              color: CupertinoColors.destructiveRed),
                        )),
                    TextButton(
                        onPressed: () {
                          DatabaseSpeaker(
                                  licenseId: licenseId, id: widget.speaker.id)
                              .editSpeaker(
                            name: controllerName.text,
                            email:
                                TextLabels().formatEmail(controllerEmail.text),
                            link: controllerLink.text,
                            description:
                                '${TextLabels.kAddSpeaker0}${controllerProfession.text}${profession != '' ? '\n' : ''}${TextLabels.kAddSpeaker1}${controllerTopic.text}${topic != '' ? '\n' : ''}${TextLabels.kAddSpeaker2}${controllerRatePublicSpeaking.text}${ratePublicSpeaking != '' ? '\n' : ''}${TextLabels.kAddSpeaker3}${controllerJustTEDx.text}${justTEDx != '' ? '\n' : ''}${TextLabels.kAddSpeaker4}${controllerBio.text}',
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.save,
                          style: const TextStyle(
                              color: CupertinoColors.activeBlue),
                        )),
                  ],
                );
              },
            );
          },
        ),
        widget.canDelete
            ? CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  DatabaseSpeaker(licenseId: licenseId, id: widget.speaker.id)
                      .deleteSpeaker();
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.delete),
              )
            : CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              )
      ],
    );
  }
}
