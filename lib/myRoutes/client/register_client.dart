// ignore_for_file: unused_import

import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/main.dart';
import 'package:adlitem_flutter/myWidgets/klogin.dart';
import 'package:adlitem_flutter/services/AuthenticationService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../constants/colors.dart';

class RegisterClientDialog extends StatefulWidget {
  RegisterClientDialog({Key? key, required this.CliType}) : super(key: key);
  final String CliType;

  @override
  State<RegisterClientDialog> createState() => _RegisterClientDialogState();
}

class _RegisterClientDialogState extends State<RegisterClientDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.push(
            //     context, CupertinoPageRoute(builder: (context) => MyApp()));
          },
        ),
        title: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Registration as",
              // style: TextStyle(fontSize: 16),
            ),
            Text(
              widget.CliType,
              style: TextStyle(color: Colors.amber),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: FormBuilder(
        key: _formKey,
        child: Container(
            height: size.height,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                FormBuilderTextField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: LABELTEXT),
                    suffixIcon: Icon(
                      BootstrapIcons.person_circle,
                      size: LABELTEXT,
                      color: Colors.grey,
                    ),
                    hintText: 'Alan Doe',
                    hintStyle: TextStyle(
                      fontSize: HINTTEXT,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  name: 'name',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Last Name',
                    labelStyle: TextStyle(fontSize: LABELTEXT),
                    suffixIcon: Icon(
                      BootstrapIcons.person_circle,
                      size: LABELTEXT,
                      color: Colors.grey,
                    ),
                    hintText: 'Pons Jons',
                    hintStyle: TextStyle(
                      fontSize: HINTTEXT,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  name: 'lastname',
                  initialValue: "Alan doe",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
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
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email()
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: LABELTEXT),
                    suffixIcon: Icon(
                      BootstrapIcons.asterisk,
                      size: LABELTEXT,
                      color: Colors.grey,
                    ),
                    hintText: '8 characters mínimun',
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
                  height: 10,
                ),
                FormBuilderTextField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(fontSize: LABELTEXT),
                    suffixIcon: Icon(
                      BootstrapIcons.asterisk,
                      size: LABELTEXT,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(
                      fontSize: HINTTEXT,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  name: 'confirm_password',
                  obscureText: true,
                  obscuringCharacter: '*',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              _Register(_formKey.currentState!.value);
            }
          },
          label: const Text('Register'),
          icon: const Icon(Icons.check),
          backgroundColor: APP_COLORS.Primary),
    );
  }

  _Register(data) async {
    setState(() {
      isLoading = true;
    });
    var userData = {
      'name': data['name'],
      'lastname': data['lastname'],
      'email': data['email'],
      'password': data['password'],
      'userGroup': 'CLI',
      'group': widget.CliType,
    };
    //print(userData);
    var res = await AuthenticationService().Register(userData);
    if (res['success'] == -1) {
      //AppMessage.ShowError(res['message'], context);
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
      AppMessage.ShowInfo(res['message'], context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      //AppMessage.ShowInfo(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
  }
}
