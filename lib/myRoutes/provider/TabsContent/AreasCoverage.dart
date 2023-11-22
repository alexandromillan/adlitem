import 'package:adlitem_flutter/constants/colors.dart';


import 'package:adlitem_flutter/helpers/AppMessage.dart';


import 'package:adlitem_flutter/models/Fixed.dart';


import 'package:adlitem_flutter/models/ProviderAreaCoverage.dart';


import 'package:adlitem_flutter/models/systemAccount.dart';


import 'package:adlitem_flutter/providers/AppProvider.dart';


import 'package:adlitem_flutter/services/providerServices/AreasCoverageService.dart';


import 'package:flutter/material.dart';


import 'package:provider/provider.dart';


class AreasCoverage extends StatefulWidget {

  const AreasCoverage({Key? key}) : super(key: key);


  @override

  _AreasCoverageState createState() => _AreasCoverageState();

}


class _AreasCoverageState extends State<AreasCoverage> {

  List<CityModel> checkBoxListTileModel = CityModel.getCities();


  var list = <ProviderAreaCoverage>[];


  SystemAccount u = SystemAccount();


  var selAreas = [];


  bool isLoading = false;


  @override

  void initState() {

    u = context.read<AppProvider>().getLoggedUser();


    readSelAreas();


    super.initState();

  }


  void dispose() {

    super.dispose();

  }


  readSelAreas() async {

    setState(() {

      isLoading = true;

    });


    try {

      Map _listUser = await AreasCoverageService().GetbyUser(u);


      if (_listUser['success'] <= 0) {

        setState(() {

          isLoading = false;

        });


        return;

      }


      if (mounted)

        setState(() {

          selAreas = _listUser['data'];

        });


      list = [];


      for (int i = 0; i < selAreas.length; i++) {

        for (int j = 0; j < checkBoxListTileModel.length; j++) {

          if (checkBoxListTileModel[j].id == selAreas[i]['markerId']) {

            checkBoxListTileModel[j].selected = true;


            list.add(ProviderAreaCoverage(

                systemaccountId: u.systemaccountId,

                areascoverageId: selAreas[i]['areascoverageId'],

                active: selAreas[i]['active'] == 0 ? false : true,

                markerId: selAreas[i]['markerId'],

                city: selAreas[i]['city'],

                county: selAreas[i]['county'],

                state: selAreas[i]['state'],

                latitude: selAreas[i]['latitude'],

                longitude: selAreas[i]['longitude'],

                selected: selAreas[i]['selected'] == 0 ? false : true));

          }

        }

      }


      if (mounted)

        setState(() {

          isLoading = false;

        });

    } catch (e) {

      AppMessage.ShowError(e, context);

    }

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(

        onPressed: () {

          save();

        },

        label: Text(
          "Save",
          style: TextStyle(color: Colors.white),
        ),

        icon: Icon(

          Icons.check,

          color: Colors.white,

        ),

        backgroundColor: APP_COLORS.Primary,

      ),

      appBar: AppBar(

        title: Text(

          "Areas of Coverage",

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

                itemCount: checkBoxListTileModel.length,

                itemBuilder: (BuildContext context, int index) {

                  return new Container(

                    margin: EdgeInsets.all(3),

                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(5)),

                      border: Border.all(

                          color: Color.fromARGB(255, 241, 238, 238),

                          width: 3.0,

                          style: BorderStyle.solid),

                    ),

                    child: Column(children: <Widget>[

                      new CheckboxListTile(

                        checkboxShape: CircleBorder(side: BorderSide.none),


                        //tileColor: Colors.blue[100],


                        activeColor: Color.fromARGB(255, 76, 9, 139),


                        dense: true,


                        //font change


                        title: new Text(

                          checkBoxListTileModel[index].city,

                          style: TextStyle(

                              fontSize: 14,

                              fontWeight: FontWeight.w600,

                              letterSpacing: 0.5),

                        ),


                        value: checkBoxListTileModel[index].selected,


                        secondary: Container(

                          height: 50,

                          width: 50,

                          child: Icon(Icons.map),

                        ),


                        onChanged: (bool? value) {

                          itemChange(value, index);

                        },

                      )

                    ]),

                  );

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

    );

  }


  save() async {

    setState(() {

      isLoading = true;

    });


    var jsonList = [];


    var jsonArea = {};


    for (int i = 0; i < list.length; i++) {

      jsonArea = {

        'areascoverageId': list[i].areascoverageId,

        'systemaccountId': list[i].systemaccountId,

        'active': false,

        'markerId': list[i].markerId,

        'city': list[i].city,

        'county': list[i].county,

        'state': list[i].state,

        'latitude': list[i].latitude,

        'longitude': list[i].longitude,

        'selected': list[i].selected,

      };


      jsonList.add(jsonArea);

    }


    var _data = {"areas": jsonList, "systemaccountId": u.systemaccountId};


    if (list.length <= 0) {

      AppMessage.ShowInfo("Select languages", context);


      return;

    }


    var res = await AreasCoverageService().Create(_data);


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

  }


  void itemChange(bool? val, int index) {

    setState(() {

      checkBoxListTileModel[index].selected = val!;

    });


    ProviderAreaCoverage item = new ProviderAreaCoverage(

      systemaccountId: this.u.systemaccountId,

      areascoverageId: checkBoxListTileModel[index].id,

      active: false,

      markerId: checkBoxListTileModel[index].id,

      city: checkBoxListTileModel[index].city,

      county: checkBoxListTileModel[index].county,

      state: checkBoxListTileModel[index].state,

      latitude: checkBoxListTileModel[index].latitude,

      longitude: checkBoxListTileModel[index].longitude,

      selected: checkBoxListTileModel[index].selected,

    );


    if (val == true) {

      list.add(item);

    } else {

      list.removeWhere(

        (e) => e.markerId == item.markerId,

      );

    }

  }

}

