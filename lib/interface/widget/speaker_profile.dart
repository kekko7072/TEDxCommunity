import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class SpeakerProfile extends StatefulWidget {
  const SpeakerProfile(this.speaker, {super.key});

  final Speaker speaker;

  @override
  SpeakerProfileState createState() => SpeakerProfileState();
}

class SpeakerProfileState extends State<SpeakerProfile> {
  bool copied = false;
  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrl(String url) async {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(
          url,
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    return CupertinoAlertDialog(
      title: Text(
        widget.speaker.name,
      ),
      content: widget.speaker.progress == Progress.confirmed
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<UserData>(
                    stream: DatabaseUser(
                            licenseId: licenseId,
                            uid: widget.speaker.uidCreator)
                        .userData,
                    builder: (BuildContext context,
                        AsyncSnapshot<UserData> snapshot) {
                      if (snapshot.hasData) {
                        UserData userData = snapshot.data!;
                        return Text('${userData.name} ${userData.surname}');
                      } else {
                        return Container();
                      }
                    }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.speakerId}: ${widget.speaker.accessID!.substring(0, 5)}',
                            style: kSpeakerTitleStyle.copyWith(
                                color: CupertinoDynamicColor.resolve(
                                    const CupertinoDynamicColor.withBrightness(
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                      darkColor: kColorWhite,
                                      //darkColor: Color(0xBF1E1E1E),
                                    ),
                                    context)),
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.code}: ${widget.speaker.accessPassword}',
                            style: kSpeakerTitleStyle.copyWith(
                                color: CupertinoDynamicColor.resolve(
                                    const CupertinoDynamicColor.withBrightness(
                                      color: kColorBlack,
                                      darkColor: kColorWhite,
                                      //darkColor: Color(0xBF1E1E1E),
                                    ),
                                    context)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CupertinoButton(
                          child: Icon(copied
                              ? CupertinoIcons.doc_on_doc_fill
                              : CupertinoIcons.doc_on_doc),
                          onPressed: () {
                            setState(() {
                              copied = true;
                            });
                            Clipboard.setData(ClipboardData(
                                    text:
                                        '${AppLocalizations.of(context)!.speakerId}: ${widget.speaker.accessID!.substring(0, 5)} | ${AppLocalizations.of(context)!.code}: ${widget.speaker.accessPassword}'))
                                .then((_) {
                              EasyLoading.showToast(
                                  AppLocalizations.of(context)!.copied,
                                  duration: const Duration(seconds: 2),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.linkVideoCall,
                            style: kSpeakerTitleStyle.copyWith(
                                color: CupertinoDynamicColor.resolve(
                                    const CupertinoDynamicColor.withBrightness(
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                      darkColor: kColorWhite,
                                      //darkColor: Color(0xBF1E1E1E),
                                    ),
                                    context)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CupertinoButton(
                          child: const Icon(CupertinoIcons.videocam_circle),
                          onPressed: () async {
                            if (await canLaunchUrlString(widget.speaker.link)) {
                              EasyLoading.showToast(
                                  AppLocalizations.of(context)!
                                      .openingLinkVideoCall,
                                  duration: const Duration(seconds: 2),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                              await launchUrlString(
                                widget.speaker.link,
                              );
                            } else {
                              EasyLoading.showToast('Error',
                                  duration: const Duration(seconds: 2),
                                  dismissOnTap: true,
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            }
                          }),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                Text(
                  widget.speaker.email,
                ),
                const SizedBox(height: 10),
                StreamBuilder<UserData>(
                    stream: DatabaseUser(
                            licenseId: licenseId,
                            uid: widget.speaker.uidCreator)
                        .userData,
                    builder: (BuildContext context,
                        AsyncSnapshot<UserData> snapshot) {
                      if (snapshot.hasData) {
                        UserData userData = snapshot.data!;
                        return Text('${userData.name} ${userData.surname}');
                      } else {
                        return Container();
                      }
                    }),
                const SizedBox(height: 10),
                CupertinoButton(
                  child: Text(
                    widget.speaker.link,
                  ),
                  onPressed: () => setState(() {
                    launchUrl(widget.speaker.link);
                  }),
                ),
                const SizedBox(height: 10),
                Text(widget.speaker.description),
              ],
            ),
    );
  }
}
