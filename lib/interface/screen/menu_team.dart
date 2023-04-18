import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class MenuTeam extends StatefulWidget {
  final bool isDesktop;
  final AudioHandler audioHandler;

  const MenuTeam({
    super.key,
    required this.isDesktop,
    required this.audioHandler,
  });

  @override
  MenuTeamState createState() => MenuTeamState();
}

class MenuTeamState extends State<MenuTeam> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final license = Provider.of<License?>(context);

    final userData = Provider.of<UserData?>(context);

    if (userData != null && userData.active) {
      ///DESKTOP
      late List<Widget> pages = [
        ///Lista
        CupertinoTabView(builder: (context) {
          return SafeArea(
            child: MacosScaffold(
                backgroundColor: Style.backgroundColor(context),
                toolBar: ToolBar(
                  title: Text(AppLocalizations.of(context)!.list),
                  actions: [
                    ToolBarIconButton(
                      label: AppLocalizations.of(context)!.add,
                      showLabel: false,
                      icon: const Icon(
                        CupertinoIcons.add_circled,
                        color: CupertinoColors.activeBlue,
                      ),
                      onPressed: () => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AddSpeaker(uid: userData.uid);
                        },
                      ),
                    ),
                  ],
                  leading: MacosIconButton(
                    boxConstraints: const BoxConstraints(minHeight: 50),
                    backgroundColor: MacosColors.transparent,
                    icon: const Icon(
                      CupertinoIcons.sidebar_left,
                      color: MacosColors.systemGrayColor,
                    ),
                    onPressed: () {
                      MacosWindowScope.of(context).toggleSidebar();
                    },
                  ),
                ),
                children: [
                  ContentArea(builder: (context, scrollController) {
                    return LongList(
                      showMobileTitle: false,
                      audioHandler: widget.audioHandler,
                    );
                  }),
                ]),
          );
        }),

        ///Elaborazione
        CupertinoTabView(builder: (context) {
          return SafeArea(
            child: MacosScaffold(
                backgroundColor: Style.backgroundColor(context),
                toolBar: ToolBar(
                  title: Text(AppLocalizations.of(context)!.elaboration),
                  actions: [
                    ToolBarIconButton(
                      icon: const Icon(
                        CupertinoIcons.add_circled,
                        color: CupertinoColors.activeBlue,
                      ),
                      onPressed: () => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AddSpeaker(uid: userData.uid);
                        },
                      ),
                      label: '',
                      showLabel: false,
                    ),
                  ],
                  leading: MacosIconButton(
                    boxConstraints: const BoxConstraints(minHeight: 50),
                    backgroundColor: MacosColors.transparent,
                    icon: const Icon(
                      CupertinoIcons.sidebar_left,
                      color: MacosColors.systemGrayColor,
                    ),
                    onPressed: () {
                      MacosWindowScope.of(context).toggleSidebar();
                    },
                  ),
                ),
                children: [
                  ContentArea(builder: (context, scrollController) {
                    return const Elaboration(showMobileTitle: false);
                  }),
                ]),
          );
        }),

        ///Confermati
        CupertinoTabView(builder: (context) {
          return SafeArea(
            child: MacosScaffold(
                backgroundColor: Style.backgroundColor(context),
                toolBar: ToolBar(
                  title: Text(AppLocalizations.of(context)!.confirmed),
                  actions: [
                    ToolBarIconButton(
                      icon: const Icon(
                        CupertinoIcons.add_circled,
                        color: CupertinoColors.activeBlue,
                      ),
                      onPressed: () => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AddSpeaker(uid: userData.uid);
                        },
                      ),
                      showLabel: false,
                      label: '',
                    ),
                  ],
                  leading: MacosIconButton(
                    boxConstraints: const BoxConstraints(minHeight: 50),
                    backgroundColor: MacosColors.transparent,
                    icon: const Icon(
                      CupertinoIcons.sidebar_left,
                      color: MacosColors.systemGrayColor,
                    ),
                    onPressed: () {
                      MacosWindowScope.of(context).toggleSidebar();
                    },
                  ),
                ),
                children: [
                  ContentArea(builder: (context, scrollController) {
                    return const Confirmed(
                      showMobileTitle: false,
                    );
                  }),
                ]),
          );
        }),

        ///Bags
        CupertinoTabView(builder: (context) {
          return SafeArea(
            child: MacosScaffold(
                backgroundColor: Style.backgroundColor(context),
                toolBar: ToolBar(
                  title: Text(AppLocalizations.of(context)!.bags),
                  actions: [
                    ToolBarIconButton(
                      icon: const Icon(
                        CupertinoIcons.add_circled,
                        color: CupertinoColors.activeBlue,
                      ),
                      onPressed: () => showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AddBag();
                        },
                      ),
                      showLabel: false,
                      label: '',
                    ),
                  ],
                  leading: MacosIconButton(
                    boxConstraints: const BoxConstraints(minHeight: 50),
                    backgroundColor: MacosColors.transparent,
                    icon: const Icon(
                      CupertinoIcons.sidebar_left,
                      color: MacosColors.systemGrayColor,
                    ),
                    onPressed: () {
                      MacosWindowScope.of(context).toggleSidebar();
                    },
                  ),
                ),
                children: [
                  ContentArea(builder: (context, scrollController) {
                    return const Bags(showMobileTitle: false);
                  }),
                ]),
          );
        }),
      ];

      return widget.isDesktop
          ? MacosWindow(
              sidebar: Sidebar(
                minWidth: 200,
                bottom: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.profile_circled),
                        const SizedBox(width: 8.0),
                        Text('${userData.name} ${userData.surname}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Style.textColor(context),
                            )),
                      ],
                    ),
                  ),
                  onTap: () => license != null
                      ? showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return InfoAppTeam(
                                license: license, userData: userData);
                          },
                        )
                      : {},
                ),
                builder: (context, controller) {
                  return SidebarItems(
                    currentIndex: pageIndex + 1,
                    onChanged: (index) => setState(
                      () {
                        if (index != 0) {
                          pageIndex = index - 1;
                        } else {
                          pageIndex = index;
                        }
                      },
                    ),
                    scrollController: controller,
                    items: [
                      SidebarItem(
                        label: GestureDetector(
                          onTap: () => license != null
                              ? showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return InfoAppTeam(
                                        license: license, userData: userData);
                                  },
                                )
                              : {},
                          child: Text(
                            license?.licenseName ??
                                AppLocalizations.of(context)!.appName,
                            style: const TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontSize: 15,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        selectedColor: Colors.transparent,
                      ),
                      SidebarItem(
                          leading: MacosIcon(
                            CupertinoIcons.list_bullet,
                            color: pageIndex == 0
                                ? Style.whiteColor
                                : Style.textColor(context),
                          ),
                          label: Text(AppLocalizations.of(context)!.list),
                          semanticLabel: AppLocalizations.of(context)!.list),
                      SidebarItem(
                        leading: MacosIcon(
                          CupertinoIcons.rocket,
                          color: pageIndex == 1
                              ? Style.whiteColor
                              : Style.textColor(context),
                        ),
                        label: Text(AppLocalizations.of(context)!.elaboration),
                        semanticLabel:
                            AppLocalizations.of(context)!.elaboration,
                      ),
                      SidebarItem(
                        leading: MacosIcon(
                          CupertinoIcons.checkmark_rectangle,
                          color: pageIndex == 2
                              ? Style.whiteColor
                              : Style.textColor(context),
                        ),
                        label: Text(AppLocalizations.of(context)!.confirmed),
                        semanticLabel: AppLocalizations.of(context)!.confirmed,
                      ),
                      if (license?.bags != null && license!.bags) ...[
                        SidebarItem(
                          leading: MacosIcon(
                            CupertinoIcons.bag,
                            color: pageIndex == 3
                                ? Style.whiteColor
                                : Style.textColor(context),
                          ),
                          label: Text(AppLocalizations.of(context)!.bags),
                          semanticLabel: AppLocalizations.of(context)!.bags,
                        ),
                      ],
                    ],
                  );
                },
              ),
              child: IndexedStack(
                index: pageIndex,
                children: pages,
              ),
            )
          : CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                inactiveColor: Style.textMenuColor(context),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.list_bullet),
                      label: AppLocalizations.of(context)!.list,
                      tooltip: AppLocalizations.of(context)!.list),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.rocket),
                    label: AppLocalizations.of(context)!.elaboration,
                    tooltip: AppLocalizations.of(context)!.elaboration,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.checkmark_rectangle),
                    label: AppLocalizations.of(context)!.confirmed,
                    tooltip: AppLocalizations.of(context)!.confirmed,
                  ),
                  if (license?.bags != null && license!.bags) ...[
                    BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.bag),
                      label: AppLocalizations.of(context)!.bags,
                      tooltip: AppLocalizations.of(context)!.bags,
                    ),
                  ],
                ],
              ),
              tabBuilder: (context, index) {
                late CupertinoTabView returnValue;

                switch (index) {
                  case 0:
                    returnValue = CupertinoTabView(builder: (context) {
                      return CupertinoPageScaffold(
                        child: LongList(
                          showMobileTitle: true,
                          audioHandler: widget.audioHandler,
                        ),
                      );
                    });
                    break;
                  case 1:
                    returnValue = CupertinoTabView(builder: (context) {
                      return const CupertinoPageScaffold(
                        child: Elaboration(showMobileTitle: true),
                      );
                    });
                    break;
                  case 2:
                    returnValue = CupertinoTabView(builder: (context) {
                      return const CupertinoPageScaffold(
                        child: Confirmed(showMobileTitle: true),
                      );
                    });
                    break;
                  case 3:
                    returnValue = CupertinoTabView(builder: (context) {
                      return const CupertinoPageScaffold(
                        child: Bags(showMobileTitle: true),
                      );
                    });
                    break;
                }

                return returnValue;
              },
            );
    } else {
      return Scaffold(
        backgroundColor: Style.backgroundColor(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.yourAccountIsNotActive,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                StreamBuilder<UserData?>(
                    stream: DatabaseUser(
                      licenseId: license?.id ?? 'NO_ID',
                      uid: license?.adminUid ?? 'NO_UID',
                    ).userData,
                    builder: (context, snapshot) {
                      return Text(
                        '${AppLocalizations.of(context)!.yourLicenseeIs} ${snapshot.data?.name} ${snapshot.data?.surname}. ${AppLocalizations.of(context)!.askToActivateAccount}',
                        style: TextStyle(color: Style.textColor(context)),
                      );
                    }),
                const SizedBox(height: 40),
                CupertinoButton.filled(
                    child: Text(AppLocalizations.of(context)!.logout),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove(kLicenseIdKey);
                      await AuthService().signOut();
                    })
              ],
            ),
          ),
        ),
      );
    }
  }
}
