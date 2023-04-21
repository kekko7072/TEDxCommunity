import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class DateTimePickerModal extends StatefulWidget {
  final CupertinoDatePickerMode pickerType;
  final Function onDateTimeChanged;
  final Function onPressed;

  const DateTimePickerModal({
    super.key,
    required this.pickerType,
    required this.onDateTimeChanged,
    required this.onPressed,
  });

  @override
  DateTimePickerModalState createState() => DateTimePickerModalState();
}

class DateTimePickerModalState extends State<DateTimePickerModal> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.selectDate,
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          SizedBox(
            height: 250,
            child: CupertinoDatePicker(
                mode: widget.pickerType,
                use24hFormat: true,
                initialDateTime: DateTime.now().toUtc().toLocal(),
                onDateTimeChanged: (val) => widget.onDateTimeChanged(val)),
          ),
          CupertinoButton(
            child: Text(AppLocalizations.of(context)!.add),
            onPressed: () => widget.onPressed(),
          )
        ],
      ),
    );
  }
}
