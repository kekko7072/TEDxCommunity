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
  late String email;
  late String password;
  late String name;
  late String surname;

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
                          license?.licenseName ?? TextLabels.kAppName,
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
                          license?.licenseName ?? TextLabels.kAppName,
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
                            false: const Text(
                              'Speaker',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                      onChanged: (value) =>
                                          setState(() => email = value),
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
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },
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
                                        onChanged: (value) => setState(() => email =
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
                                      placeholder: 'Codice',
                                      maxLength: 8,
                                      onChanged: (value) =>
                                          setState(() => password = value),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 15),
                        CupertinoButton(
                          color: Style.primaryColor,
                          child: const Text('Accedi'),
                          onPressed: () async {
                            setState(() => loading = true);
                            if (isTeam) {
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() => loading = false);
                                showCupertinoDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        'Errore login',
                                      ),
                                      content: Text(_auth.error),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Chiudi',
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .destructiveRed),
                                            )),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() => loading = false);
                                showCupertinoDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        'Errore login',
                                      ),
                                      content: Text(_auth.error),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Chiudi',
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .destructiveRed),
                                            )),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: widget.onLicenseRemoved,
                          child: const Text(
                            'Rimuovi la licenza attuale.',
                            style: TextStyle(color: Colors.grey),
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
                                              text: 'Non hai un account? ',
                                              style: TextStyle(
                                                color: Style.textColor(context),
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Crea qui.',
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
                                                        placeholder: 'Nome',
                                                        keyboardType:
                                                            TextInputType.name,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            name = value;
                                                          });
                                                        },
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
                                                        placeholder: 'Cognome',
                                                        keyboardType:
                                                            TextInputType.name,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            surname = value;
                                                          });
                                                        },
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
                                                        onChanged: (value) {
                                                          setState(() {
                                                            email = value;
                                                          });
                                                        },
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
                                                        onChanged: (value) {
                                                          setState(() {
                                                            password = value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Annulla',
                                                          style: TextStyle(
                                                              color: CupertinoColors
                                                                  .destructiveRed),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() =>
                                                              loading = true);
                                                          dynamic result = await _auth
                                                              .registerWithEmailAndPassword(
                                                                  widget
                                                                      .licenseId,
                                                                  name,
                                                                  surname,
                                                                  email,
                                                                  password,
                                                                  context);
                                                          if (result == null) {
                                                            setState(() =>
                                                                loading =
                                                                    false);
                                                            showCupertinoDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (context) {
                                                                return CupertinoAlertDialog(
                                                                  title: Text(
                                                                    'Errore creazione',
                                                                  ),
                                                                  content: Text(
                                                                      _auth
                                                                          .error),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Chiudi',
                                                                          style:
                                                                              TextStyle(color: CupertinoColors.destructiveRed),
                                                                        )),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          'Crea',
                                                          style: TextStyle(
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
