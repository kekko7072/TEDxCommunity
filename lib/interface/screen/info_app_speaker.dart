import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class InfoAppSpeaker extends StatefulWidget {
  final Speaker speakerData;

  const InfoAppSpeaker({super.key, required this.speakerData});

  @override
  InfoAppSpeakerState createState() => InfoAppSpeakerState();
}

class InfoAppSpeakerState extends State<InfoAppSpeaker> {
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
                const CSHeader('Account'),
                CSControl(
                  nameWidget: Text('Speaker ID'),
                  contentWidget: Text(
                    widget.speakerData.accessID!.substring(0, 5),
                    style: kSettingsDescriptionStyle,
                  ),
                ),
                CSControl(
                  nameWidget: Text('Codice'),
                  contentWidget: Text(
                    widget.speakerData.accessPassword ?? '',
                    style: kSettingsDescriptionStyle,
                  ),
                ),
                CSButton(CSButtonType.DEFAULT_CENTER, "Copia credenziali", () {
                  setState(() {
                    Clipboard.setData(ClipboardData(
                            text:
                                'Speaker ID: ${widget.speakerData.accessID!.substring(0, 5)} | Codice: ${widget.speakerData.accessPassword}'))
                        .then((_) {
                      EasyLoading.showToast('Copiato',
                          duration: const Duration(seconds: 2),
                          dismissOnTap: true,
                          toastPosition: EasyLoadingToastPosition.bottom);
                    });
                  });
                }),
                const CSHeader(''),
                CSButton(
                  CSButtonType.DESTRUCTIVE,
                  "Disconnetti",
                  () async {
                    await AuthService()
                        .signOut()
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
