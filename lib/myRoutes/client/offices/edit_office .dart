import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/ClientOffice.dart';
import 'package:adlitem_flutter/models/Fixed.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/clientServices/OfficeService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class EditOffice extends StatefulWidget {
  const EditOffice({Key? key, required this.office}) : super(key: key);
  final office;
  @override
  _EditOfficeState createState() => _EditOfficeState();
}

class _EditOfficeState extends State<EditOffice> {
  @override
  void initState() {
    //print(widget.office);
    super.initState();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  var itemListCity = <DropdownMenuItem>[];
  var itemListCounty = <DropdownMenuItem>[];
  var offices = Map();
  var user = SystemAccount();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: !isLoading
            ? FloatingActionButton.extended(
                onPressed: () => {
                  if (_formKey.currentState!.saveAndValidate())
                    {
                      update(_formKey.currentState!.value),
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
          title: const Text('Edit Office'),
        ),
        body: Stack(
          children: [
            NewOffice(),
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

  //Metodos
  update(data) async {
    setState(() {
      isLoading = true;
    });
    var d = context.read<AppProvider>().getLoggedUser();
    ClientOffice office = new ClientOffice(
        clientId: d.systemaccountId,
        clientOfficeId: data['clientOfficeId'],
        city: data['city'].city,
        county: data['county'].county,
        latitude: 0,
        longitude: 0,
        address: data['address'],
        officeName: data['name']);

    var res = await OfficeService().Update(office);
    //print(res);
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
      //readListOffices();
      AppMessage.ShowInfo(res['message'], context);
    } else {
      //AppMessage.ShowInfo(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
    Navigator.pop(context, true);
  }

  NewOffice() {
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
              FormBuilderTextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Office Name',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    BootstrapIcons.map,
                    size: LABELTEXT,
                    color: Colors.grey,
                  ),
                  hintText: 'Doral CourtHouse',
                  hintStyle: TextStyle(
                    fontSize: HINTTEXT,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                name: 'name',
                initialValue: widget.office['placeName'].toString(),
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
                  labelText: 'Office Address',
                  labelStyle: TextStyle(fontSize: LABELTEXT),
                  suffixIcon: Icon(
                    Icons.location_city,
                    size: LABELTEXT,
                    color: Colors.grey,
                  ),
                  hintText: 'Ex: 3550 Hollywood, FL 33021, USA',
                  hintStyle: TextStyle(
                    fontSize: HINTTEXT,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                name: 'address',
                initialValue: widget.office['placeAddress'].toString(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
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
            ]),
          )),
    );
  }

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
}
