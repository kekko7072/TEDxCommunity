import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/interface/screen/authenticate_license.dart';
import 'package:tedxcommunity/services/imports.dart';

class App extends StatefulWidget {
  final AudioHandler audioHandler;
  const App(this.audioHandler, {super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String licenseId = "";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser?>(context);

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
        return Authenticate(
          licenseId: licenseId,
          onLicenseRemoved: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove(kLicenseIdKey);
            setState(() => licenseId = "");
          },
        );
      } else {
        return StreamBuilder<UserData>(
            stream: DatabaseUser(licenseId: licenseId, uid: user?.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MultiProvider(
                  providers: [
                    StreamProvider<UserData?>.value(
                      value: DatabaseUser(licenseId: licenseId, uid: user?.uid)
                          .userData,
                      initialData: null,
                    ),
                    StreamProvider<List<Speaker>?>.value(
                      value: DatabaseSpeaker(licenseId: licenseId).allQuery,
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
                            title: TextLabels.kAppName,
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
                            builder: EasyLoading.init(),
                          )
                        : CupertinoApp(
                            debugShowCheckedModeBanner: false,
                            title: TextLabels.kAppName,
                            theme: CupertinoThemeData(
                              primaryColor: Style.primaryColor,
                              barBackgroundColor: Style.menuColor(context),
                              scaffoldBackgroundColor:
                                  Style.backgroundColor(context),
                            ),
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
                  stream: DatabaseSpeaker(licenseId: licenseId, id: user?.uid)
                      .speakerData,
                  builder: (context, snapshot) {
                    {
                      if (snapshot.hasData) {
                        Speaker speakerData = snapshot.data!;

                        return Scaffold(
                          backgroundColor: Style.backgroundColor(context),
                          body: MediaQuery.of(context).size.width >
                                  kConstantsResizeWidthValue
                              ? MacosApp(
                                  title: TextLabels.kAppName,
                                  theme: MacosThemeData.light(),
                                  darkTheme: MacosThemeData.dark(),
                                  debugShowCheckedModeBanner: false,
                                  home: MenuSpeaker(
                                    speakerData: speakerData,
                                    isDesktop: true,
                                  ),
                                  builder: EasyLoading.init(),
                                )
                              : CupertinoApp(
                                  debugShowCheckedModeBanner: false,
                                  title: TextLabels.kAppName,
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
                            setState(() => licenseId = "");
                          },
                        );
                      }
                    }
                  },
                );
              }
            });
      }
    }
  }
}
