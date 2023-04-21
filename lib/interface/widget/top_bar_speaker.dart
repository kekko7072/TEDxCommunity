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
        child: Center(
            child: Text(
          AppLocalizations.of(context)!.account,
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
      largeTitle: Text(AppLocalizations.of(context)!.coaching),
      trailing: GestureDetector(
        child: const Icon(CupertinoIcons.videocam_circle),
        onTap: () async {
          if (await canLaunchUrlString(speakerData.link)) {
            EasyLoading.showToast(
                AppLocalizations.of(context)!.openingLinkVideoCall,
                duration: const Duration(seconds: 2),
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.bottom);
            await launchUrlString(
              speakerData.link,
            );
          } else {
            EasyLoading.showToast('Error opening link',
                duration: const Duration(seconds: 2),
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.bottom);
          }
        },
      ),
    );
  }
}
