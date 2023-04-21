import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class InfoAppSpeaker extends StatefulWidget {
  final Speaker speakerData;

  const InfoAppSpeaker({super.key, required this.speakerData});

  @override
  InfoAppSpeakerState createState() => InfoAppSpeakerState();
}

class InfoAppSpeakerState extends State<InfoAppSpeaker> {
  ///Software version
  String version = '';

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(
        () => version = '${packageInfo.version}+${packageInfo.buildNumber}');
  }

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 4,
            horizontal: MediaQuery.of(context).size.width / 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: CupertinoPageScaffold(
            child: CupertinoSettings(
              items: <Widget>[
                CSHeader(AppLocalizations.of(context)!.account),
                CSControl(
                  nameWidget: Text(AppLocalizations.of(context)!.speakerId),
                  contentWidget: Text(
                    widget.speakerData.accessID!.substring(0, 5),
                    style: kSettingsDescriptionStyle,
                  ),
                ),
                CSControl(
                  nameWidget: Text(AppLocalizations.of(context)!.code),
                  contentWidget: Text(
                    widget.speakerData.accessPassword ?? '',
                    style: kSettingsDescriptionStyle,
                  ),
                ),
                CSButton(CSButtonType.DEFAULT_CENTER,
                    AppLocalizations.of(context)!.copyCredential, () {
                  setState(() {
                    Clipboard.setData(ClipboardData(
                            text:
                                '${AppLocalizations.of(context)!.speakerId}: ${widget.speakerData.accessID!.substring(0, 5)} | ${AppLocalizations.of(context)!.code}: ${widget.speakerData.accessPassword}'))
                        .then((_) {
                      EasyLoading.showToast(
                          AppLocalizations.of(context)!.copied,
                          duration: const Duration(seconds: 2),
                          dismissOnTap: true,
                          toastPosition: EasyLoadingToastPosition.bottom);
                    });
                  });
                }),
                CSHeader(AppLocalizations.of(context)!.software),
                CSControl(
                  nameWidget: Text(AppLocalizations.of(context)!.name),
                  contentWidget: Text(
                    AppLocalizations.of(context)!.appName,
                    style: kSettingsDescriptionStyle,
                  ),
                ),
                CSControl(
                  nameWidget: Text(AppLocalizations.of(context)!.version),
                  contentWidget: Text(
                    version,
                    style: kSettingsDescriptionStyle,
                  ),
                ),
                CSLink(
                  title: AppLocalizations.of(context)!.credits,
                  onPressed: () => showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text(AppLocalizations.of(context)!.credits),
                            content: Text(AppLocalizations.of(context)!
                                .creditsDescription),
                            actions: [
                              CupertinoDialogAction(
                                child:
                                    Text(AppLocalizations.of(context)!.close),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          )),
                  addPaddingToBorder: false,
                ),
                CSDescription(
                    '${AppLocalizations.of(context)!.developedWithLoveBy} ${AppLocalizations.of(context)!.developerName}.'),
                const CSHeader(''),
                CSButton(
                  CSButtonType.DESTRUCTIVE,
                  AppLocalizations.of(context)!.exit,
                  () async {
                    await AuthService()
                        .signOut()
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                ),
                const CSSpacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
