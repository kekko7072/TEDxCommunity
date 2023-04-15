import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class AddLicense extends StatefulWidget {
  final String licenseId;
  final String adminUid;
  final Function() onLogin;

  const AddLicense(
      {Key? key,
      required this.licenseId,
      required this.adminUid,
      required this.onLogin})
      : super(key: key);

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
  TextEditingController licenseNameController =
      TextEditingController(text: 'TEDx');

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Crea licenza'),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text('LicenseId: ${widget.licenseId}'),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.doc_on_clipboard,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      EasyLoading.showToast('Copiato');
                      Clipboard.setData(ClipboardData(text: widget.licenseId));
                    },
                  ))
            ],
          ),
          CupertinoTextFormFieldRow(
            decoration: BoxDecoration(
              color: Style.inputTextFieldColor(context),
              borderRadius:
                  BorderRadius.all(Radius.circular(Style.inputTextFieldRadius)),
            ),
            enableSuggestions: true,
            controller: licenseNameController,
            textCapitalization: TextCapitalization.words,
            placeholder: 'Name (es. TEDxCortina)',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              EasyLoading.show();
              await DatabaseLicense(widget.licenseId)
                  .create(
                      adminUid: widget.adminUid,
                      licenseName: licenseNameController.text)
                  .whenComplete(() {
                EasyLoading.dismiss();

                widget.onLogin();
                Navigator.of(context).pop();
                EasyLoading.showSuccess('Licenza attivata con successo!');
              });
            },
            child: const Text(
              'Attiva',
              style: TextStyle(color: CupertinoColors.activeBlue),
            )),
      ],
    );
  }
}
