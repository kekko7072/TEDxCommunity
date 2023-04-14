import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class AddBag extends StatefulWidget {
  @override
  State<AddBag> createState() => _AddBagState();
}

class _AddBagState extends State<AddBag> {
  final String id = const Uuid().v1();
  String name = '';
  TextEditingController product = TextEditingController();
  List<String> products = [];
  String licenseId = "NO_ID";
  @override
  void initState() {
    super.initState();
    DatabaseLicense.loadLicenseId.then((id) => setState(() => licenseId = id));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Speaker>?>(
        stream: DatabaseSpeaker(licenseId: licenseId).allQuery,
        builder: (context, snapshot) {
          return CupertinoAlertDialog(
            title: const Text('Aggiungi bag'),
            content: Column(
              children: [
                const Text('Inserisci nome tiplologia'),
                InputField(
                  placeholder: 'Tipologia bag',
                  keyboardType: TextInputType.name,
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 5),
                const Text('Inserisci prodotti all\'interno'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CupertinoTextField(
                          controller: product,
                          decoration: BoxDecoration(
                            color: Style.inputTextFieldColor(context),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Style.inputTextFieldRadius)),
                          ),
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.sentences,
                          placeholder: 'Nome prodotto',
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CupertinoButton(
                        child: const Icon(CupertinoIcons.add_circled),
                        onPressed: () {
                          setState(() {
                            products.add(product.text);
                            product.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                for (String value in products) ...[
                  Text(value),
                ]
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed),
                  )),
              TextButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    await DatabaseWarehouse(licenseId)
                        .createBag(Bag(
                            id: id, name: name, products: products, units: 0))
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                  child: const Text(
                    'Aggiungi',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  )),
            ],
          );
        });
  }
}
