import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/myRoutes/forgot_ResetPassword.dart';
import 'package:adlitem_flutter/services/GeneralService.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailformKey = GlobalKey<FormBuilderState>();
  final _codeformKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  bool isWaiting = false;
  String code = "";
  var userData = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot your password?'),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Text(
                    "Type your registration email and send verification code..."),
                SizedBox(
                  height: 10,
                ),
                FormBuilder(
                  key: _emailformKey,
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: LABELTEXT),
                      suffixIcon: Icon(
                        Icons.email,
                        size: LABELTEXT,
                        color: Colors.grey,
                      ),
                      hintText: 'alan.doe@gmail.com',
                      hintStyle: TextStyle(
                        fontSize: HINTTEXT,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    name: 'email',
                    initialValue: "dev@k-nos.com",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email()
                    ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                !isWaiting
                    ? Container(
                        decoration: BoxDecoration(
                          color: APP_COLORS.Primary,
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_emailformKey.currentState!.saveAndValidate()) {
                              SendEmail(_emailformKey.currentState!);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_rounded,
                                color: WHITE,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'SEND EMAIL',
                                style: TextStyle(color: WHITE),
                              ),
                            ],
                          ),
                        ))
                    : Counter({}),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Check your email inbox and type 6 digit code in field below..."),
                SizedBox(
                  height: 20,
                ),
                FormBuilder(
                  key: _codeformKey,
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Code',
                      labelStyle: TextStyle(fontSize: LABELTEXT),
                      suffixIcon: Icon(
                        Icons.code_sharp,
                        size: LABELTEXT,
                        color: Colors.grey,
                      ),
                      hintText: 'the code here',
                      hintStyle: TextStyle(
                        fontSize: HINTTEXT,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    name: 'code',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                      FormBuilderValidators.maxLength(6)
                    ]),
                  ),
                ),
                if (isWaiting)
                  Container(
                      decoration: BoxDecoration(
                        color: APP_COLORS.Primary,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_codeformKey.currentState!.saveAndValidate()) {
                            validateCode(
                                _codeformKey.currentState!.value['code']);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.code,
                              color: WHITE,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'VERIFY CODE',
                              style: TextStyle(color: WHITE),
                            ),
                          ],
                        ),
                      ))
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

  void SendEmail(data) async {
    // print(data.value);
    setState(() {
      isLoading = true;
    });
    String email = data.value['email'];
    var res = await SystemAccountService().getSystemAccountByEmail(email);
    if (res['success'] == -1) {
      setState(() {
        isLoading = false;
      });
    } else if (res['success'] == 0) {
      AppMessage.ShowError("Email No found", context);
      setState(() {
        isLoading = false;
      });
    } else if (res['success'] == 1) {
      setState(() {
        isWaiting = true;
        userData = res['data'];
      });
      var resp = await GeneralService().SendEmail("forgot", email);
      //print(resp);
      if (resp['success'] == -1) {
        setState(() {
          isLoading = false;
        });
        AppMessage.ShowError("Error sending email", context);
      } else if (resp['success'] == 1) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          isWaiting = true;
          code = resp['code'];
        });
        _emailformKey.currentState!.reset();

        AppMessage.ShowInfo("Email sent succesfully...", context);
      } else {
        setState(() {
          isLoading = false;
        });
      }
      //Navigator.pop(context, true);

      _emailformKey.currentState!.reset();

      //AppMessage.ShowInfo("Email sent succesfully...", context);
    } else {
      setState(() {
        isLoading = false;
      });
    }
    //Navigator.pop(context, true);
    setState(() {
      isLoading = false;
    });
  }

  Counter(data) {
    final int _duration = 60;
    final CountDownController _controller = CountDownController();
    return Container(
        child: Center(
      child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: _duration,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: _controller,

        // Width of the Countdown Widget.
        width: MediaQuery.of(context).size.width / 6,

        // Height of the Countdown Widget.
        height: MediaQuery.of(context).size.height / 6,

        // Ring Color for Countdown Widget.
        ringColor: Colors.grey[300]!,

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Colors.purpleAccent[100]!,

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.purple[500],

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 5.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.butt,

        // Text Style for Countdown Text.
        textStyle: const TextStyle(
          fontSize: 15.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.MM_SS,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: true,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: false,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: true,

        // This Callback will execute when the Countdown Starts.
        onStart: () {
          // Here, do whatever you want
          if (mounted) debugPrint('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          // Here, do whatever you want
          //Navigator.pop(context);
          if (mounted)
            setState(() {
              isWaiting = false;
            });
          debugPrint('Countdown Ended');
        },

        // This Callback will execute when the Countdown Changes.
        onChange: (String timeStamp) {
          // Here, do whatever you want
          debugPrint('Countdown Changed $timeStamp');
        },

        /* 
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow 
              the default behavior.
          */
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (duration.inSeconds == 0) {
            // only format for '0'
            return "Finish";
          }
          if (duration.inSeconds == 11) {
            return "Waiting...";
          } else {
            // other durations by it's default format
            return Function.apply(defaultFormatterFunction, [duration]);
          }
        },
      ),
    ));
  }

  validateCode(String emailCode) {
    if (emailCode != code) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Code"),
            actions: [
              OutlinedButton.icon(
                label: Text("OK"),
                icon: Icon(Icons.error),
                //child: Text("Confirm"),
                onPressed: () async {
                  Navigator.pop(context);
                },
              )
            ],
            content: Text(
              "The provided code is invalid. Try to resend the email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      );

      ; // show th
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ForgotResetPassword(userData: userData)),
      );
    }
  }
}
