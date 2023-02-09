import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_seller_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PasswordOtp extends StatefulWidget {
  PasswordOtp({Key key, this.verify_by = "email", this.email,})
      : super(key: key);
  final String verify_by;
  final String email;

  @override
  _PasswordOtpState createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  //controllers
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressConfirm() async {
    var code = _codeController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).password_otp_screen_code_warning, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).password_otp_screen_password_warning, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).password_otp_screen_password_confirm_warning, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).password_otp_screen_password_length_warning, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog(AppLocalizations.of(context).password_otp_screen_password_match_warning, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var passwordConfirmResponse =
        await AuthRepository().getPasswordConfirmResponse(code, password);

    if (passwordConfirmResponse.result == false) {
      ToastComponent.showDialog(passwordConfirmResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordConfirmResponse.message, gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  onTapResend() async {
    var passwordResendCodeResponse = await AuthRepository()
        .getPasswordResendCodeResponse(widget.email, widget.verify_by);

    if (passwordResendCodeResponse.result == false) {
      ToastComponent.showDialog(passwordResendCodeResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordResendCodeResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(

        backgroundColor:MyTheme.app_accent_color,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child:
                          Image.asset('assets/logo/white_logo.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      AppLocalizations.of(context).password_otp_screen_reset_password,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                        width: _screen_width * (3 / 4),
                        child: Text(
                            AppLocalizations.of(context).password_otp_screen_enter_verification_code_to_email,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))
                    ),
                  ),
                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Verification Code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MyTheme.white,
                                  ),
                                  textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                                  softWrap: false,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(255, 255, 255, 0.5)),
                                height: 36,
                                child: TextField(
                                  controller: _codeController,
                                  autofocus: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                        borderColor: MyTheme.noColor,
                                          hint_text: "A X B 4 J H"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context).password_otp_screen_password,
                            style: TextStyle(
                                color: MyTheme.app_accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'New Password',
                            style: TextStyle(
                              fontSize: 12,
                              color: MyTheme.white,
                            ),
                            textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(255, 255, 255, 0.5)),
                                child: TextField(
                                  controller: _passwordController,
                                  autofocus: false,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                        borderColor: MyTheme.noColor,
                                          hint_text: "• • • • • • • •"),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  AppLocalizations.of(context).password_otp_screen_password_length_recommendation,
                                  style: TextStyle(
                                      color: MyTheme.textfield_grey,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context).password_otp_screen_retype_password,
                            style: TextStyle(
                                color: MyTheme.app_accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 12,
                              color: MyTheme.white,
                            ),
                            textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(255, 255, 255, 0.5)),
                            child: TextField(
                              controller: _passwordConfirmController,
                              autofocus: false,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecorations.buildInputDecoration_1(
                                borderColor: MyTheme.noColor,
                                  hint_text: "• • • • • • • •"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              //height: 50,
                              color: MyTheme.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Text(
                                AppLocalizations.of(context).common_confirm_ucfirst,
                                style: TextStyle(
                                    color: MyTheme.app_accent_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressConfirm();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: InkWell(
                      onTap: () {
                        onTapResend();
                      },
                      child: Text(AppLocalizations.of(context).password_otp_screen_resend_code,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.app_accent_color,
                              decoration: TextDecoration.underline,
                              fontSize: 13)),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
