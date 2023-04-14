import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoadingOrError extends StatelessWidget {
  final bool loading;
  final String? errorMessage;

  const LoadingOrError({super.key, required this.loading, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
        transitionBackgroundColor: CupertinoDynamicColor.resolve(
            const CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemBackground,
              darkColor: CupertinoColors.darkBackgroundGray,
            ),
            context),
        body: Center(
            child: loading
                ? const CupertinoActivityIndicator()
                : Text('$errorMessage')));
  }
}
