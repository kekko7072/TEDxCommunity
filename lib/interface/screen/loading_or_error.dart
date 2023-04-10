import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoadingOrError extends StatelessWidget {
  final bool loading;
  final String? errorMessage;

  LoadingOrError({required this.loading, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
        transitionBackgroundColor: CupertinoDynamicColor.resolve(
            CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemBackground,
              darkColor: CupertinoColors.darkBackgroundGray,
            ),
            context),
        body: Center(
            child: loading
                ? CupertinoActivityIndicator()
                : Text('$errorMessage')));
  }
}
