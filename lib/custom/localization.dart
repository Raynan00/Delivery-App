import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class LangText{
  BuildContext context;

  LangText({this.context});

  AppLocalizations getLocal(){
    return AppLocalizations.of(context);
  }
}