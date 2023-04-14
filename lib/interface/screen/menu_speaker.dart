import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class MenuSpeaker extends StatefulWidget {
  final bool isDesktop;
  final Speaker speakerData;

  const MenuSpeaker(
      {super.key, required this.isDesktop, required this.speakerData});

  @override
  MenuSpeakerState createState() => MenuSpeakerState();
}

class MenuSpeakerState extends State<MenuSpeaker> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ///DESKTOP

    late List<Widget> pages = [
      ///Coaching
      CupertinoTabView(builder: (context) {
        return SafeArea(
          child: MacosScaffold(
              backgroundColor: Style.backgroundColor(context),
              toolBar: ToolBar(
                title: const Text('Coaching'),
                actions: [
                  ToolBarIconButton(
                    icon: const Icon(
                      CupertinoIcons.videocam_circle,
                      color: CupertinoColors.activeBlue,
                    ),
                    onPressed: () async {
                      if (await canLaunchUrlString(widget.speakerData.link)) {
                        EasyLoading.showToast('Apro videochiamata',
                            duration: const Duration(seconds: 2),
                            dismissOnTap: true,
                            toastPosition: EasyLoadingToastPosition.bottom);
                        await launchUrlString(
                          widget.speakerData.link,
                        );
                      } else {
                        EasyLoading.showToast('Errore link non valido',
                            duration: const Duration(seconds: 2),
                            dismissOnTap: true,
                            toastPosition: EasyLoadingToastPosition.bottom);
                      }
                    },
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
                  return Coaching(
                    speakerData: widget.speakerData,
                    showMobileTitle: false,
                  );
                }),
              ]),
        );
      }),

      ///Gestione
      CupertinoTabView(builder: (context) {
        return SafeArea(
          child: MacosScaffold(
              backgroundColor: Style.backgroundColor(context),
              children: [
                TitleBar(
                  title: Text(AppLocalizations.of(context)!.elaboration),
                  /*actions: [
                    ToolBarIconButton(
                      icon: Icon(
                        CupertinoIcons.videocam_circle,
                        color: CupertinoColors.activeBlue,
                      ),
                      onPressed: () async {
                        if (await canLaunch(widget.speakerData.link)) {
                          EasyLoading.showToast('Apro videochiamata',
                              duration: Duration(seconds: 2),
                              dismissOnTap: true,
                              toastPosition: EasyLoadingToastPosition.bottom);
                          await launch(
                            widget.speakerData.link,
                            forceSafariVC: false,
                            forceWebView: false,
                          );
                        } else {
                          EasyLoading.showToast('Errore link non valido',
                              duration: Duration(seconds: 2),
                              dismissOnTap: true,
                              toastPosition: EasyLoadingToastPosition.bottom);
                        }
                      },
                    ),
                  ],*/
                ),
                ContentArea(builder: (context, scrollController) {
                  return Management(
                    speakerData: widget.speakerData,
                    showMobileTitle: false,
                  );
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
                      Text(widget.speakerData.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Style.textColor(context),
                          )),
                    ],
                  ),
                ),
                onTap: () => showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return InfoAppSpeaker(speakerData: widget.speakerData);
                  },
                ),
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
                        AppLocalizations.of(context)!.appName,
                        style: const TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selectedColor: Colors.transparent,
                    ),
                    SidebarItem(
                        leading: Icon(
                          CupertinoIcons.calendar,
                          color: pageIndex == 0
                              ? Style.whiteColor
                              : Style.textColor(context),
                        ),
                        label: Text('Coaching'),
                        semanticLabel: 'Coaching'),
                    SidebarItem(
                      leading: Icon(
                        CupertinoIcons.book,
                        color: pageIndex == 1
                            ? Style.whiteColor
                            : Style.textColor(context),
                      ),
                      label: Text('Gestione'),
                      semanticLabel: 'Gestione',
                    ),
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
                    icon: Icon(CupertinoIcons.calendar),
                    label: 'Coaching',
                    tooltip: 'Coaching'),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book),
                  label: 'Gestione',
                  tooltip: 'Gestione',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              late CupertinoTabView returnValue;
              switch (index) {
                case 0:
                  returnValue = CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: Coaching(
                        speakerData: widget.speakerData,
                        showMobileTitle: true,
                      ),
                    );
                  });
                  break;
                case 1:
                  returnValue = CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: Management(
                        speakerData: widget.speakerData,
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
