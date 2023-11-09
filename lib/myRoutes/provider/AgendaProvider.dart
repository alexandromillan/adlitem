// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/TimeHelper.dart';
import 'package:adlitem_flutter/helpers/utils.dart';
import 'package:adlitem_flutter/models/ClientOrder.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/providerServices/OrderProcessedService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late Map<DateTime, List<ClientOrder>> selectedEvents;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    selectedEvents = {};
    getMyOrders();
    super.initState();
  }

  @override
  void dispose() {
    selectedEvents = {};

    super.dispose();
  }

  getMyOrders() async {
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
    Map _list = await OrderProcessedService().GetbyProvider(u);

    Map<DateTime, List<ClientOrder>> _selectedEvents = new Map();
    List orders = [];
    if (_list['success'] == 1) {
      var l = _list['data'].where((element) =>
          element['status'] == "open" ||
          element['status'] == "parcialClient" ||
          element['status'] == "parcialProvider" ||
          element['status'] == "closed" ||
          element['status'] == "pending");
      if (mounted)
        setState(() {
          orders = l.toList();
          //isLoading = false;
        });
    } else {
      // setState(() {
      //   //isLoading = false;
      // });
    }

    for (var i = 0; i < orders.length; i++) {
      var data = orders[i];
      var date = DateTime.parse(DateTime.parse(data['date']).toYMD());
      ClientOrder o = new ClientOrder(
        date: DateTime(date.year, date.month, date.day, 0, 0, 0),
        clientId: u.systemaccountId,
        cityId: data['cityId'],
        city: data['city'] ?? "",
        countyId: data['countyId'],
        county: data['county'] ?? "",
        languageId: data['languageId'],
        language: data['language'],
        languageCode: data['languageCode'],
        status: data['status'],
        placeName: data['officeName'],
        address: data['officeAddress'],
        activityId: data['activityId'],
        activity: data['activity'],
        latitude: 0,
        longitude: 0,
        mode: data['mode'] ?? "",
        rate: data['rate'],
        targetId: data['targetId'],
        target: data['target'],
        orderId: data['orderId'],
        priceRangeStart: 0,
        priceRangeEnd: 0,
        timeStart: DateTime.parse("0001-01-01 " + data['timeStart']),
        timeEnd: DateTime.parse("0001-01-01 " + data['timeEnd']),
      );

      if (_selectedEvents[date] != null) {
        _selectedEvents[date]?.add(o);
      } else {
        _selectedEvents[date] = [o];
      }
    }

    if (mounted)
      setState(() {
        selectedEvents = _selectedEvents;
      });
  }

  List<ClientOrder> _getEventsFromDay(DateTime date) {
    return selectedEvents[DateTime.parse(date.toYMD())] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    //getMyOrders();
    return Scaffold(
        appBar: AppBar(
          title: Text('My Assigments'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          TableCalendar(
            headerStyle: HeaderStyle(),
            startingDayOfWeek: StartingDayOfWeek.monday,
            currentDay: DateTime.now(),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEventsFromDay,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                // print(_selectedDay);
                //_getEventsFromDay(_selectedDay);
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
                selectedTextStyle: const TextStyle(color: Colors.white),
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                    color: APP_COLORS.Morado2, shape: BoxShape.circle)),
          ),
          Container(
            padding: EdgeInsets.only(left: 1),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.purple.shade900),
            child: Column(
              children: [
                ..._getEventsFromDay(_selectedDay).map((e) => buildItem(e))
              ],
            ),
          )
        ])));
  }

  buildItem(ClientOrder e) {
    //print(DateFormat.Hms().format(e.timeStart));
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: InkWell(
        splashColor: Colors.red.withAlpha(30),
        onTap: () {},
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          SizedBox(
                              width: 40,
                              height: 30,
                              child: Image.asset('assets/images/' +
                                  e.languageCode.toUpperCase() +
                                  '.png')),
                          Text(
                            e.language.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.placeName.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Event: " + e.activity.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Start at: " + DateFormat.Hms().format(e.timeStart),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
                if (e.status == "open")
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Icon(
                      BootstrapIcons.check2_all,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                if (e.status == "parcialProvider")
                  Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "waitting for client",
                            style: TextStyle(fontSize: 10),
                          ),
                          Icon(
                            BootstrapIcons.check2_circle,
                            color: APP_COLORS.Primary,
                            size: 20,
                          ),
                        ],
                      )),
                if (e.status == "parcialClient")
                  Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "waitting for you",
                            style: TextStyle(fontSize: 10),
                          ),
                          Icon(
                            BootstrapIcons.check2_circle,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ],
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
