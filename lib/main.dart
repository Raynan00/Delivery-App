import 'package:active_ecommerce_seller_app/helpers/addon_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/business_setting_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/reset_helpers.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shop_info_helper.dart';
import 'package:active_ecommerce_seller_app/lang_config.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/providers/locale_provider.dart';
import 'package:active_ecommerce_seller_app/screens/home.dart';
import 'package:active_ecommerce_seller_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_value/shared_value.dart';
import 'package:toast/toast.dart';
import 'app_config.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  setShareValue(){
      //ResetHelper().clean();
      AddonsHelper().setAddonsData();
      BusinessSettingHelper().setBusinessSettingData();

      seller_id.load();
    access_token.load();
    is_logged_in.load();
  }

  @override
  void initState() {
    setShareValue();
    // await ResetHelper().clean();
    // AddonsHelper().setAddonsData();
    // BusinessSettingHelper().setBusinessSettingData();
    // access_token.load();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return MaterialApp(

            builder: OneContext().builder,
            navigatorKey: OneContext().navigator.key,
            title: AppConfig.app_name,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: MyTheme.white,
              primaryColor: MyTheme.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              accentColor: MyTheme.app_accent_color,
              /*textTheme: TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(fontSize: 12.0),
            )*/
              //
              // the below code is getting fonts from http
              //textTheme: GoogleFonts.roboto(),
              // textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
              //   bodyText1:
              //       GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
              //   bodyText2: GoogleFonts.sourceSansPro(
              //       textStyle: textTheme.bodyText2, fontSize: 12),
              // ),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            locale: provider.locale,
            supportedLocales: LangConfig().supportedLocales(),
            home: Splash(),
            //home: Main(),
          );
        }));
  }
}
