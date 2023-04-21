import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/interface/screen/authenticate_license.dart';
import 'package:tedxcommunity/interface/widget/intro_alert_dialog.dart';
import 'package:tedxcommunity/services/imports.dart';

class App extends StatefulWidget {
  final AudioHandler audioHandler;
  const App(this.audioHandler, {super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late SharedPreferences _prefs;
  bool initializedLocalSettings = false;

  Future<void> get _initPrefs async {
    _prefs = await SharedPreferences.getInstance();
    setState(() => initializedLocalSettings = true);

    await Future.delayed(const Duration(seconds: 1));
    bool showIntroAlertDialog =
        _prefs.getBool(kShowIntroAlertDialogKey) ?? true;

    if (showIntroAlertDialog) {
      await _prefs.setBool(kShowIntroAlertDialogKey, false).then((value) =>
          showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => const IntroAlertDialog()));
    }
  }

  @override
  void initState() {
    super.initState();
    _initPrefs;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser?>(context);

    return StreamBuilder<String>(
        initialData: initializedLocalSettings
            ? _prefs.getString(kLicenseIdKey) ?? ''
            : '',
        stream: Stream.periodic(
            const Duration(milliseconds: 500),
            (_) => initializedLocalSettings
                ? _prefs.getString(kLicenseIdKey) ?? ''
                : ''),
        builder: (context, snap) {
          String licenseId = snap.data ?? '';
          if (licenseId.isEmpty) {
            return AuthenticateLicense(
              onLogin: (id) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(kLicenseIdKey, id);
                setState(() => licenseId = id);
              },
            );
          } else {
            if (user?.uid == null) {
              return StreamProvider<License?>.value(
                  value: DatabaseLicense(licenseId).stream,
                  initialData: null,
                  child: Authenticate(
                    licenseId: licenseId,
                    onLicenseRemoved: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove(kLicenseIdKey);
                      setState(() => licenseId = '');
                    },
                  ));
            } else {
              return StreamBuilder<UserData>(
                  stream: DatabaseUser(licenseId: licenseId, uid: user?.uid)
                      .userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MultiProvider(
                        providers: [
                          StreamProvider<UserData?>.value(
                            value: DatabaseUser(
                                    licenseId: licenseId, uid: user?.uid)
                                .userData,
                            initialData: null,
                          ),
                          StreamProvider<List<Speaker>?>.value(
                            value:
                                DatabaseSpeaker(licenseId: licenseId).allQuery,
                            initialData: null,
                          ),
                          StreamProvider<License?>.value(
                            value: DatabaseLicense(licenseId).stream,
                            initialData: null,
                          ),
                        ],
                        child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Style.menuColor(context),
                          body: MediaQuery.of(context).size.width >
                                  kConstantsResizeWidthValue
                              ? MacosApp(
                                  title: AppLocalizations.of(context)!.appName,
                                  theme: MacosThemeData(
                                    primaryColor: Style.primaryColor,
                                    brightness: Brightness.light,
                                    visualDensity: VisualDensity.comfortable,
                                  ),
                                  darkTheme: MacosThemeData(
                                    primaryColor: Style.primaryColor,
                                    brightness: Brightness.dark,
                                    visualDensity: VisualDensity.comfortable,
                                  ),
                                  debugShowCheckedModeBanner: false,
                                  home: MenuTeam(
                                    isDesktop: true,
                                    audioHandler: widget.audioHandler,
                                  ),
                                  localizationsDelegates: const [
                                    AppLocalizations.delegate,
                                    GlobalMaterialLocalizations.delegate,
                                    GlobalWidgetsLocalizations.delegate,
                                    GlobalCupertinoLocalizations.delegate,
                                  ],
                                  supportedLocales:
                                      AppLocalizations.supportedLocales,
                                  builder: EasyLoading.init(),
                                )
                              : CupertinoApp(
                                  debugShowCheckedModeBanner: false,
                                  title: AppLocalizations.of(context)!.appName,
                                  theme: CupertinoThemeData(
                                    primaryColor: Style.primaryColor,
                                    barBackgroundColor:
                                        Style.menuColor(context),
                                    scaffoldBackgroundColor:
                                        Style.backgroundColor(context),
                                  ),
                                  localizationsDelegates: const [
                                    AppLocalizations.delegate,
                                    GlobalMaterialLocalizations.delegate,
                                    GlobalWidgetsLocalizations.delegate,
                                    GlobalCupertinoLocalizations.delegate,
                                  ],
                                  supportedLocales:
                                      AppLocalizations.supportedLocales,
                                  home: MenuTeam(
                                    isDesktop: false,
                                    audioHandler: widget.audioHandler,
                                  ),
                                  builder: EasyLoading.init(),
                                ),
                        ),
                      );
                    } else {
                      return StreamBuilder<Speaker>(
                          stream: DatabaseSpeaker(
                                  licenseId: licenseId, id: user?.uid)
                              .speakerData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Speaker speakerData = snapshot.data!;

                              return Scaffold(
                                backgroundColor: Style.backgroundColor(context),
                                body: MediaQuery.of(context).size.width >
                                        kConstantsResizeWidthValue
                                    ? MacosApp(
                                        title: AppLocalizations.of(context)!
                                            .appName,
                                        theme: MacosThemeData.light(),
                                        darkTheme: MacosThemeData.dark(),
                                        debugShowCheckedModeBanner: false,
                                        home: MenuSpeaker(
                                          speakerData: speakerData,
                                          isDesktop: true,
                                        ),
                                        localizationsDelegates: const [
                                          AppLocalizations.delegate,
                                          GlobalMaterialLocalizations.delegate,
                                          GlobalWidgetsLocalizations.delegate,
                                          GlobalCupertinoLocalizations.delegate,
                                        ],
                                        supportedLocales:
                                            AppLocalizations.supportedLocales,
                                        builder: EasyLoading.init(),
                                      )
                                    : CupertinoApp(
                                        debugShowCheckedModeBanner: false,
                                        title: AppLocalizations.of(context)!
                                            .appName,
                                        theme: CupertinoThemeData(
                                          primaryColor: Style.primaryColor,
                                          barBackgroundColor:
                                              Style.menuColor(context),
                                          scaffoldBackgroundColor:
                                              Style.backgroundColor(context),
                                        ),
                                        home: MenuSpeaker(
                                          speakerData: speakerData,
                                          isDesktop: false,
                                        ),
                                        localizationsDelegates: const [
                                          AppLocalizations.delegate,
                                          GlobalMaterialLocalizations.delegate,
                                          GlobalWidgetsLocalizations.delegate,
                                          GlobalCupertinoLocalizations.delegate,
                                        ],
                                        supportedLocales:
                                            AppLocalizations.supportedLocales,
                                        builder: EasyLoading.init(),
                                      ),
                              );
                            } else {
                              return Authenticate(
                                licenseId: licenseId,
                                onLicenseRemoved: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove(kLicenseIdKey);
                                  setState(() => licenseId = '');
                                },
                              );
                            }
                          });
                    }
                  });
            }
          }
        });
  }
}
