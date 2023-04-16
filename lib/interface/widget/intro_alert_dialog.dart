import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class IntroAlertDialog extends StatelessWidget {
  const IntroAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context)!.welcomeToTEDxCommunity),
      content: Column(
        children: [
          Text(AppLocalizations.of(context)!.whatIsTEDxCommunity),
          const SizedBox(height: 16.0),
          Text(AppLocalizations.of(context)!.learnMoreAboutTEDxCommunity),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SelectableText(
              kGitHubReadmeLink,
              style: const TextStyle(color: CupertinoColors.link),
              onTap: () => launchUrlString(kGitHubReadmeLink),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
              '${AppLocalizations.of(context)!.developedWithLoveBy} ${AppLocalizations.of(context)!.developerName}')
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context)!.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
