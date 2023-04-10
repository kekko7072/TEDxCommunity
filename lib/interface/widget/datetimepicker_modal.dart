import 'package:flutter/cupertino.dart';

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
          SizedBox(height: 10),
          Text('Seleziona data',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          Container(
            height: 250,
            child: CupertinoDatePicker(
                mode: widget.pickerType,
                use24hFormat: true,
                initialDateTime: DateTime.now().toUtc().toLocal(),
                onDateTimeChanged: (val) => widget.onDateTimeChanged(val)),
          ),
          CupertinoButton(
            child: Text('Salva'),
            onPressed: () => widget.onPressed(),
          )
        ],
      ),
    );
  }
}
