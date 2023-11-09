import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/register.dart';
import 'package:adlitem_flutter/myRoutes/forgot_password.dart';
import 'package:adlitem_flutter/services/AuthenticationService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../constants/environment.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class KLogin extends StatefulWidget {
  const KLogin({Key? key}) : super(key: key);

  @override
  State<KLogin> createState() => _KLoginState();
}

class _KLoginState extends State<KLogin> {
  final _formKey = GlobalKey<FormBuilderState>();
  late IOWebSocketChannel channel;

  bool isLoading = false;
  SystemAccount user = new SystemAccount();

  void Login(data) async {
    try {
      if (_formKey.currentState!.saveAndValidate()) {
        setState(() {
          isLoading = !isLoading;
        });
        Map res = await AuthenticationService()
            .Login(data!.value['email'], data!.value['password']);
        //print(res['data']);
        if (res['success'] == -1) {
          AppMessage.ShowError(res, context);
          setState(() {
            isLoading = !isLoading;
          });
        } else if (res['success'] == 0) {
          AppMessage.ShowError(res['message'], context);
          setState(() {
            isLoading = !isLoading;
          });
        } else if (res['success'] == 1) {
          if (mounted)
            setState(() {
              user.userGroup = res['data']['userGroup'];
              user.verificationToken = res['token'];
              user.systemaccountId = res['data']['systemaccountId'];
              user.name = res['data']['name'];
              user.lastname = res['data']['lastname'];
              user.email = res['data']['email'];
              user.rate = res['data']['rate'];
              user.cancelAgree = res['data']['cancelAgree'] == 1 ? true : false;
            });

          context.read<AppProvider>().login(user);

          if (mounted) {
            AppMessage.ShowInfo(res['message'], context);
            setState(() {
              isLoading = !isLoading;
            });
          }
        } else {
          AppMessage.ShowError(res, context);
        }
      }
    } catch (ex) {
      if (mounted)
        setState(() {
          isLoading = !isLoading;
        });
      AppMessage.ShowError(ex, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // try {
    //   channel = new IOWebSocketChannel.connect('wss://socketapi.k-nos.com/');
    //   //MyHomePageState.noResponse = false;
    // } catch (e) {
    //   //MyHomePageState.noResponse = true;
    // }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(alignment: FractionalOffset.center, children: [
          Container(
              height: size.height,
              padding: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo-sm.png",
                      width: 150,
                      height: 100,
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 20,
                          color: APP_COLORS.Primary,
                          fontWeight: FontWeight.bold),
                    ),
                    FormBuilderTextField(
                      initialValue: "knoscliente@k-nos.com",
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: LABELTEXT),
                        suffixIcon: Icon(
                          BootstrapIcons.person_circle,
                          size: LABELTEXT,
                          color: Colors.grey,
                        ),
                        hintText: 'alandoe@gmail.com',
                        hintStyle: TextStyle(
                          fontSize: HINTTEXT,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      name: 'email',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormBuilderTextField(
                      initialValue: "123456",
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: LABELTEXT),
                        suffixIcon: Icon(
                          BootstrapIcons.asterisk,
                          size: LABELTEXT,
                          color: Colors.grey,
                        ),
                        hintText: '6 characters mínimun',
                        hintStyle: TextStyle(
                          fontSize: HINTTEXT,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      name: 'password',
                      obscureText: true,
                      obscuringCharacter: '*',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(6),
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        //width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: APP_COLORS.Primary,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Login(_formKey.currentState!);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                BootstrapIcons.check_circle,
                                color: WHITE,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Login',
                                style: TextStyle(color: WHITE),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ForgotPassword()),
                                );
                              },
                              child: Text("Forgot password")),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          Register(title: "")),
                                );
                              },
                              child: Text("Sign Up for free")),
                          //label: Text("Forgot password"))
                        ],
                      ),
                    )
                  ],
                ),
              )),
          if (isLoading)
            Container(
                constraints: BoxConstraints.expand(),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.2)),
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(APP_COLORS.Primary),
                      backgroundColor: Color.fromARGB(0, 8, 6, 6),
                      semanticsLabel: "Wait...",
                      color: APP_COLORS.Primary,
                    ))),
        ]));
  }
}
