import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/custom/input_decorations.dart';
import 'package:active_ecommerce_seller_app/custom/intl_phone_input.dart';
import 'package:active_ecommerce_seller_app/custom/localization.dart';
import 'package:active_ecommerce_seller_app/custom/my_widget.dart';
import 'package:active_ecommerce_seller_app/custom/toast_component.dart';
import 'package:active_ecommerce_seller_app/helpers/auth_helper.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_seller_app/screens/home.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:active_ecommerce_seller_app/screens/password_forget.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "";
  BuildContext loadingContext;

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  MyWidget myWidget;

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    /*if (is_logged_in.value == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }*/
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog("Enter email",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog("Enter phone number",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog("Enter password",
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    loading();
    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);
    Navigator.pop(loadingContext);

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);



      access_token.load().whenComplete(() {
        if (access_token.$.isNotEmpty) {
          print(access_token.$);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return Main();
            },),(route)=>false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    myWidget = MyWidget(myContext: context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: MyTheme.login_reg_screen_color,
        body: buildBody(context),
      ),
    );
  }

  buildBody(context) {
    final _screen_width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              LangText(context: context).getLocal().common_welcome_text,
              style:
                  TextStyle(color: MyTheme.app_accent_border, fontSize: 20,fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.app_accent_border),
                        borderRadius: BorderRadius.circular(10)),
                    width: 72,
                    height: 72,
                    child: Image.asset(
                      "assets/logo/white_logo.png",
                      height: 48,
                      width: 36,
                    )),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: _screen_width / 2,
                  child: Text(
                    AppConfig.app_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 30.0,
              ),
              child: Text(
                LangText(context: context).getLocal().login_screen_login_text,
                style: TextStyle(
                    color: MyTheme.app_accent_border,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ),

            // login form container
            Container(
              width: _screen_width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      _login_by == "email" ? "Email" : "Phone",
                      style:const TextStyle(
                          color: MyTheme.app_accent_border,
                          fontWeight: FontWeight.w400,
                      fontSize: 12),
                    ),
                  ),
                //  if (_login_by == "email")
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
                              style: TextStyle(color: MyTheme.white),
                              controller: _emailController,
                              autofocus: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      borderColor: MyTheme.noColor,
                                      hint_text: "seller@example.com",
                                    hintTextColor: MyTheme.dark_grey

                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                 /* else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(255, 255, 255, 0.5)),
                            height: 36,
                            child: CustomInternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);
                                setState(() {
                                  _phone = number.phoneNumber;
                                });
                              },
                              onInputValidated: (bool value) {
                                print('on input validation ${value}');
                              },
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle:
                                  TextStyle(color: MyTheme.font_grey),
                              textStyle: TextStyle(color: Colors.white54),
                              initialValue: phoneCode,
                              textFieldController: _phoneNumberController,
                              formatInput: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              inputDecoration:
                                  InputDecorations.buildInputDecoration_phone(
                                      hint_text: "01710 333 558"),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _login_by = "email";
                              });
                            },
                            child: Text(
                              "or, Login with an email",
                              style: TextStyle(
                                  color: MyTheme.app_accent_color,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    ),*/
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          color: MyTheme.app_accent_border,
                          fontWeight: FontWeight.w400,
                      fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(255, 255, 255, 0.5)),
                          height: 36,
                          child: TextField(
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(color: MyTheme.white),
                            decoration: InputDecorations.buildInputDecoration_1(
                              borderColor: MyTheme.noColor,
                                hint_text: "• • • • • • • •",hintTextColor: MyTheme.dark_grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return PasswordForget();
                                }));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: MyTheme.white,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline),
                          ),
                      ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.app_accent_border, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        //height: 50,
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(11.0),

                          ),
                        ),
                        child: Text(
                          "login",
                          style: TextStyle(
                              color: MyTheme.app_accent_color,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          onPressedLogin();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  LangText(context: context).getLocal().login_screen_login_alert,
                  style: TextStyle(fontSize: 12, color: MyTheme.app_accent_border),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context).common_loading}"),
            ],
          ));
        });
  }
}
