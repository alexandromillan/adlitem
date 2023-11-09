import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/provider/TabsContent/rates_requirements/Requirements.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/providerServices/RequirementsService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListRequirements extends StatefulWidget {
  const ListRequirements({Key? key}) : super(key: key);

  @override
  _ListRequirementsState createState() => _ListRequirementsState();
}

class _ListRequirementsState extends State<ListRequirements> {
  int day = 0;
  String dayName = "";
  bool isLoading = false;
  var ListSchDay = null;
  var user = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => Requirements()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            "Requirements",
            style: TextStyle(
                color: APP_COLORS.Primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: Stack(children: [
          InkWell(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                  border: Border.all(
                      color: Color.fromARGB(255, 241, 238, 238),
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2_check_fill),
                    dense: false,
                    //minLeadingWidth: 3,
                    iconColor: APP_COLORS.Primary,
                    title: Text("Monday"),
                    //subtitle: Text("Set the user info"),
                    isThreeLine: false,
                    selected: false,
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      setState(() {
                        day = 1;
                        dayName = "Monday";
                      });
                      showDialogSchedule();
                    },
                  ),
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2_check_fill),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: APP_COLORS.Primary,
                    title: Text("Tuesday"),
                    // subtitle: Text("Reset your password"),
                    onTap: () {
                      setState(() {
                        day = 2;
                        dayName = "Tuesday";
                      });
                      showDialogSchedule();
                    },
                  ),
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2_check_fill),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: APP_COLORS.Primary,
                    title: Text("Wednesday"),
                    // subtitle: Text("Reset your password"),
                    onTap: () {
                      setState(() {
                        day = 3;
                        dayName = "Wednesday";
                      });
                      showDialogSchedule();
                    },
                  ),
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2_check_fill),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: APP_COLORS.Primary,
                    title: Text("Thursday"),
                    // subtitle: Text("Reset your password"),
                    onTap: () {
                      setState(() {
                        dayName = "Thursday";
                        day = 4;
                      });
                      showDialogSchedule();
                    },
                  ),
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2_check_fill),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: APP_COLORS.Primary,
                    title: Text("Friday"),
                    // subtitle: Text("Reset your password"),
                    onTap: () {
                      setState(() {
                        dayName = "Friday";
                        day = 5;
                      });
                      showDialogSchedule();
                    },
                  ),
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2_check_fill),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: APP_COLORS.Primary,
                    title: Text("Saturday"),
                    // subtitle: Text("Reset your password"),
                    onTap: () {
                      setState(() {
                        dayName = "Saturday";
                        day = 6;
                      });
                      showDialogSchedule();
                    },
                  ),
                  ListTile(
                    leading: Icon(BootstrapIcons.calendar2),
                    trailing: Icon(Icons.arrow_forward_ios),
                    iconColor: APP_COLORS.Primary,
                    title: Text("Sunday"),
                    // subtitle: Text("Reset your password"),
                    onTap: () {
                      setState(() {
                        dayName = "Sunday";
                        day = 7;
                      });
                      showDialogSchedule();
                    },
                  )
                ]),
              ),
            ],
          ))
        ]));
  }

  ReadScheduleDay() async {
    var u = await context.read<AppProvider>().getLoggedUser();
    var data = await RequirementsService().GetbyUser(u);
    setState(() {
      user = u;
      ListSchDay = data;
    });
  }

  showDialogSchedule() async {
    setState(() {
      isLoading = true;
    });
    await ReadScheduleDay();
    setState(() {
      isLoading = false;
    });

    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      isScrollControlled: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => Dialog(
          insetPadding: EdgeInsets.all(0),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Scaffold(
            appBar: AppBar(
              title: Text(dayName),
              actions: [],
              automaticallyImplyLeading: false,
            ),
            body: DaySchedule(user, ListSchDay),
          )),
      //barrierColor: BARRIERCOLOR,
    );
  }

  Widget DaySchedule(SystemAccount u, data) {
    //print(data['success']);
    if (data['success'] == 0)
      return Center(
        child: Text("No data"),
      );
    var lista = data['data'];
    var newList = lista.where(
      (element) => element['day'] == day,
    );
    return InkWell(
        child: Container(
            child: ListView.builder(
                itemCount: newList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Color.fromARGB(255, 241, 238, 238),
                            width: 1.0,
                            style: BorderStyle.none)),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 1,
                      shape: BeveledRectangleBorder(),
                      child: InkWell(
                        splashColor: Colors.red.withAlpha(30),
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      IconButton(
                                          color: Colors.black26,
                                          onPressed: () {
                                            //showAlertDialog(context);
                                          },
                                          icon: Icon(
                                            BootstrapIcons.clock_history,
                                            color: Colors.brown,
                                            size: 15,
                                          )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Init Time",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: APP_COLORS.Primary,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            data['data'][index]['startTime']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: APP_COLORS.Primary,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "End Time",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: APP_COLORS.Primary,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            data['data'][index]['endTime']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: APP_COLORS.Primary,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ]),
                                IconButton(
                                  onPressed: () {
                                    Delete(data['data'][index]);
                                  },
                                  icon: Icon(BootstrapIcons.trash),
                                  color: Colors.red,
                                  iconSize: 18,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })));
  }

  showConfirmDialog(item) {
    // set up the buttons

    // set up the AlertDialog
  }

  Delete(item) async {
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

        var res = await RequirementsService().Delete(item['requirementId']);
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
          ReadScheduleDay();
          AppMessage.ShowInfo(res['message'], context);
          Navigator.pop(context);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirm delete"),
      content: Text(
        "Really want to delete this schedule?",
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

    //print(item['requirementId']);
  }
}
