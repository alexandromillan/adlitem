// ignore_for_file: unused_import

import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ForgotResetPassword extends StatefulWidget {
  const ForgotResetPassword({Key? key, required this.userData})
      : super(key: key);
  final userData;
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ForgotResetPassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _newPassW = GlobalKey<FormBuilderFieldState>();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Resetpassword(newPwd) async {
    setState(() {
      isLoading = true;
    });

    var res = await AuthenticationService().ChangePassword({
      'systemaccountId': widget.userData['systemaccountId'],
      'password': newPwd
    });

    if (res['success'] == -1) {
      AppMessage.ShowError(res['message'], context);
      setState(() {
        isLoading = false;
      });
    } else if (res['success'] == 0) {
      AppMessage.ShowError(res['message'], context);
      setState(() {
        isLoading = false;
      });
    } else if (res['success'] == 1) {
      setState(() {
        isLoading = false;
      });
      _formKey.currentState!.reset();
      AppMessage.ShowInfo("Password change successfully", context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      AppMessage.ShowInfo(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.userData['systemaccountId']);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              Resetpassword(_formKey.currentState!.value['newpassword']);
            }
          },
          icon: Icon(Icons.check),
          label: Text("Change")),
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Container(
        child: FormBuilder(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                FormBuilderTextField(
                  key: _newPassW,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'New Password',
                    labelStyle: TextStyle(fontSize: LABELTEXT),
                    suffixIcon: Icon(
                      Icons.password_rounded,
                      size: LABELTEXT,
                      color: Colors.grey,
                    ),
                    hintText: '',
                    hintStyle: TextStyle(
                      fontSize: HINTTEXT,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  name: 'newpassword',
                  obscureText: true,
                  initialValue: "",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6,
                        errorText: "Password must be 6 characters minimun"),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(fontSize: LABELTEXT),
                    suffixIcon: Icon(
                      Icons.password_sharp,
                      size: LABELTEXT,
                      color: Colors.grey,
                    ),
                    hintText: '',
                    hintStyle: TextStyle(
                      fontSize: HINTTEXT,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  name: 'confirmnewpassword',
                  obscureText: true,
                  initialValue: "",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ]),
            )),
      ),
    );
  }
}
