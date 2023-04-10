import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class TopBarTeam extends StatelessWidget {
  final License license;
  final UserData userData;
  final String title;
  final Widget? widget;

  const TopBarTeam(
      {super.key,
      required this.license,
      required this.userData,
      required this.title,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      leading: GestureDetector(
        child: Center(
          child: Text(
            license.licenseName,
            style: kPageSubtitleStyle,
          ),
        ),
        onTap: () {
          showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return InfoAppTeam(
                license: license,
                userData: userData,
              );
            },
          );
        },
      ),
      largeTitle: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget != null) ...[
            widget!,
            const SizedBox(width: 10),
          ],
          GestureDetector(
            child: const Icon(CupertinoIcons.add_circled),
            onTap: () {
              if (title == TextLabels.kMenuBags) {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AddBag();
                  },
                );
              } else {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AddSpeaker(uid: userData.uid);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
