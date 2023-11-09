import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/ClientOffice.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/client/offices/create_office.dart';
import 'package:adlitem_flutter/myRoutes/client/offices/edit_office%20.dart';
import 'package:adlitem_flutter/myRoutes/client/offices/find_offices.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/clientServices/OfficeService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfficesList extends StatefulWidget {
  const OfficesList({Key? key}) : super(key: key);

  @override
  _OfficesListState createState() => _OfficesListState();
}

class _OfficesListState extends State<OfficesList> {
  // final _formKey = GlobalKey<FormBuilderState>();
  var itemListCity = <DropdownMenuItem>[];
  var itemListCounty = <DropdownMenuItem>[];
  var offices = Map();
  var user = SystemAccount();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    readListOffices();
  }

  void _ReloadCallBack() {
    readListOffices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Buttons(),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search_sharp),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => FindOffices()));
              },
            ),
          ],
          title: const Text('My Offices'),
        ),
        body: Stack(alignment: FractionalOffset.center, children: [
          Container(
              padding: EdgeInsets.all(2),
              child: ListView.builder(
                  itemCount: (offices['data'] != null)
                      ? offices['data'].length
                      : 0, //offices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Card(
                          color: Colors.white70,
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50))),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 3,
                          child: InkWell(
                            splashColor: Colors.red.withAlpha(30),
                            onTap: () {
                              _showOfficeDetail(offices['data'][index]);
                            },
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            APP_COLORS.Primary),
                                                    child: IconButton(
                                                        color: Colors.black26,
                                                        onPressed: () {
                                                          //showAlertDialog(context);
                                                        },
                                                        icon: Icon(
                                                          BootstrapIcons
                                                              .building,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ))),
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Badge(
                                                          textColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              APP_COLORS
                                                                  .Primary,
                                                          label: Text(
                                                            offices['data']
                                                                        [index][
                                                                    'placeName']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          largeSize: 20,
                                                        ),
                                                        Text(
                                                          offices['data'][index]
                                                                  [
                                                                  'placeAddress']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: APP_COLORS
                                                                  .Primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    )),
                                              ]),
                                        ])),
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
        ]));
  }

  readListOffices() async {
    setState(() {
      isLoading = true;
    });
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
    Map _offices = await OfficeService().GetbyUser(u);
    if (this.mounted) {
      setState(() {
        offices = _offices;
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  save(data) async {
    setState(() {
      isLoading = true;
    });
    var d = context.read<AppProvider>().getLoggedUser();
    ClientOffice office = new ClientOffice(
        clientOfficeId: 0,
        clientId: d.systemaccountId,
        city: data['city'].city,
        county: data['county'].county,
        latitude: 0,
        longitude: 0,
        address: data['address'],
        officeName: data['name']);

    Navigator.pop(context);
    var res = await OfficeService().Create(office);
    if (res['success'] == -1) {
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
      AppMessage.ShowInfo(res['message'], context);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  SelectOffices() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        // backgroundColor: Colors.transparent,
        actions: [],
        title: Text("Select from existing offices"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [],
      ),
    );
  }

  Widget Buttons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FloatingActionButton.small(
            onPressed: () => {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        CreateOffice(reloadCallBack: _ReloadCallBack)),
              )
            },
            child: Icon(Icons.add),
            backgroundColor: APP_COLORS.Primary,
          ),
          // FloatingActionButton.small(
          //   onPressed: () => {_showSelectOfficeDialog()},
          //   child: Icon(Icons.search),
          //   backgroundColor: Colors.green,
          // ),
        ],
      ),
    );
  }

  void _showOfficeDetail(item) {
    //print(item);
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      isScrollControlled: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.all(10),
        backgroundColor: Colors.white,
        elevation: 0,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(children: [
            Row(children: [
              IconButton(
                  color: Colors.black26,
                  onPressed: () {
                    //showAlertDialog(context);
                  },
                  icon: Icon(
                    BootstrapIcons.building_fill,
                    color: Colors.amber,
                    size: 40,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Office: ",
                    style: TextStyle(
                        fontSize: 20,
                        color: APP_COLORS.Primary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    item['city'].toString() + " / " + item['county'].toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ]),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  item['placeName'].toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: APP_COLORS.Primary,
                      fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  item['placeAddress'].toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                          showConfirmDialog(item);
                        },
                        icon: Icon(
                          BootstrapIcons.trash,
                          color: Colors.red,
                          size: 30,
                        )),
                    IconButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => EditOffice(office: item)),
                          );
                          //Navigator.pop(context);
                        },
                        icon: Icon(
                          BootstrapIcons.pencil_square,
                          color: APP_COLORS.Primary,
                          size: 30,
                        ))
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
      //barrierColor: BARRIERCOLOR,
    );
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
        Map res = await OfficeService().DeleteOffice(item['clientOfficeId']);

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
          readListOffices();
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
        "Really want to delete: " + item['placeName'].toString() + "?",
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
