import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class InputField extends StatelessWidget {
  final String placeholder;
  final TextInputType keyboardType;
  final Function onChanged;

  const InputField({
    super.key,
    required this.placeholder,
    required this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: CupertinoTextField(
        decoration: BoxDecoration(
          color: Style.inputTextFieldColor(context),
          borderRadius:
              BorderRadius.all(Radius.circular(Style.inputTextFieldRadius)),
        ),
        enableSuggestions: true,
        textCapitalization: TextCapitalization.sentences,
        placeholder: placeholder,
        keyboardType: keyboardType,
        onChanged: (val) => onChanged(val),
      ),
    );
  }
}

class InputFieldWithController extends StatelessWidget {
  const InputFieldWithController({
    Key? key,
    required this.placeholder,
    required this.keyboardType,
    required this.controller,
  }) : super(key: key);
  final String placeholder;
  final TextInputType keyboardType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: CupertinoTextField(
        controller: controller,
        decoration: BoxDecoration(
          color: Style.inputTextFieldColor(context),
          borderRadius:
              BorderRadius.all(Radius.circular(Style.inputTextFieldRadius)),
        ),
        enableSuggestions: true,
        textCapitalization: TextCapitalization.sentences,
        placeholder: placeholder,
        keyboardType: keyboardType,
      ),
    );
  }
}
