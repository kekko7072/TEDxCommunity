import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class EditTeamRole extends StatefulWidget {
  const EditTeamRole({
    super.key,
  });

  @override
  EditTeamRoleState createState() => EditTeamRoleState();
}

class EditTeamRoleState extends State<EditTeamRole> {
  int selectedValue = 0;
  String licenseId = "NO_ID";
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
        return CupertinoColors.systemGreen;
      case Role.coach:
        return CupertinoColors.systemPink;
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
                'Modifica ruoli team',
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
                  if (snapshot.hasData) {
                    List<UserData> usersList = snapshot.data!;
                    return CupertinoScrollbar(
                      child: ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CupertinoListTile(
                            title: Text(
                                '${usersList[index].name} ${usersList[index].surname}'),
                            subtitle: Text(usersList[index].email),
                            additionalInfo: Text(
                              usersList[index].role.toString(),
                              style: TextStyle(
                                  color: changeColorBasedOnRole(
                                      usersList[index].role)),
                            ),
                            trailing: IconButton(
                                onPressed: () => showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) {
                                      int selectedValue =
                                          0; // Initialize the selected value to the first item in the list

                                      return CupertinoAlertDialog(
                                        title: Text(
                                            'Seleziona il nuovo ruolo di ${usersList[index].name} ${usersList[index].surname}'),
                                        content: SizedBox(
                                          height: 100,
                                          child: CupertinoPicker(
                                            onSelectedItemChanged: (value) {
                                              setState(() => selectedValue =
                                                  value); // Update the selected value
                                            },
                                            itemExtent: 32.0,
                                            magnification: 1,
                                            children: [
                                              Text(
                                                '${Role.volunteer}',
                                              ),
                                              Text(
                                                '${Role.master}',
                                              ),
                                              Text(
                                                '${Role.coach}',
                                              ),
                                              Text(
                                                '${Role.admin}',
                                              )
                                            ],
                                          ),
                                        ),
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
                                                    .destructiveRed,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              String selectedRole =
                                                  ''; // Variable to store the selected role as a string
                                              switch (selectedValue) {
                                                case 0:
                                                  selectedRole =
                                                      Role.volunteer.toString();
                                                  break;
                                                case 1:
                                                  selectedRole =
                                                      Role.master.toString();
                                                  break;
                                                case 2:
                                                  selectedRole =
                                                      Role.coach.toString();
                                                  break;
                                                case 3:
                                                  selectedRole =
                                                      Role.admin.toString();
                                                  break;
                                              }
                                              DatabaseUser(
                                                      licenseId: licenseId,
                                                      uid: usersList[index].uid)
                                                  .updateUserSinglePersonalData(
                                                field: 'role',
                                                value:
                                                    selectedRole, // Use the selected role as the value
                                              )
                                                  .then((_) {
                                                EasyLoading.showToast(
                                                  'Nuovo ruolo assegnato',
                                                  duration: const Duration(
                                                      milliseconds:
                                                          kDurationToast),
                                                  dismissOnTap: true,
                                                  toastPosition:
                                                      EasyLoadingToastPosition
                                                          .bottom,
                                                );
                                              });

                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .edit,
                                              style: const TextStyle(
                                                color:
                                                    CupertinoColors.activeBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
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
