import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class MenuTeam extends StatefulWidget {
  final bool isDesktop;
  final AudioHandler audioHandler;

  MenuTeam({
    required this.isDesktop,
    required this.audioHandler,
  });

  @override
  _MenuTeamState createState() => _MenuTeamState();
}

class _MenuTeamState extends State<MenuTeam> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final license = Provider.of<License?>(context);

    final userData = Provider.of<UserData?>(context);

    ///DESKTOP
    late List<Widget> pages = [
      ///Lista
      CupertinoTabView(builder: (context) {
        return SafeArea(
          child: MacosScaffold(
              backgroundColor: Style.backgroundColor(context),
              toolBar: ToolBar(
                title: Text(TextLabels.kMenuList),
                actions: [
                  ToolBarIconButton(
                    label: 'Add',
                    showLabel: false,
                    icon: const Icon(
                      CupertinoIcons.add_circled,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: () => showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AddSpeaker(uid: userData?.uid ?? 'unk');
                      },
                    ),
                  ),
                ],
                leading: MacosIconButton(
                  boxConstraints: BoxConstraints(minHeight: 50),
                  backgroundColor: MacosColors.transparent,
                  icon: Icon(
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
                title: Text(TextLabels.kMenuElaboration),
                actions: [
                  ToolBarIconButton(
                    icon: Icon(
                      CupertinoIcons.add_circled,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: () => showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AddSpeaker(uid: userData?.uid ?? 'unk');
                      },
                    ),
                    label: '',
                    showLabel: false,
                  ),
                ],
                leading: MacosIconButton(
                  boxConstraints: BoxConstraints(minHeight: 50),
                  backgroundColor: MacosColors.transparent,
                  icon: Icon(
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
                  return Elaboration(
                    showMobileTitle: false,
                  );
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
                title: Text(TextLabels.kMenuConfirmed),
                actions: [
                  ToolBarIconButton(
                    icon: Icon(
                      CupertinoIcons.add_circled,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: () => showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AddSpeaker(uid: userData?.uid ?? 'unk');
                      },
                    ),
                    showLabel: false,
                    label: '',
                  ),
                ],
                leading: MacosIconButton(
                  boxConstraints: BoxConstraints(minHeight: 50),
                  backgroundColor: MacosColors.transparent,
                  icon: Icon(
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
                  return Confirmed(
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
                title: Text(TextLabels.kMenuBags),
                actions: [
                  ToolBarIconButton(
                    icon: Icon(
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
                  boxConstraints: BoxConstraints(minHeight: 50),
                  backgroundColor: MacosColors.transparent,
                  icon: Icon(
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
                  return Bags(
                    showMobileTitle: false,
                  );
                }),
              ]),
        );
      }),
    ];

    return widget.isDesktop
        ? MacosWindow(
            child: IndexedStack(
              index: pageIndex,
              children: pages,
            ),
            sidebar: Sidebar(
              minWidth: 200,
              bottom: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.profile_circled),
                      SizedBox(width: 8.0),
                      Text('${userData?.name} ${userData?.surname}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Style.textColor(context),
                          )),
                    ],
                  ),
                ),
                onTap: () => userData != null && license != null
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
                      label: Text(
                        TextLabels.kAppName,
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selectedColor: Colors.transparent,
                    ),
                    SidebarItem(
                        leading: Icon(
                          CupertinoIcons.list_bullet,
                          color: pageIndex == 0
                              ? Style.whiteColor
                              : Style.textColor(context),
                        ),
                        label: Text(TextLabels.kMenuList),
                        semanticLabel: TextLabels.kMenuList),
                    SidebarItem(
                      leading: Icon(
                        CupertinoIcons.rocket,
                        color: pageIndex == 1
                            ? Style.whiteColor
                            : Style.textColor(context),
                      ),
                      label: Text(TextLabels.kMenuElaboration),
                      semanticLabel: TextLabels.kMenuElaboration,
                    ),
                    SidebarItem(
                      leading: Icon(
                        CupertinoIcons.checkmark_rectangle,
                        color: pageIndex == 2
                            ? Style.whiteColor
                            : Style.textColor(context),
                      ),
                      label: Text(TextLabels.kMenuConfirmed),
                      semanticLabel: TextLabels.kMenuConfirmed,
                    ),
                    if (license?.bags != null && license!.bags) ...[
                      SidebarItem(
                        leading: Icon(
                          CupertinoIcons.bag,
                          color: pageIndex == 3
                              ? Style.whiteColor
                              : Style.textColor(context),
                        ),
                        label: Text(TextLabels.kMenuBags),
                        semanticLabel: TextLabels.kMenuBags,
                      ),
                    ],
                  ],
                );
              },
            ),
          )
        : CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              inactiveColor: Style.textMenuColor(context),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.list_bullet),
                    label: TextLabels.kMenuList,
                    tooltip: TextLabels.kMenuList),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.rocket),
                  label: TextLabels.kMenuElaboration,
                  tooltip: TextLabels.kMenuElaboration,
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.checkmark_rectangle),
                  label: TextLabels.kMenuConfirmed,
                  tooltip: TextLabels.kMenuConfirmed,
                ),
                if (license?.bags != null && license!.bags) ...[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.bag),
                    label: TextLabels.kMenuBags,
                    tooltip: TextLabels.kMenuBags,
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
                    return CupertinoPageScaffold(
                      child: Elaboration(
                        showMobileTitle: true,
                      ),
                    );
                  });
                  break;
                case 2:
                  returnValue = CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: Confirmed(
                        showMobileTitle: true,
                      ),
                    );
                  });
                  break;
                case 3:
                  returnValue = CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: Bags(
                        showMobileTitle: true,
                      ),
                    );
                  });
                  break;
              }

              return returnValue;
            },
          );
  }
}
