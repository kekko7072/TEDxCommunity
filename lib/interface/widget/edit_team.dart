import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class EditTeam extends StatefulWidget {
  const EditTeam({super.key});

  @override
  EditTeamState createState() => EditTeamState();
}

class EditTeamState extends State<EditTeam> {
  int selectedValue = 0;
  String licenseId = 'NO_ID';
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  Color changeColorBasedOnRole(Role role) {
    switch (role) {
      case Role.admin:
        return CupertinoColors.systemGrey;
      case Role.volunteer:
        return CupertinoColors.activeBlue;
      case Role.master:
        return CupertinoColors.activeBlue;
      case Role.coach:
        return CupertinoColors.activeBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                AppLocalizations.of(context)!.editTeam,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: const Icon(CupertinoIcons.clear_circled_solid),
                    onPressed: () => Navigator.of(context).pop()),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<UserData>?>(
                stream: DatabaseUser(licenseId: licenseId).streamAllUsers,
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserData>?> snapshot) {
                  print(snapshot.hasError);
                  print(snapshot.error);
                  if (snapshot.hasData) {
                    List<UserData> usersList = snapshot.data!;
                    return CupertinoScrollbar(
                      child: ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CupertinoListTile(
                            title: Text(
                                '${usersList[index].name} ${usersList[index].surname}'),
                            leading: Icon(
                              usersList[index].active
                                  ? CupertinoIcons.check_mark_circled
                                  : CupertinoIcons.xmark_circle,
                              color: usersList[index].active
                                  ? CupertinoColors.activeGreen
                                  : CupertinoColors.destructiveRed,
                            ),
                            subtitle: Text(usersList[index].email),
                            additionalInfo: Text(
                              TextLabels.userRoleToString(
                                  usersList[index].role, context),
                              style: TextStyle(
                                  color: changeColorBasedOnRole(
                                      usersList[index].role)),
                            ),
                            trailing: IconButton(
                                onPressed: () => showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoActionSheet(
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .editTeamRoles),
                                            onPressed: () =>
                                                showCupertinoDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (_) {
                                                      int selectedValueIndex =
                                                          0;

                                                      return CupertinoAlertDialog(
                                                        title: Text(
                                                            '${AppLocalizations.of(context)!.selectNewRoleOf} ${usersList[index].name} ${usersList[index].surname}'),
                                                        content: SizedBox(
                                                          height: 100,
                                                          child:
                                                              CupertinoPicker(
                                                            onSelectedItemChanged:
                                                                (index) => setState(() =>
                                                                    selectedValueIndex =
                                                                        index),
                                                            itemExtent: 32.0,
                                                            magnification: 1,
                                                            children: [
                                                              Text(TextLabels
                                                                  .userRoleToString(
                                                                      Role.volunteer,
                                                                      context)),
                                                              Text(TextLabels
                                                                  .userRoleToString(
                                                                      Role.master,
                                                                      context)),
                                                              Text(TextLabels
                                                                  .userRoleToString(
                                                                      Role.coach,
                                                                      context)),
                                                              Text(TextLabels
                                                                  .userRoleToString(
                                                                      Role.admin,
                                                                      context))
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .cancel,
                                                              style:
                                                                  const TextStyle(
                                                                color: CupertinoColors
                                                                    .destructiveRed,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Role
                                                                  selectedRole =
                                                                  Role.volunteer;
                                                              switch (
                                                                  selectedValueIndex) {
                                                                case 0:
                                                                  selectedRole =
                                                                      Role.volunteer;
                                                                  break;
                                                                case 1:
                                                                  selectedRole =
                                                                      Role.master;
                                                                  break;
                                                                case 2:
                                                                  selectedRole =
                                                                      Role.coach;
                                                                  break;
                                                                case 3:
                                                                  selectedRole =
                                                                      Role.admin;
                                                                  break;
                                                              }
                                                              await DatabaseUser(
                                                                      licenseId:
                                                                          licenseId,
                                                                      uid: usersList[
                                                                              index]
                                                                          .uid)
                                                                  .updateUserDataRole(
                                                                      role:
                                                                          selectedRole)
                                                                  .whenComplete(() =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop());
                                                            },
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .edit,
                                                              style:
                                                                  const TextStyle(
                                                                color: CupertinoColors
                                                                    .activeBlue,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                          ),
                                          CupertinoActionSheetAction(
                                            isDestructiveAction:
                                                usersList[index].active,
                                            onPressed: () async =>
                                                await DatabaseUser(
                                                        licenseId: licenseId,
                                                        uid: usersList[index]
                                                            .uid)
                                                    .updateUserDataActive(
                                                        value: !usersList[index]
                                                            .active)
                                                    .then((value) =>
                                                        Navigator.pop(context)),
                                            child: usersList[index].active
                                                ? Text(AppLocalizations.of(
                                                        context)!
                                                    .deactivate)
                                                : Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .activate,
                                                    style: const TextStyle(
                                                        color: CupertinoColors
                                                            .activeGreen)),
                                          ),
                                          CupertinoActionSheetAction(
                                            isDestructiveAction: true,
                                            onPressed: () async =>
                                                await DatabaseUser(
                                                        licenseId: licenseId,
                                                        uid: usersList[index]
                                                            .uid)
                                                    .delete
                                                    .then((value) =>
                                                        Navigator.pop(context)),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .delete),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel),
                                        ),
                                      ),
                                    ),
                                icon: const Icon(
                                    CupertinoIcons.ellipsis_vertical)),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
