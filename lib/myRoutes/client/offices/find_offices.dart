import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/ClientOffice.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/clientServices/OfficeService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindOffices extends StatefulWidget {
  const FindOffices({Key? key}) : super(key: key);

  @override
  _FindOfficesState createState() => _FindOfficesState();
}

class _FindOfficesState extends State<FindOffices> {
  var offices = Map();
  bool isLoading = false;

  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    readListOffices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Find and use existing offices'),
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
                                                                  ['city']
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
                FloatingActionButton.extended(
                    onPressed: () async {
                      SystemAccount user =
                          await context.read<AppProvider>().getLoggedUser();
                      var or = new ClientOfficeRelation(
                          idRelation: 0,
                          clientId: user.systemaccountId,
                          officeId: item['clientOfficeId']);
                      var res = await OfficeService().CreateRelation(or);
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
                        //widget.reloadCallBack();
                        AppMessage.ShowInfo(res['message'], context);
                      } else {
                        //AppMessage.ShowInfo(res['message'], context);
                        setState(() {
                          isLoading = false;
                        });
                      }
                      readListOffices();
                      Navigator.pop(context, true);
                    },
                    label: Text("Add to my offices list"))
              ],
            ),
          ]),
        ),
      ),
      //barrierColor: BARRIERCOLOR,
    );
  }

/*
 var data = CityModel.getCities()
          .where((element) => element.county == county.county);
 */
  readListOffices() async {
    setState(() {
      isLoading = true;
    });
    SystemAccount user = await context.read<AppProvider>().getLoggedUser();
    Map _offices = await OfficeService().GetAllNotUsedByUser(user);
    if (this.mounted) {
      setState(() {
        offices = _offices;
      });
      setState(() {
        isLoading = false;
      });
    }
  }
}
