import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class AddLicense extends StatefulWidget {
  final String licenseId;
  final String adminUid;
  final Function() onLogin;

  const AddLicense({
    Key? key,
    required this.licenseId,
    required this.adminUid,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
  TextEditingController licenseNameController =
      TextEditingController(text: 'TEDx');

  bool _loadingPath = false;
  bool _loadingDone = false;
  String url = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context)!.createNewLicense),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                    '${AppLocalizations.of(context)!.licenseId}: ${widget.licenseId}'),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.doc_on_clipboard,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      EasyLoading.showToast(
                          AppLocalizations.of(context)!.copied);
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
            placeholder:
                '${AppLocalizations.of(context)!.name} (ex. TEDxCortina)',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.uploadReleaseFormForSpeaker),
          !_loadingPath
              ? CupertinoButton(
                  onPressed: () => _openFileExplorer(),
                  child: _loadingDone
                      ? Text(
                          AppLocalizations.of(context)!.edit,
                          style: const TextStyle(
                              color: CupertinoColors.destructiveRed),
                        )
                      : Text(
                          AppLocalizations.of(context)!.upload,
                        ),
                )
              : const CupertinoActivityIndicator()
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: CupertinoColors.destructiveRed),
            )),
        TextButton(
            onPressed: () async {
              EasyLoading.show();
              await DatabaseLicense(widget.licenseId)
                  .create(
                      adminUid: widget.adminUid,
                      licenseName: licenseNameController.text,
                      urlReleaseForm: url)
                  .whenComplete(() {
                EasyLoading.dismiss();

                widget.onLogin();
                Navigator.of(context).pop();
                EasyLoading.showSuccess(
                    AppLocalizations.of(context)!.activated);
              });
            },
            child: Text(
              AppLocalizations.of(context)!.activate,
              style: const TextStyle(color: CupertinoColors.activeBlue),
            )),
      ],
    );
  }

  Future<void> _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      FilePickerResult? picked = await FilePicker.platform.pickFiles();

      if (picked != null) {
        if (kIsWeb) {
          uploadFile(picked.files.first.bytes!, picked.files.first.extension!);
        } else {
          if (picked.files.first.path != '') {
            uploadFile(await File(picked.files.first.path!).readAsBytes(),
                picked.files.first.extension!);
          } else {
            print('PATH FILE NULL!');
          }
        }
      } else {
        setState(() => _loadingPath = false);
      }
    } on PlatformException catch (e) {
      print('ERROR Unsupported operation$e');
    } catch (ex) {
      print('EX ERROR$ex');
    }
  }

  Future<void> uploadFile(Uint8List data, String extension) async {
    Reference reference = FirebaseStorage.instance
        .ref('${widget.licenseId}/releaseForm.$extension');
    TaskSnapshot uploadTask = await reference.putData(data);

    url = await uploadTask.ref.getDownloadURL();

    if (uploadTask.state == TaskState.success) {
      setState(() {
        _loadingPath = false;
        _loadingDone = true;
      });
    } else {
      print(uploadTask.state);
      setState(() {
        _loadingPath = false;
      });
    }
  }
}
