import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/helpers/TimeHelper.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/providerServices/RequirementsService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class Requirements extends StatefulWidget {
  const Requirements({Key? key}) : super(key: key);

  @override
  _RequirementsState createState() => _RequirementsState();
}

class _RequirementsState extends State<Requirements> {
  bool isLoading = false;
  final values = List.filled(7, false);
  List<int> days = [];
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 2)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rates & Requirements",
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(children: [
                  Center(
                      child: Text(
                    "1- Select days of week",
                  )),
                  WeekdaySelector(
                    onChanged: (int day) {
                      setState(() {
                        final index = day % 7;
                        values[index] = !values[index];
                      });
                      //print(values);
                    },
                    values: values,
                    selectedFillColor: Color.fromARGB(255, 20, 11, 155),
                    selectedColor: Color.fromARGB(255, 255, 255, 255),
                    elevation: 5,
                    selectedElevation: 10,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Color.fromARGB(255, 102, 221, 46)
                              .withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    selectedShape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Color.fromARGB(255, 46, 44, 151)
                              .withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    firstDayOfWeek: 0,
                    displayedDays: {
                      DateTime.monday,
                      DateTime.tuesday,
                      DateTime.wednesday,
                      DateTime.thursday,
                      DateTime.friday,
                      DateTime.saturday,
                    },
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    "2- Especify available  time for selected days",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  )),
                  Container(
                    child: Center(
                        child: ElevatedButton.icon(
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context, initialTime: startTime);
                        if (time == null) return;
                        setState(() => startTime = time);
                      },
                      icon: Icon(BootstrapIcons.watch),
                      label: Text('Start Time: ' + startTime.format(context)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => APP_COLORS.Primary)),
                    )),
                  ),
                  Container(
                    child: Center(
                        child: ElevatedButton.icon(
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context, initialTime: endTime);

                        if (time == null) return;

                        setState(() => endTime = time);
                        //print(startTime.format(context));
                      },
                      icon: Icon(BootstrapIcons.watch),
                      label: Text(' End Time:  ' + endTime.format(context)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => APP_COLORS.Morado1)),
                    )),
                  ),
                ]),
              ))),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            save();
          },
          label: const Text('Save'),
          icon: const Icon(Icons.check),
          backgroundColor: APP_COLORS.Primary),
    );
  }

  save() async {
    //print(values.length >= 0);
    if (!values[0] &&
        !values[1] &&
        !values[2] &&
        !values[3] &&
        !values[4] &&
        !values[5] &&
        !values[6]) {
      AppMessage.ShowInfo("You must Select days", context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    days.clear();
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
    for (var i = 1; i < values.length; i++) {
      if (values[i]) {
        days.add(i);
      }
    }

    var frmData = {
      "systemaccountId": u.systemaccountId,
      "days": days,
      "startTime": startTime.to24hours(),
      "endTime": endTime.to24hours(),
      "available": true
    };
    //print(frmData);
    var res = await RequirementsService().Create(frmData);

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
      //widget.reloadCallBack();
      AppMessage.ShowInfo(res['message'], context);
    } else {
      setState(() {
        isLoading = false;
      });
    }
    Navigator.pop(context, true);
  }
}
