import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 2,
            color: Theme.of(context).textTheme.labelMedium!.color,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Text(
          appLocale.orContinue,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.labelMedium!.color,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2,
            color: Theme.of(context).textTheme.labelMedium!.color,
            indent: 20,
            endIndent: 20,
          ),
        ),
      ],
    );
  }
}
