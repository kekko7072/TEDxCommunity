import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AuthenticateLicense extends StatefulWidget {
  final Function(String) onLogin;
  const AuthenticateLicense({super.key, required this.onLogin});

  @override
  AuthenticateLicenseState createState() => AuthenticateLicenseState();
}

class AuthenticateLicenseState extends State<AuthenticateLicense> {
  TextEditingController licenseIdController = TextEditingController();

  ///Create account
  final AuthService _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  ///Create license
  String newLicenseId = const Uuid().v1().substring(0, 5).toUpperCase();

  @override
  void initState() {
    super.initState();
    regenerateLicenseIfExist();
  }

  void regenerateLicenseIfExist() async =>
      await DatabaseLicense(newLicenseId).checkExistence.then((alreadyExist) {
        if (alreadyExist) {
          //Set new ID
          setState(() =>
              newLicenseId = const Uuid().v1().substring(0, 5).toUpperCase());
          //Check again
          regenerateLicenseIfExist();
        }
      });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoScaffold(
      transitionBackgroundColor: Style.backgroundColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width >= 500
                            ? MediaQuery.of(context).size.width / 3
                            : 20),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextFormFieldRow(
                        decoration: BoxDecoration(
                          color: Style.inputTextFieldColor(context),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Style.inputTextFieldRadius)),
                        ),
                        controller: licenseIdController,
                        placeholder: 'LicenseId (Es. AXYA3)',
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 5,
                        onChanged: (value) {
                          // Convert the text to uppercase and update the text value
                          licenseIdController.value =
                              licenseIdController.value.copyWith(
                            text: value.toUpperCase(),
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CupertinoButton(
                    color: Style.primaryColor,
                    child: Text(AppLocalizations.of(context)!.login),
                    onPressed: () async {
                      if (licenseIdController.text.isNotEmpty &&
                          await DatabaseLicense(licenseIdController.text)
                              .checkExistence) {
                        await widget.onLogin(licenseIdController.text);
                      } else {
                        EasyLoading.showError(
                            'There is no license with this licneseId.');
                      }
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.noLicense,
                        style: TextStyle(
                          color: Style.textColor(context),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppLocalizations.of(context)!.createHere,
                            style: TextStyle(
                              color: Style.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      ///1. Create an account
                      showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text(AppLocalizations.of(context)!
                                .createAccountAdmin),
                            content: Column(
                              children: [
                                CupertinoTextFormFieldRow(
                                  decoration: BoxDecoration(
                                    color: Style.inputTextFieldColor(context),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Style.inputTextFieldRadius)),
                                  ),
                                  enableSuggestions: true,
                                  controller: nameController,
                                  textCapitalization: TextCapitalization.words,
                                  placeholder: 'Name',
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(height: 10),
                                CupertinoTextFormFieldRow(
                                  decoration: BoxDecoration(
                                    color: Style.inputTextFieldColor(context),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Style.inputTextFieldRadius)),
                                  ),
                                  enableSuggestions: true,
                                  controller: surnameController,
                                  textCapitalization: TextCapitalization.words,
                                  placeholder: 'Surname',
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(height: 10),
                                CupertinoTextFormFieldRow(
                                  decoration: BoxDecoration(
                                    color: Style.inputTextFieldColor(context),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Style.inputTextFieldRadius)),
                                  ),
                                  enableSuggestions: true,
                                  controller: emailController,
                                  placeholder: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 10),
                                CupertinoTextFormFieldRow(
                                  decoration: BoxDecoration(
                                    color: Style.inputTextFieldColor(context),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Style.inputTextFieldRadius)),
                                  ),
                                  enableSuggestions: true,
                                  controller: passwordController,
                                  placeholder: 'Password',
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: const TextStyle(
                                        color: CupertinoColors.destructiveRed),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    EasyLoading.show();
                                    await _auth
                                        .registerAdminWithEmailAndPassword(
                                            newLicenseId,
                                            nameController.text,
                                            surnameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            context)
                                        .then((adminUid) {
                                      EasyLoading.dismiss();
                                      if (adminUid.isEmpty) {
                                        showCupertinoDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title:
                                                  const Text('Error creation'),
                                              content: Text(_auth.error),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: const TextStyle(
                                                          color: CupertinoColors
                                                              .destructiveRed),
                                                    )),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        Navigator.of(context).pop();

                                        ///2. Create a license
                                        showCupertinoDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AddLicense(
                                              licenseId: newLicenseId,
                                              adminUid: adminUid,
                                              onLogin: () =>
                                                  widget.onLogin(newLicenseId),
                                            );
                                          },
                                        );
                                      }
                                    });
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.create,
                                    style: const TextStyle(
                                        color: CupertinoColors.activeBlue),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
