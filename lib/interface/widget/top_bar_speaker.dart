import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class TopBarSpeaker extends StatelessWidget {
  final Speaker speakerData;
  final String title;

  const TopBarSpeaker(
      {super.key, required this.speakerData, required this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      leading: GestureDetector(
        child: const Center(
            child: Text(
          'Account',
          style: kPageSubtitleStyle,
        )),
        onTap: () {
          showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return InfoAppSpeaker(speakerData: speakerData);
            },
          );
        },
      ),
      largeTitle: Text('Coaching'),
      trailing: GestureDetector(
        child: Icon(CupertinoIcons.videocam_circle),
        onTap: () async {
          if (await canLaunchUrlString(speakerData.link)) {
            EasyLoading.showToast('Apro videochiamata',
                duration: Duration(seconds: 2),
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.bottom);
            await launchUrlString(
              speakerData.link,
            );
          } else {
            EasyLoading.showToast('Errore link non valido',
                duration: Duration(seconds: 2),
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.bottom);
          }
        },
      ),
    );
  }
}
