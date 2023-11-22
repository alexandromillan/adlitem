import 'package:adlitem_flutter/constants/colors.dart';


import 'package:adlitem_flutter/helpers/AppMessage.dart';


import 'package:adlitem_flutter/models/Fixed.dart';


import 'package:adlitem_flutter/models/ProviderRate.dart';


import 'package:adlitem_flutter/models/systemAccount.dart';


import 'package:adlitem_flutter/providers/AppProvider.dart';


import 'package:adlitem_flutter/services/providerServices/ActivityRatesService.dart';


import 'package:bootstrap_icons/bootstrap_icons.dart';


import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';


import 'package:flutter_form_builder/flutter_form_builder.dart';


import 'package:form_builder_validators/form_builder_validators.dart';


import 'package:intl/intl.dart';


import 'package:provider/provider.dart';


class ProcedingCover extends StatefulWidget {

  const ProcedingCover({Key? key}) : super(key: key);


  @override

  _ProcedingCoverState createState() => _ProcedingCoverState();

}


class _ProcedingCoverState extends State<ProcedingCover> {

  var rates = Map();


  var user = SystemAccount();


  bool isLoading = false;


  @override

  void initState() {

    readList();


    super.initState();

  }


  void _ReloadCallBack() {

    readList();

  }


  final formatCurrency = new NumberFormat.simpleCurrency();


  @override

  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          title: Text(

            "Activities & Rates",

            style: TextStyle(

                color: APP_COLORS.Primary,

                fontWeight: FontWeight.bold,

                fontSize: 18),

          ),

          centerTitle: true,

          automaticallyImplyLeading: false,

          backgroundColor: Colors.white,

        ),

        body: Stack(alignment: FractionalOffset.center, children: [

          Container(

              child: ListView.builder(

                  itemCount: (rates['data'] != null)

                      ? rates['data'].length

                      : 0, //offices.length,


                  itemBuilder: (BuildContext context, int index) {

                    return new Container(

                        margin: EdgeInsets.all(0),

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

                              //_showDetail(rates['data'][index]);

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

                                            MainAxisAlignment.spaceAround,

                                        mainAxisSize: MainAxisSize.max,

                                        children: [

                                          IconButton(

                                              color: Colors.black26,

                                              onPressed: () {

                                                //showAlertDialog(context);

                                              },

                                              icon: Icon(

                                                Icons.gavel,

                                                color: Colors.brown,

                                                size: 30,

                                              )),

                                          Column(

                                            crossAxisAlignment:

                                                CrossAxisAlignment.start,

                                            children: [

                                              Text(

                                                softWrap: true,

                                                overflow: TextOverflow.fade,

                                                maxLines: 2,

                                                textAlign: TextAlign.center,

                                                rates['data'][index]['activity']

                                                    .toString(),

                                                style: TextStyle(

                                                    fontSize: 12,

                                                    color: APP_COLORS.Primary,

                                                    fontWeight:

                                                        FontWeight.w600),

                                              ),

                                              Text(

                                                '${formatCurrency.format(double.parse(rates['data'][index]['price'].toString()))}',

                                                style: TextStyle(

                                                    fontSize: 12,

                                                    color: APP_COLORS.Primary,

                                                    fontWeight:

                                                        FontWeight.w600),

                                              ),

                                            ],

                                          ),

                                        ]),

                                    Row(

                                      mainAxisAlignment:

                                          MainAxisAlignment.spaceAround,

                                      children: [

                                        IconButton(

                                            color: Colors.redAccent,

                                            iconSize: 20,

                                            onPressed: () {},

                                            icon: Icon(

                                                BootstrapIcons.pencil_fill)),

                                        IconButton(

                                            color: Colors.redAccent,

                                            iconSize: 20,

                                            onPressed: () {

                                              showConfirmDialog(

                                                  rates['data'][index]);

                                            },

                                            icon: Icon(BootstrapIcons.trash)),

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

                          child: FormActivity(reloadCallBack: _ReloadCallBack)),

                      barrierDismissible: true,

                      barrierColor: BARRIERCOLOR),

                },

            child: Center(

              child: Icon(

                BootstrapIcons.plus,

                size: 30,

                color: Colors.white,

              ),

            )));

  }


  readList() async {

    setState(() {

      isLoading = true;

    });


    SystemAccount u = await context.read<AppProvider>().getLoggedUser();


    Map _rates = await ActivityRateService().GetbyUser(u);


    if (this.mounted) {

      setState(() {

        rates = _rates;

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


        Map res = await ActivityRateService().Delete(item['procedingcoverId']);


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

        "Really want to delete: " + item['activity'].toString() + "?",

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


class FormActivity extends StatefulWidget {

  FormActivity({Key? key, required this.reloadCallBack}) : super(key: key);


  final reloadCallBack;


  @override

  _FormActivityState createState() => _FormActivityState();

}


class _FormActivityState extends State<FormActivity> {

  final _formKey = GlobalKey<FormBuilderState>();


  DateTime expirationDate = DateTime.now();


  var itemList = <DropdownMenuItem>[];


  bool isLoading = false;


  @override

  Widget build(BuildContext context) {

    if (itemList.length <= 0) {

      ProviderActivitiesModel.getActivities().forEach((e) {

        itemList.add(DropdownMenuItem(

          value: e,

          child: itemActivity(e),

        ));

      });

    }


    return Scaffold(

      appBar: AppBar(
        title: Text("Add Activity Rate"),
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

                  FormBuilderDropdown(

                    name: 'activity',

                    decoration: InputDecoration(

                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      labelText: 'Activities',

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

                  FormBuilderTextField(

                    decoration: InputDecoration(

                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      labelText: 'Rate',

                      labelStyle: TextStyle(fontSize: 15),

                      prefixIcon: Icon(

                        BootstrapIcons.currency_dollar,

                        size: 18,

                        color: Colors.grey,

                      ),

                      hintText: '200.00',

                      hintStyle: TextStyle(

                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Colors.grey,

                      ),

                    ),

                    name: 'price',

                    keyboardType: TextInputType.number,

                    validator: FormBuilderValidators.compose([

                      FormBuilderValidators.required(),

                    ]),

                  ),

                  SizedBox(

                    height: 10,

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

            'Create',

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


    ProviderActivityRate rate = new ProviderActivityRate(

        procedingcoverId: 0,

        activity: data['activity'].name,

        activityId: data['activity'].id,

        price: double.parse(data['price']),

        systemaccountId: d.systemaccountId);


    var res = await ActivityRateService().Create(rate);


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


Widget itemActivity(item) {

  return Container(

    child: Row(

      children: [

        Text(item.name),

      ],

    ),

  );

}

