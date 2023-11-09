import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/ClientOrder.dart';
import 'package:adlitem_flutter/models/Fixed.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/client/offices/create_office.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/NotificationService.dart';
import 'package:adlitem_flutter/services/clientServices/OfficeService.dart';
import 'package:adlitem_flutter/services/clientServices/OrderService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateOrder extends StatefulWidget {
  final reloadCallBack;
  const CreateOrder({Key? key, required this.reloadCallBack}) : super(key: key);

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final _formKey = GlobalKey<FormBuilderState>();
  var itemListCity = <DropdownMenuItem>[];
  var itemListCounty = <DropdownMenuItem>[];
  var itemListActivity = <DropdownMenuItem>[];
  var itemListMode = <DropdownMenuItem>[];
  var itemListOrderTarget = <DropdownMenuItem>[];
  var itemListOffices = <DropdownMenuItem>[];
  var itemListLang = <DropdownMenuItem>[];
  var offices = Map();
  var user = SystemAccount();
  bool isLoading = false;
  var date = DateTime.now();
  double rate = 1;

  @override
  void initState() {
    loadOffices();
    loadActivities();
    loadMode();
    loadLang();
    loadTarget();
    super.initState();
  }

  void _ReloadCallBack() {
    itemListOffices.clear();
    loadOffices();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: !isLoading
            ? FloatingActionButton.extended(
                onPressed: () => {
                  if (_formKey.currentState!.saveAndValidate())
                    {
                      save(_formKey.currentState!.value),
                    }
                },
                autofocus: true,
                //focusColor: Colors.red,
                label: Text("Save"),
                icon: Icon(Icons.check),
                // child: Icon(Icons.check),
                elevation: 0,
                backgroundColor: APP_COLORS.Primary,
              )
            : FloatingActionButton.extended(
                onPressed: () => {},
                autofocus: true,
                //focusColor: Colors.red,
                label: Text("Wait..."),
                icon: Icon(BootstrapIcons.clock),
                // child: Icon(Icons.check),
                elevation: 0,
                backgroundColor: APP_COLORS.Primary,
              ),
        appBar: AppBar(
          title: const Text('New Order'),
        ),
        body: Stack(
          children: [
            NewOrder(),
            if (isLoading)
              SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Container(
                      width: size.width,
                      height: size.height,
                      constraints: BoxConstraints.expand(),
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1)),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                APP_COLORS.Primary),
                            backgroundColor: Color.fromARGB(0, 8, 6, 6),
                            semanticsLabel: "Wait...",
                            color: APP_COLORS.Primary,
                          )))),
          ],
        ));
  }

  NewOrder() {
    if (itemListCounty.length <= 0) {
      CountyModel.getCounties().forEach((e) {
        itemListCounty.add(DropdownMenuItem(
          value: e,
          child: itemCounty(e),
        ));
      });
    }

    return SingleChildScrollView(
      child: FormBuilder(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              FormBuilderDropdown(
                name: 'county',
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'County',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Select',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                items: itemListCounty,
                onChanged: (value) => {
                  loadCitiesByCounty(value),
                  //print(itemListCity.length),
                },
                onTap: () => {
                  //itemListCity.clear(),
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDropdown(
                name: 'city',
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'City',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Select',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                items: itemListCity,
                onChanged: (value) => {print(value.city)},
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    FormBuilderDropdown(
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'placeName',
                      isExpanded: false,
                      alignment: Alignment.bottomLeft,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Office',
                        labelStyle: TextStyle(fontSize: 15),
                        hintText: 'Select',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      items: itemListOffices,
                      onChanged: (value) => {print(value)},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    Positioned(
                        left: 25,
                        top: -5,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CreateOffice(
                                          reloadCallBack: _ReloadCallBack,
                                        )),
                              );
                            },
                            child: Icon(Icons.add_circle))),
                  ]),
              SizedBox(
                height: 10,
              ),
              FormBuilderDropdown(
                name: 'activity',
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Activity',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Select',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                items: itemListActivity,
                onChanged: (value) => {},
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
                items: itemListLang,
                onChanged: (value) => {},
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDropdown(
                name: 'mode',
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Service Mode',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Select',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                items: itemListMode,
                onChanged: (value) => {print(value)},
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDropdown(
                name: 'target',
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Order Target',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Select',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                items: itemListOrderTarget,
                onChanged: (value) => {},
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDateTimePicker(
                name: "orderDate",
                currentDate: DateTime.now(),
                format: DateFormat.yMMMEd('en_US'),
                inputType: InputType.date,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: ' Date',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Select',
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
                  // setState(() => this.date = value!),
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDateTimePicker(
                name: "timeStart",
                format: DateFormat.Hms('en_US'),
                inputType: InputType.time,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Start At',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: '08:00',
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
                  // setState(() => this.date = value!),
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDateTimePicker(
                name: "timeEnd",
                format: DateFormat.Hms('en_US'),
                inputType: InputType.time,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Ends At',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: '12:00',
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
                  // setState(() => this.date = value!),
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: "minPrice",
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Min. Price',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: '150.00',
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
                  // setState(() => this.date = value!),
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: "maxPrice",
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Max. Price',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: '200.00',
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
                  // setState(() => this.date = value!),
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Rate: ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal),
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    maxRating: 5,
                    glow: true,
                    glowColor: Colors.blue,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 35,
                    itemCount: 5,
                    wrapAlignment: WrapAlignment.start,
                    itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        this.rate = rating;
                      });
                    },
                  )
                ],
              )
            ]),
          )),
    );
  }

//Methods
  Widget itemCounty(item) {
    return Container(
      child: Row(
        children: [
          Text(item.county),
        ],
      ),
    );
  }

  Widget itemCity(item) {
    return Container(
      child: Row(
        children: [
          Text(item.city),
        ],
      ),
    );
  }

  Widget itemOffice(item) {
    //print(item['placeName']);
    return Container(
      child: Row(
        children: [
          Text(item['placeName']),
        ],
      ),
    );
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

  Widget itemMode(item) {
    return Container(
      child: Row(
        children: [
          Text(item.name),
        ],
      ),
    );
  }

  Widget itemLang(item) {
    return Container(
      child: Row(
        children: [
          Text(item.name),
        ],
      ),
    );
  }

  Widget itemOrderTarget(item) {
    return Container(
      child: Row(
        children: [
          Text(item.name),
        ],
      ),
    );
  }

  loadCitiesByCounty(county) {
    itemListCity.clear();
    try {
      var data = CityModel.getCities()
          .where((element) => element.county == county.county);
      data.forEach((e) {
        if (e.county == county.county) {
          itemListCity.add(DropdownMenuItem(
            value: e,
            child: itemCity(e),
          ));
        }
      });
    } catch (err) {
      AppMessage.ShowError(err, context);
    }
  }

  loadOffices() async {
    try {
      var user = context.read<AppProvider>().getLoggedUser();
      var tempList = <DropdownMenuItem>[];
      Map data = await OfficeService().GetbyUser(user);
      if (data['success'] == 1) {
        data['data'].forEach((e) {
          //print(e);
          // e.map(() => {
          tempList.add(DropdownMenuItem(
            value: e,
            child: itemOffice(e),
          ));
          // });
        });
        if (mounted)
          setState(() {
            itemListOffices = tempList;
          });
      }
    } catch (err) {
      AppMessage.ShowError(err, context);
    }
  }

  loadActivities() {
    try {
      if (itemListActivity.length <= 0) {
        ProviderActivitiesModel.getActivities().forEach((e) {
          //print(e);
          itemListActivity.add(DropdownMenuItem(
            value: e,
            child: itemActivity(e),
          ));
        });
      }
    } catch (err) {
      AppMessage.ShowError(err, context);
    }
  }

  loadMode() {
    try {
      if (itemListMode.length <= 0) {
        ActivityModeModel.getModes().forEach((e) {
          itemListMode.add(DropdownMenuItem(
            value: e,
            child: itemMode(e),
          ));
        });
      }
    } catch (err) {
      AppMessage.ShowError(err, context);
    }
  }

  loadLang() {
    try {
      if (itemListLang.length <= 0) {
        LanguageModel.getLanguages().forEach((e) {
          itemListLang.add(DropdownMenuItem(
            value: e,
            child: itemLang(e),
          ));
        });
      }
    } catch (err) {
      AppMessage.ShowError(err, context);
    }
  }

  loadTarget() {
    try {
      if (itemListOrderTarget.length <= 0) {
        OrderTargetModel.getOrderTaget().forEach((e) {
          itemListOrderTarget.add(DropdownMenuItem(
            value: e,
            child: itemOrderTarget(e),
          ));
        });
      }
    } catch (err) {
      AppMessage.ShowError(err, context);
    }
  }

  save(data) async {
    //print(data['placeName']);
    setState(() {
      isLoading = true;
    });
    var u = context.read<AppProvider>().getLoggedUser();
    ClientOrder o = new ClientOrder(
      clientId: u.systemaccountId,
      cityId: data['city'].id,
      city: data['city'].city,
      countyId: data['county'].id,
      county: data['county'].county,
      languageId: data['language'].id,
      language: data['language'].name,
      languageCode: data['language'].code,
      date: data['orderDate'],
      status: "PENDING",
      placeName: data['placeName']['placeName'],
      address: data['placeName']['placeAddress'],
      activityId: data['activity'].id,
      activity: data['activity'].name,
      latitude: data['placeName']['latitude'],
      longitude: data['placeName']['longitude'],
      mode: data['mode'].name,
      rate: this.rate,
      targetId: data['target'].id,
      target: data['target'].name,
      orderId: 0,
      priceRangeStart: double.parse(data['minPrice']),
      priceRangeEnd: double.parse(data['maxPrice']),
      timeStart: data['timeStart'],
      timeEnd: data['timeEnd'],
    );

    //var str = JSON.encode(dt, toEncodable: myEncode);
    //print(data['city'].id);

    var res = await OrderService().Create(o);
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
      var noti = {
        'systemAccountId': 0,
        'fecha': DateFormat.yMMMd('en_US').format(DateTime.now().toLocal()),
        'origen': "PROVIDER",
        'descripcion': "New job has been added in " + o.city,
        'visible': 1,
      };
      await NotificationService().Create(noti);
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
