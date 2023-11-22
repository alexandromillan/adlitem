import 'package:adlitem_flutter/constants/colors.dart';


import 'package:adlitem_flutter/helpers/AppMessage.dart';


import 'package:adlitem_flutter/models/Fixed.dart';


import 'package:adlitem_flutter/models/ProviderCertification.dart';


import 'package:adlitem_flutter/models/systemAccount.dart';


import 'package:adlitem_flutter/providers/AppProvider.dart';


import 'package:adlitem_flutter/services/providerServices/CertificationService.dart';


import 'package:bootstrap_icons/bootstrap_icons.dart';


import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';


import 'package:flutter_form_builder/flutter_form_builder.dart';


import 'package:form_builder_validators/form_builder_validators.dart';


import 'package:provider/provider.dart';


class Certifications extends StatefulWidget {

  const Certifications({Key? key}) : super(key: key);


  @override

  _CertificationsState createState() => _CertificationsState();

}


class _CertificationsState extends State<Certifications> {

  var list = Map();


  var user = SystemAccount();


  bool isLoading = false;


  void _ReloadCallBack() {

    readList();

  }


  @override

  void initState() {

    readList();


    super.initState();

  }


  void dispose() {

    super.dispose();

  }


  // void _ReloadCallBack() {


  //   readList();


  // }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          title: Text(

            "Certifications",

            style: TextStyle(

                color: APP_COLORS.Primary,

                fontWeight: FontWeight.bold,

                fontSize: 18),

          ),

          centerTitle: true,

          automaticallyImplyLeading: false,

          backgroundColor: Colors.white,

          foregroundColor: Colors.white,

        ),

        body: Stack(alignment: FractionalOffset.center, children: [

          Container(

              padding: EdgeInsets.all(0),

              child: ListView.builder(

                  itemCount: (list['data'] != null)

                      ? list['data'].length

                      : 0, //offices.length,


                  itemBuilder: (BuildContext context, int index) {

                    return new Container(

                        margin: EdgeInsets.all(1),

                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(10)),

                          border: Border.all(

                              color: Color.fromARGB(255, 241, 238, 238),

                              width: 1.0,

                              style: BorderStyle.none),

                        ),

                        child: Card(

                          clipBehavior: Clip.antiAliasWithSaveLayer,

                          elevation: 1,

                          shape: BeveledRectangleBorder(),

                          child: InkWell(

                            splashColor: Colors.red.withAlpha(30),

                            onTap: () {

                              //_showOfficeDetail(offices['data'][index]);

                            },

                            child: Column(

                              children: [

                                Row(

                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  mainAxisAlignment:

                                      MainAxisAlignment.spaceBetween,

                                  mainAxisSize: MainAxisSize.max,

                                  children: [

                                    Row(

                                        crossAxisAlignment:

                                            CrossAxisAlignment.center,

                                        mainAxisAlignment:

                                            MainAxisAlignment.start,

                                        mainAxisSize: MainAxisSize.max,

                                        children: [

                                          Padding(

                                              padding: EdgeInsets.all(0),

                                              child: Icon(

                                                BootstrapIcons.mortarboard_fill,

                                                color: Colors.brown,

                                                size: 40,

                                              )),

                                          SizedBox(

                                            width: 20,

                                          ),

                                          Padding(

                                            padding: EdgeInsets.all(0),

                                            child: Column(

                                              crossAxisAlignment:

                                                  CrossAxisAlignment.start,

                                              children: [

                                                Row(

                                                  children: [

                                                    Text(

                                                        style: TextStyle(

                                                            color: APP_COLORS

                                                                .Primary,

                                                            fontWeight:

                                                                FontWeight.bold,

                                                            fontSize: 13),

                                                        "Designation #: " +

                                                            list['data'][index][

                                                                'certificationNo']),

                                                  ],

                                                ),

                                                Row(

                                                  children: [

                                                    Text(

                                                        style: TextStyle(

                                                            color: APP_COLORS

                                                                .Primary,

                                                            fontWeight:

                                                                FontWeight.bold,

                                                            fontSize: 13),

                                                        "Jurisdiction: " +

                                                            list['data'][index]

                                                                ['type']),

                                                  ],

                                                ),

                                                Row(

                                                  children: [

                                                    SizedBox(

                                                        width: 60,

                                                        height: 40,

                                                        child: Padding(

                                                          padding:

                                                              EdgeInsets.all(5),

                                                          child: Image.asset(

                                                              'assets/images/' +

                                                                  list['data'][

                                                                              index]

                                                                          [

                                                                          'code']

                                                                      .toString()

                                                                      .toUpperCase() +

                                                                  '.png'),

                                                        )),

                                                    Text(

                                                        list['data'][index]

                                                            ['language'],

                                                        style: TextStyle(

                                                            fontWeight:

                                                                FontWeight.bold,

                                                            fontSize: 13)),

                                                  ],

                                                ),

                                              ],

                                            ),

                                          )

                                        ]),

                                    Row(

                                      mainAxisAlignment:

                                          MainAxisAlignment.spaceAround,

                                      mainAxisSize: MainAxisSize.max,

                                      crossAxisAlignment:

                                          CrossAxisAlignment.center,

                                      children: [

                                        IconButton(

                                            color: Colors.red,

                                            iconSize: 22,

                                            onPressed: () {},

                                            icon: Icon(

                                                BootstrapIcons.pencil_fill)),

                                        IconButton(

                                            color: Colors.red,

                                            iconSize: 22,

                                            onPressed: () {

                                              showConfirmDialog(

                                                  list['data'][index]);

                                            },

                                            icon: Icon(BootstrapIcons.trash))

                                      ],

                                    )

                                  ],

                                ),

                              ],

                            ),

                          ),

                        ));

                  })),

          if (isLoading)

            Container(

                constraints: BoxConstraints.expand(),

                alignment: Alignment.center,

                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1)),

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

        floatingActionButton: FloatingActionButton.small(

            backgroundColor: APP_COLORS.Primary,

            onPressed: () => {

                  showCupertinoModalPopup(

                      context: context,

                      builder: (BuildContext context) => Dialog(

                          child: FormCertification(

                              reloadCallBack: _ReloadCallBack)),

                      barrierDismissible: true,

                      barrierColor: BARRIERCOLOR),

                },

            child: Center(

              child: Icon(

                BootstrapIcons.plus,

                size: 30,

                color: WHITE,

              ),

            )));

  }


  readList() async {

    setState(() {

      isLoading = true;

    });


    SystemAccount u = await context.read<AppProvider>().getLoggedUser();


    Map _list = await CertificationService().GetbyUser(u);


    if (this.mounted) {

      setState(() {

        list = _list;

      });


      setState(() {

        isLoading = false;

      });

    }

  }


  showConfirmDialog(item) {

    // set up the buttons


    Widget cancelButton = OutlinedButton(

      child: Text("Cancel"),

      onPressed: () {

        Navigator.pop(context);

      },

    );


    Widget continueButton = OutlinedButton.icon(

      label: Text("Confirm"),


      icon: Icon(BootstrapIcons.trash),


      //child: Text("Confirm"),


      onPressed: () async {

        setState(() {

          isLoading = true;

        });


        Navigator.pop(context);


        Map res = await CertificationService().Delete(item['certificationId']);


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


          //_formKey.currentState!.reset();


          readList();


          AppMessage.ShowInfo(res['message'], context);

        } else {

          //AppMessage.ShowInfo(res['message'], context);


          setState(() {

            isLoading = false;

          });

        }

      },

    ); // set up the AlertDialog


    AlertDialog alert = AlertDialog(

      title: Text("Confirm delete"),

      content: Text(

        "Really want to delete: " + item['certificationNo'].toString() + "?",

        style: TextStyle(fontWeight: FontWeight.bold),

      ),

      actions: [

        cancelButton,

        continueButton,

      ],

    ); // show the dialog


    showDialog(

      context: context,

      barrierDismissible: false,

      builder: (BuildContext context) {

        return alert;

      },

    );

  }

}


class FormCertification extends StatefulWidget {

  FormCertification({Key? key, required this.reloadCallBack}) : super(key: key);


  final reloadCallBack;


  @override

  _FormCertificationState createState() => _FormCertificationState();

}


class _FormCertificationState extends State<FormCertification> {

  final _formKey = GlobalKey<FormBuilderState>();


  DateTime expirationDate = DateTime.now();


  var itemList = <DropdownMenuItem>[];


  var itemListJur = <DropdownMenuItem>[];


  bool isLoading = false;


  @override

  Widget build(BuildContext context) {

    if (itemList.length <= 0) {

      LanguageModel.getLanguages().forEach((e) {

        itemList.add(DropdownMenuItem(

          value: e,

          child: itemLang(e),

        ));

      });

    }


    if (itemListJur.length <= 0) {

      JurisdictionModel.getJuristictions().forEach((e) {

        itemListJur.add(DropdownMenuItem(

          value: e,

          child: itemJur(e),

        ));

      });

    }


    return Scaffold(

      appBar: AppBar(
        title: Text("Add Certification"),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        child: FormBuilder(

          key: _formKey,

          child: Container(

              padding: EdgeInsets.all(20),

              child: Column(

                mainAxisSize: MainAxisSize.max,

                children: [

                  FormBuilderTextField(

                    decoration: InputDecoration(

                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      labelText: 'Designation Number',

                      labelStyle: TextStyle(fontSize: 15),

                      suffixIcon: Icon(

                        BootstrapIcons.hash,

                        size: 18,

                        color: Colors.grey,

                      ),

                      hintText: 'Ex: 0001-2222-5555',

                      hintStyle: TextStyle(

                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Colors.grey,

                      ),

                    ),

                    name: 'certificationNo',

                    validator: FormBuilderValidators.compose([

                      FormBuilderValidators.required(),

                    ]),

                  ),

                  SizedBox(

                    height: 10,

                  ),

                  FormBuilderDropdown(

                    name: 'language',

                    decoration: InputDecoration(

                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      labelText: 'Language',

                      labelStyle: TextStyle(fontSize: 15),

                      hintText: 'Select',

                      hintStyle: TextStyle(

                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Colors.grey,

                      ),

                    ),

                    items: itemList,

                    onChanged: (value) => {print(value.name)},

                    validator: FormBuilderValidators.compose([

                      FormBuilderValidators.required(),

                    ]),

                  ),

                  SizedBox(

                    height: 10,

                  ),

                  FormBuilderDropdown(

                    name: 'type',

                    decoration: InputDecoration(

                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      labelText: 'Jurisdiction',

                      labelStyle: TextStyle(fontSize: 15),

                      hintText: 'Select',

                      hintStyle: TextStyle(

                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Colors.grey,

                      ),

                    ),

                    items: itemListJur,

                    onChanged: (value) => {print(value.name)},

                    validator: FormBuilderValidators.compose([

                      FormBuilderValidators.required(),

                    ]),

                  ),

                  SizedBox(

                    height: 10,

                  ),

                  FormBuilderDateTimePicker(

                    name: "expiration",

                    currentDate: DateTime.now(),

                    inputType: InputType.date,

                    decoration: InputDecoration(

                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      labelText: 'Expiration Date',

                      labelStyle: TextStyle(fontSize: 15),

                      suffixIcon: Icon(

                        BootstrapIcons.calendar,

                        size: 18,

                        color: Colors.grey,

                      ),

                      hintText: '01/01/2000',

                      hintStyle: TextStyle(

                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Colors.grey,

                      ),

                    ),

                    style: TextStyle(

                        color: Colors.black,

                        fontSize: 16.0,

                        fontWeight: FontWeight.normal),

                    onChanged: (value) => {

                      setState(() => this.expirationDate = value!),

                    },

                    validator: FormBuilderValidators.compose([

                      FormBuilderValidators.required(),

                    ]),

                  ),

                ],

              )),

        ),

      ),

      floatingActionButton: FloatingActionButton.extended(

          onPressed: () {

            if (_formKey.currentState!.saveAndValidate()) {

              save(_formKey.currentState!.value);

            }

          },

          label: const Text(

            'Add',

            style: TextStyle(color: Colors.white),

          ),

          icon: const Icon(

            Icons.check,

            color: Colors.white,

          ),

          backgroundColor: APP_COLORS.Primary),

    );

  }


  save(data) async {

    setState(() {

      isLoading = true;

    });


    var d = context.read<AppProvider>().getLoggedUser();


    ProviderCertification office = new ProviderCertification(

        certificationId: 0,

        systemaccountId: d.systemaccountId,

        certificationNo: data['certificationNo'],

        code: data['language'].code,

        language: data['language'].name,

        expiration: data['expiration'],

        expirationRegister: data['expiration'],

        type: data['type'].name);


    var res = await CertificationService().Create(office);


    //print(res['success']);


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


      //_formKey.currentState!.reset();


      widget.reloadCallBack();


      AppMessage.ShowInfo(res['message'], context);

    } else {

      //AppMessage.ShowInfo(res['message'], context);


      setState(() {

        isLoading = false;

      });

    }


    Navigator.pop(context, true);

  }

}


Widget itemLang(item) {

  //print(item);


  return Container(

    child: Row(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        SizedBox(

          width: 100,

          height: 60,

          child: Image.asset(

              'assets/images/' + item.code.toString().toUpperCase() + '.png'),

        ),

        Text(item.name),

      ],

    ),

  );

}


Widget itemJur(item) {

  return Container(

    child: Row(

      children: [

        Text(item.name),

      ],

    ),

  );

}

