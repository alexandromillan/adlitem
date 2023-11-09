import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  var userData = {
    'systemaccountId': 0,
    'name': "",
    'lastname': "",
    'email': "",
    'phone': "",
    'mobile': "",
    'address': "",
    'zip': "",
    'website': "",
    'fax': "",
  };
  @override
  void initState() {
    loadUserdata();
    super.initState();
  }

  void loadUserdata() async {
    var u = context.read<AppProvider>().getLoggedUser();
    var res =
        await SystemAccountService().getSystemAccountById(u.systemaccountId);
    // print(res);

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
      if (mounted)
        setState(() {
          isLoading = false;
          userData = {
            'systemaccountId': u.systemaccountId,
            'name': res['message']['name'],
            'lastname': res['message']['lastname'],
            'email': res['message']['email'],
            'phone':
                res['message']['phone'] != null ? res['message']['phone'] : "",
            'mobile': res['message']['mobile'] != null
                ? res['message']['mobile']
                : "",
            'address': res['message']['address'] != null
                ? res['message']['address']
                : "",
            'zip': res['message']['zip'] != null ? res['message']['zip'] : "",
            'website': res['message']['website'] != null
                ? res['message']['website']
                : "",
            'fax': res['message']['fax'] != null ? res['message']['fax'] : "",
          };
          _formKey.currentState?.patchValue(userData);
        });
    } else {
      //AppMessage.ShowInfo(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateProfile(data) async {
    var u = context.read<AppProvider>().getLoggedUser();
    setState(() {
      isLoading = true;
    });

    var userData = {
      'systemaccountId': u.systemaccountId,
      'name': data['name'],
      'lastname': data['lastname'],
      'email': data['email'],
      'phone': data['phone'],
      'mobile': data['mobile'],
      'address': data['address'],
      'zip': data['zip'],
      'website': data['website'],
      'fax': data['fax'],
    };

    //print(userData);

    var res = await SystemAccountService().updateUser(userData);
    //print(res);
    if (res['message']['changedRows'] == 1) {
      AppMessage.ShowInfo("Data has been updated", context);
      var resp =
          await SystemAccountService().getSystemAccountById(u.systemaccountId);
      //context.read<AppProvider>().setProfile(resp['message']);
    } else {
      AppMessage.ShowInfo("No Data has been updated", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.saveAndValidate()) {
            updateProfile(_formKey.currentState!.value);
          }
        },
        label: Text("Update"),
        icon: Icon(Icons.check),
        backgroundColor: APP_COLORS.Primary,
      ),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
          child: FormBuilder(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Your Name',
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
                initialValue: userData['name'].toString(),
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
                  labelText: 'Your Last Name',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    BootstrapIcons.person_circle,
                    size: LABELTEXT,
                    color: Colors.grey,
                  ),
                  hintText: 'Knight Pol',
                  hintStyle: TextStyle(
                    fontSize: HINTTEXT,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                name: 'lastname',
                initialValue: "",
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
                  hintText: 'alandoe@gmail.com',
                  hintStyle: TextStyle(
                    fontSize: HINTTEXT,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                name: 'email',
                initialValue: "",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.email(),
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    Icons.phone,
                    size: LABELTEXT,
                    color: Colors.grey,
                  ),
                  hintText: '+1-458-5236',
                  hintStyle: TextStyle(
                    fontSize: HINTTEXT,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                name: 'phone',
                initialValue: "",
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Mobile',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    BootstrapIcons.phone,
                    size: LABELTEXT,
                    color: Colors.grey,
                  ),
                  hintText: '+1-5586-4242',
                  hintStyle: TextStyle(
                    fontSize: HINTTEXT,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                name: 'mobile',
                initialValue: "",
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Address',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    BootstrapIcons.geo_alt_fill,
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
                name: 'address',
                initialValue: "",
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Zip code',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    Icons.email,
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
                name: 'zip',
                initialValue: "",
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Web Site',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    BootstrapIcons.globe,
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
                name: 'website',
                initialValue: "",
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Fax',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    Icons.fax,
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
                name: 'fax',
                initialValue: "",
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
