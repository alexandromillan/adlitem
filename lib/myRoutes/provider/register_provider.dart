// ignore_for_file: unnecessary_import

import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/services/AuthenticationService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../constants/colors.dart';

class RegisterProviderDialog extends StatefulWidget {
  RegisterProviderDialog({Key? key, required this.ProType}) : super(key: key);
  final String ProType;

  @override
  State<RegisterProviderDialog> createState() => _RegisterProviderDialogState();
}

class _RegisterProviderDialogState extends State<RegisterProviderDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Registration as",
              //style: TextStyle(fontSize: 16),
            ),
            Text(
              widget.ProType,
              style: TextStyle(color: Colors.amber),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
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
                      labelText: 'Last Name',
                      labelStyle: TextStyle(fontSize: LABELTEXT),
                      suffixIcon: Icon(
                        BootstrapIcons.person_circle,
                        size: LABELTEXT,
                        color: Colors.grey,
                      ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(3)),
                      // ),
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
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(3)),
                      // ),
                      hintText: 'alan.doe@gmail.com',
                      hintStyle: TextStyle(
                        fontSize: HINTTEXT,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    name: 'email',
                    initialValue: "user@hmail.com",
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
                    initialValue: "12345678",
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
                    initialValue: "12345678",
                    obscureText: true,
                    obscuringCharacter: '*',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),
                ],
              )),
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
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              _Register(_formKey.currentState!.value);
            }
          },
          label: const Text('Register'),
          foregroundColor: Colors.white,
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
      'userGroup': 'PRO',
      'group': widget.ProType,
    };
    //print(userData);
    var res = await AuthenticationService().Register(userData);
    print(res);

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
      //widget.reloadCallBack();
      //Navigator.pop(context);
      // context.read<AppProvider>().logout();
      // Navigator.push(
      //     context, CupertinoPageRoute(builder: (context) => KLogin()));

      AppMessage.ShowInfo(res['message'], context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      AppMessage.ShowInfo(res.message, context);
      setState(() {
        isLoading = false;
      });
    }
  }
}
