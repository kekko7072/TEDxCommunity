import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class PasswordRecoveryDialog extends StatelessWidget {
  const PasswordRecoveryDialog({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context)!.recoverPassword),
      content: Column(
        children: [
          Text(AppLocalizations.of(context)!.sendEmailToRecoverPassword),
          Text('${AppLocalizations.of(context)!.email}: $email',
              style: const TextStyle(fontWeight: FontWeight.w600))
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: CupertinoColors.destructiveRed),
            )),
        TextButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: email)
                  .whenComplete(() {
                EasyLoading.showSuccess(
                    'Password recovery email sent to $email');
                Navigator.of(context).pop();
              });
            } catch (e) {
              EasyLoading.showError(
                  'Failed to recover password: ${e.toString()}');
            }
          },
          child: Text(
            AppLocalizations.of(context)!.send,
            style: const TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
      ],
    );
  }
}
