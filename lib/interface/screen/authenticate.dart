import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Authenticate extends StatefulWidget {
  final String licenseId;
  final Function() onLicenseRemoved;
  const Authenticate(
      {super.key, required this.licenseId, required this.onLicenseRemoved});

  @override
  AuthenticateState createState() => AuthenticateState();
}

class AuthenticateState extends State<Authenticate> {
  late bool isTeam = true;
  late bool loading = false;
  final AuthService _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  String emailSpeaker = "";

  @override
  Widget build(BuildContext context) {
    final license = Provider.of<License?>(context);

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoScaffold(
      transitionBackgroundColor: Style.backgroundColor(context),
      body: SafeArea(
        child: loading
            ? Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          license?.licenseName ??
                              AppLocalizations.of(context)!.appName,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navLargeTitleTextStyle,
                        ),
                        const SizedBox(height: 15),
                        const CupertinoActivityIndicator(),
                      ],
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          license?.licenseName ??
                              AppLocalizations.of(context)!.appName,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navLargeTitleTextStyle,
                        ),
                        const SizedBox(height: 20),
                        CupertinoSegmentedControl(
                          borderColor: Style.primaryColor,
                          selectedColor: Style.primaryColor,
                          unselectedColor: Style.backgroundColor(context),
                          children: {
                            true: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'TEDx Team',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            false: Text(
                              AppLocalizations.of(context)!.speaker,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          },
                          groupValue: isTeam,
                          onValueChanged: (bool value) {
                            setState(() {
                              isTeam = value;
                              emailController.clear();
                              passwordController.clear();
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        isTeam
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context)
                                                .size
                                                .width >=
                                            500
                                        ? MediaQuery.of(context).size.width / 3
                                        : 20),
                                child: Column(
                                  children: [
                                    CupertinoTextFormFieldRow(
                                      decoration: BoxDecoration(
                                        color:
                                            Style.inputTextFieldColor(context),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Style.inputTextFieldRadius)),
                                      ),
                                      controller: emailController,
                                      placeholder: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    CupertinoTextFormFieldRow(
                                      decoration: BoxDecoration(
                                        color:
                                            Style.inputTextFieldColor(context),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Style.inputTextFieldRadius)),
                                      ),
                                      controller: passwordController,
                                      placeholder: 'Password',
                                      obscureText: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context)
                                                .size
                                                .width >=
                                            500
                                        ? MediaQuery.of(context).size.width / 3
                                        : 20),
                                child: Column(
                                  children: [
                                    CupertinoTextFormFieldRow(
                                        decoration: BoxDecoration(
                                          color: Style.inputTextFieldColor(
                                              context),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Style.inputTextFieldRadius)),
                                        ),
                                        controller: emailController,
                                        placeholder: 'Speaker ID',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        maxLength: 5,
                                        onChanged: (value) => setState(() =>
                                            emailSpeaker =
                                                '$value@$kTEDxCommunityCustomSpeakerDomain')),
                                    CupertinoTextFormFieldRow(
                                      decoration: BoxDecoration(
                                        color:
                                            Style.inputTextFieldColor(context),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Style.inputTextFieldRadius)),
                                      ),
                                      controller: passwordController,
                                      enableSuggestions: true,
                                      obscureText: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      placeholder: 'Code',
                                      maxLength: 8,
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 15),
                        CupertinoButton(
                          color: Style.primaryColor,
                          child: Text(AppLocalizations.of(context)!.login),
                          onPressed: () async {
                            setState(() => loading = true);
                            if (isTeam) {
                              await _auth
                                  .signInWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text)
                                  .then((result) {
                                if (result == null) {
                                  setState(() => loading = false);
                                  showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Error login'),
                                        content: Text(_auth.error),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                                style: const TextStyle(
                                                    color: CupertinoColors
                                                        .destructiveRed),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            } else {
                              await _auth
                                  .signInWithEmailAndPassword(
                                      emailSpeaker, passwordController.text)
                                  .then((result) {
                                if (result == null) {
                                  setState(() => loading = false);
                                  showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('Error login'),
                                        content: Text(_auth.error),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                                style: const TextStyle(
                                                    color: CupertinoColors
                                                        .destructiveRed),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: widget.onLicenseRemoved,
                          child: Text(
                            AppLocalizations.of(context)!.removeCurrentLicense,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (isTeam) ...[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<License>(
                              stream: DatabaseLicense(widget.licenseId).stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  License appSettings = snapshot.data!;
                                  return appSettings.registration
                                      ? CupertinoButton(
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .noAccount,
                                              style: TextStyle(
                                                color: Style.textColor(context),
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .createHere,
                                                  style: TextStyle(
                                                    color: Style.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: const Text(
                                                      'Speaker Team'),
                                                  content: Column(
                                                    children: [
                                                      CupertinoTextFormFieldRow(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Style
                                                              .inputTextFieldColor(
                                                                  context),
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                                  .circular(Style
                                                                      .inputTextFieldRadius)),
                                                        ),
                                                        enableSuggestions: true,
                                                        controller:
                                                            nameController,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        placeholder: 'Name',
                                                        keyboardType:
                                                            TextInputType.name,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      CupertinoTextFormFieldRow(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Style
                                                              .inputTextFieldColor(
                                                                  context),
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                                  .circular(Style
                                                                      .inputTextFieldRadius)),
                                                        ),
                                                        enableSuggestions: true,
                                                        controller:
                                                            surnameController,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        placeholder: 'Surname',
                                                        keyboardType:
                                                            TextInputType.name,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      CupertinoTextFormFieldRow(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Style
                                                              .inputTextFieldColor(
                                                                  context),
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                                  .circular(Style
                                                                      .inputTextFieldRadius)),
                                                        ),
                                                        enableSuggestions: true,
                                                        controller:
                                                            emailController,
                                                        placeholder: 'Email',
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      CupertinoTextFormFieldRow(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Style
                                                              .inputTextFieldColor(
                                                                  context),
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                                  .circular(Style
                                                                      .inputTextFieldRadius)),
                                                        ),
                                                        enableSuggestions: true,
                                                        controller:
                                                            passwordController,
                                                        placeholder: 'Password',
                                                        obscureText: true,
                                                        keyboardType:
                                                            TextInputType
                                                                .visiblePassword,
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .cancel,
                                                          style: const TextStyle(
                                                              color: CupertinoColors
                                                                  .destructiveRed),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() =>
                                                              loading = true);
                                                          await _auth
                                                              .registerWithEmailAndPassword(
                                                                  widget
                                                                      .licenseId,
                                                                  nameController
                                                                      .text,
                                                                  surnameController
                                                                      .text,
                                                                  emailController
                                                                      .text,
                                                                  passwordController
                                                                      .text,
                                                                  context)
                                                              .then((result) {
                                                            if (result ==
                                                                null) {
                                                              setState(() =>
                                                                  loading =
                                                                      false);
                                                              showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (context) {
                                                                  return CupertinoAlertDialog(
                                                                    title: const Text(
                                                                        'Error creation'),
                                                                    content: Text(
                                                                        _auth
                                                                            .error),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppLocalizations.of(context)!.cancel,
                                                                            style:
                                                                                const TextStyle(color: CupertinoColors.destructiveRed),
                                                                          )),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .create,
                                                          style: const TextStyle(
                                                              color: CupertinoColors
                                                                  .activeBlue),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : Container();
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    )
                  ]
                ],
              ),
      ),
    );
  }
}
