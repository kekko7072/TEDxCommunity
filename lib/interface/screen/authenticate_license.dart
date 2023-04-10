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
  String licenseId = const Uuid().v1().substring(0, 5).toUpperCase();
  TextEditingController licenseNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    regenerateLicenseIfExist();
  }

  void regenerateLicenseIfExist() async =>
      await DatabaseLicense(licenseId).checkExistence.then((alreadyExist) {
        if (alreadyExist) {
          //Set new ID
          setState(() =>
              licenseId = const Uuid().v1().substring(0, 5).toUpperCase());
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
                    TextLabels.kAppName,
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
                        placeholder: 'LicenseId (Es. AXY-A32A)',
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CupertinoButton(
                    color: Style.primaryColor,
                    child: const Text('Accedi'),
                    onPressed: () async {
                      await widget.onLogin(licenseIdController.text);
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
                        text: 'Non hai una licenza? ',
                        style: TextStyle(
                          color: Style.textColor(context),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Richiedi qui.',
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
                            title: const Text('Crea account admin'),
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
                                  placeholder: 'Nome',
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
                                  placeholder: 'Cognome',
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
                                  child: const Text(
                                    'Annulla',
                                    style: TextStyle(
                                        color: CupertinoColors.destructiveRed),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    EasyLoading.show();
                                    await _auth
                                        .registerAdminWithEmailAndPassword(
                                            licenseId,
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
                                              title: const Text(
                                                  'Errore creazione'),
                                              content: Text(_auth.error),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text(
                                                      'Chiudi',
                                                      style: TextStyle(
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
                                            return CupertinoAlertDialog(
                                              title: const Text('Crea licenza'),
                                              content: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                            'LicenseId: $licenseId'),
                                                      ),
                                                      Expanded(
                                                          flex: 1,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              CupertinoIcons
                                                                  .doc_on_clipboard,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              EasyLoading
                                                                  .showToast(
                                                                      'Copiato');
                                                              Clipboard.setData(
                                                                  ClipboardData(
                                                                      text:
                                                                          licenseId));
                                                            },
                                                          ))
                                                    ],
                                                  ),
                                                  CupertinoTextFormFieldRow(
                                                    decoration: BoxDecoration(
                                                      color: Style
                                                          .inputTextFieldColor(
                                                              context),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(Style
                                                              .inputTextFieldRadius)),
                                                    ),
                                                    enableSuggestions: true,
                                                    controller:
                                                        licenseNameController,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    placeholder:
                                                        'Nome (es. TEDxCortina)',
                                                    keyboardType:
                                                        TextInputType.name,
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () async {
                                                      EasyLoading.show();
                                                      await DatabaseLicense(
                                                              licenseId)
                                                          .create(
                                                              adminUid:
                                                                  adminUid,
                                                              licenseName:
                                                                  licenseNameController
                                                                      .text)
                                                          .whenComplete(() {
                                                        EasyLoading.dismiss();

                                                        widget
                                                            .onLogin(licenseId);
                                                        Navigator.of(context)
                                                            .pop();
                                                        EasyLoading.showSuccess(
                                                            'Licenza attivata con successo!');
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Attiva',
                                                      style: TextStyle(
                                                          color: CupertinoColors
                                                              .activeBlue),
                                                    )),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    });
                                  },
                                  child: const Text(
                                    'Crea',
                                    style: TextStyle(
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
