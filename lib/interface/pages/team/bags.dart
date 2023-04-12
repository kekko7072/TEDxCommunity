import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tedxcommunity/services/imports.dart';

class Bags extends StatefulWidget {
  final bool showMobileTitle;

  const Bags({super.key, required this.showMobileTitle});

  @override
  State<Bags> createState() => _BagsState();
}

class _BagsState extends State<Bags> {
  String licenseId = "NO_ID";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    final license = Provider.of<License?>(context);

    final userData = Provider.of<UserData?>(context);

    return SafeArea(
      top: false,
      child: userData != null && license != null
          ? StreamBuilder<List<Bag>>(
              stream: DatabaseWarehouse(licenseId).allBags,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      TopBarTeam(
                          license: license,
                          userData: userData,
                          title: TextLabels.kMenuBags),
                    ],
                  );
                }
                List<Bag> bags = snapshot.data!;
                return Stack(children: [
                  CustomScrollView(
                    slivers: <Widget>[
                      if (widget.showMobileTitle) ...[
                        TopBarTeam(
                            license: license,
                            userData: userData,
                            title: TextLabels.kMenuBags),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < bags.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Slidable(
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          backgroundColor:
                                              CupertinoColors.destructiveRed,
                                          foregroundColor: Style.whiteColor,
                                          icon: CupertinoIcons.delete,
                                          label: 'Elimina',
                                          onPressed: (context) async =>
                                              await DatabaseWarehouse(licenseId)
                                                  .deleteBag(bags[index].id)
                                                  .then((_) {
                                            EasyLoading.showToast(
                                                'Bag eliminata',
                                                duration: Duration(
                                                    milliseconds:
                                                        kDurationToast),
                                                dismissOnTap: true,
                                                toastPosition:
                                                    EasyLoadingToastPosition
                                                        .bottom);
                                          }),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      color: Style.menuColor(context),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async =>
                                                    await DatabaseWarehouse(
                                                            licenseId)
                                                        .addRemoveBag(
                                                            id: bags[index].id,
                                                            isAdd: false)
                                                        .then((_) {
                                                      Vibrate.feedback(
                                                          FeedbackType.error);
                                                      EasyLoading.showToast(
                                                          '- 1',
                                                          duration: const Duration(
                                                              milliseconds:
                                                                  kDurationToast),
                                                          dismissOnTap: true,
                                                          toastPosition:
                                                              EasyLoadingToastPosition
                                                                  .bottom);
                                                    }),
                                                icon: Icon(
                                                  CupertinoIcons.minus_circle,
                                                  size: 50,
                                                  color: Colors.grey,
                                                )),
                                            Column(
                                              children: [
                                                Text(
                                                  bags[index].name,
                                                  style: kPageSubtitleStyle
                                                      .copyWith(
                                                    color: Style.textColor(
                                                        context),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Quantità: ',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Style.textColor(
                                                            context),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${bags[index].units}',
                                                      style: kPageSubtitleStyle
                                                          .copyWith(
                                                        color: Style.textColor(
                                                            context),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Prodotti: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Style.textColor(
                                                        context),
                                                  ),
                                                ),
                                                for (String val in bags[index]
                                                    .products) ...[
                                                  Text(
                                                    val,
                                                    style: TextStyle(
                                                      color: Style.textColor(
                                                          context),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async =>
                                                    await DatabaseWarehouse(
                                                            licenseId)
                                                        .addRemoveBag(
                                                            id: bags[index].id,
                                                            isAdd: true)
                                                        .then((_) {
                                                      Vibrate.feedback(
                                                          FeedbackType.success);
                                                      EasyLoading.showToast(
                                                          '+ 1',
                                                          duration: Duration(
                                                              milliseconds:
                                                                  kDurationToast),
                                                          dismissOnTap: true,
                                                          toastPosition:
                                                              EasyLoadingToastPosition
                                                                  .bottom);
                                                    }),
                                                icon: Icon(
                                                  CupertinoIcons.add_circled,
                                                  size: 50,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ],
                  )
                ]);
              })
          : Center(child: CupertinoActivityIndicator()),
    );
  }
}
