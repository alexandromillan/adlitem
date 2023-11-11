// ignore_for_file: unused_import

import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/helpers/TimeHelper.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/NotificationService.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:adlitem_flutter/services/clientServices/OrderService.dart';
import 'package:adlitem_flutter/services/providerServices/OrderAcceptedService.dart';
import 'package:adlitem_flutter/services/providerServices/OrderProcessedService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../helpers/WebSocket.dart';

class OrdersProvider extends StatefulWidget {
  const OrdersProvider({Key? key}) : super(key: key);

  @override
  _OrdersProviderState createState() => _OrdersProviderState();
}

class _OrdersProviderState extends State<OrdersProvider> {
  var list = Map();
  var user = SystemAccount();
  bool isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();

  String PenalizacionMsg = "";
  double PorcientoH = 0;
  double HContratadas = 0;
  late DateTime timeHbefore;
  var HorasAntes = {};
  bool isPenalizado = false;

  final IO.Socket socket = WebSocketApp().SetConnection();

  @override
  void initState() {
    _connectocket();
    // readList();
    super.initState();
  }

  @override
  void dispose() {
    list.clear();

    super.dispose();
  }

  _connectocket() {
    socket.onConnect((data) => print("Connection OK"));
    SystemAccount u = context.read<AppProvider>().getLoggedUser();
    socket.emit('userId', u.systemaccountId);
    socket.on(
        'getProcessedOrderByProvider',
        (response) => {
              if (mounted)
                setState(() {
                  list = response;
                }),
            });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Server Disconnected'));
  }

  readList() async {
    setState(() {
      isLoading = true;
    });
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
    Map _list = await OrderProcessedService().GetbyProvider(u);

    if (_list['success'] == 1) {
      setState(() {
        list = _list;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  StartSession(order) async {
    // print(order);
    var time = DateFormat.Hms('en_US').format(DateTime.now());
    await OrderService().UpdateTimeStart(order['orderId'], time.toString());
    if (order['status'] == "pending") {
      await OrderProcessedService()
          .UpdateStatus(order['orderId'], 'parcialProvider');
    } else if (order['status'] == "parcialClient") {
      await OrderProcessedService().UpdateStatus(order['orderId'], 'open');
    } else if (order['status'] == "parcialProvider") {
      AppMessage.ShowInfo("You already started this assignment", context);
    }

    await readList();
    setState(() {
      isLoading = false;
    });
    //print(time);
  }

  void showDialgFinishOrder(data) {
    //print(data);
    //var ch = calcHoras(data);
    //calcPenalizacion(data, ch, data['priceRangeEnd']);
    Widget cancelButton = OutlinedButton.icon(
      label: Text(
        "Cancel ",
        style: TextStyle(color: Colors.red),
      ),
      icon: Icon(
        Icons.cancel,
        color: Colors.red,
      ),
      style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.red,
          ),
          textStyle: TextStyle(
            color: Colors.red,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = OutlinedButton.icon(
      label: Text("Confirm Finish"),
      icon: Icon(BootstrapIcons.check),
      style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.purple,
          ),
          textStyle: TextStyle(
            color: Colors.purple,
          )),

      //child: Text("Confirm"),
      onPressed: () async {
        if (_formKey.currentState!.saveAndValidate()) {
          //save(_formKey.currentState!.value),
          CloseJob(_formKey.currentState!.value, data);
        }

        //Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
        // }
      },
    ); //
    showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Stack(alignment: Alignment.center, children: [
            Positioned(
                top: 80,
                child: Center(
                  child: SizedBox(
                      height: 400,
                      child: AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        title: Center(child: Text('Confirm Finish Job')),
                        content: Column(children: [
                          //Divider(),
                          Column(
                            children: [
                              Text("Event: " + data['activity']),
                              Text("Started at: " + data['realTimeStart']),
                              Divider(),
                              FormBuilder(
                                  key: _formKey,
                                  child: Container(
                                    child: FormBuilderDateTimePicker(
                                      name: "timeEnd",
                                      format: DateFormat.Hms('en_US'),
                                      inputType: InputType.time,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Finished At',
                                        labelStyle: TextStyle(fontSize: 25),
                                        hintText: '08:00',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.normal),
                                      onChanged: (value) => {
                                        // setState(() => this.date = value!),
                                      },
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                      ]),
                                    ),
                                  )),
                            ],
                          )
                        ]),
                        actions: [
                          cancelButton,
                          continueButton,
                        ],
                      )),
                ))
          ]);
        });
  }

  CloseJob(timeData, data) async {
    var time = DateFormat.Hms('en_US').format(timeData['timeEnd']);
    //print(data['orderId']);
    //SystemAccount u = await context.read<AppProvider>().getLoggedUser();
    var res =
        await OrderService().updateOrderProviderTimeEnd(data['orderId'], time);
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
      await OrderProcessedService().Close(data);
      readList();
      setState(() {
        isLoading = false;
      });
      //_formKey.currentState!.reset();
      AppMessage.ShowInfo(res['message'], context);
    } else {
      //AppMessage.ShowInfo(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
    Navigator.pop(context, true);
    Navigator.pop(context, true);
  }

  CancelJob(order) {
    var ch = calcHoras(order);
    calcPenalizacion(order, ch, order['priceRangeEnd']);
    ConfirmCancelJob(order);
  }

  void ConfirmCancelJob(data) {
    //print(data);
    showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Text('Confirm this action?'),
              content: Column(children: [
                Column(
                  children: [
                    Text("Confirm you want to cancel this job. " +
                        PenalizacionMsg.toString()),
                  ],
                )
              ]),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    var noti = {};
                    if (isPenalizado) {
                      var v = (data['rate'] + 1) / 2;
                      await SystemAccountService()
                          .voteUser(data['systemaccountId'], v);

                      context.read<AppProvider>().voteUser(v);

                      await releaseOrder(data);

                      noti = {
                        'systemAccountId': data['systemaccountId'],
                        'fecha': DateTime.now(),
                        'origen': "CLIENT",
                        'descripcion': "You has been rated with 1 star",
                        'visible': 1,
                      };
                      await NotificationService().Create(noti);
                      noti = {
                        'systemAccountId': data['clientId'],
                        'fecha': DateFormat.yMMMd('en_US')
                            .format(DateTime.now().toLocal()),
                        'origen': "PROVIDER",
                        'descripcion':
                            "Provider has canceled and it has been rated with 1 star",
                        'visible': 1,
                      };
                      await NotificationService().Create(noti);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      await releaseOrder(data);
                      noti = {
                        'systemAccountId': data['clientId'],
                        'fecha': DateFormat.yMMMd('en_US')
                            .format(DateTime.now().toLocal()),
                        'origen': "PROVIDER",
                        'descripcion': "Provider has canceled",
                        'visible': 1,
                      };
                      await NotificationService().Create(noti);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Yes, Cancel'),
                ),
              ],
            );
          });
        });
  }

  releaseOrder(data) async {
    //release order
    await OrderAcceptedService().DeleteByOrderId(data['orderId']);
    await OrderProcessedService().DeleteByOrderId(data['orderId']);
    await OrderService().UpdateStatus(data['orderId'], "FREE");
    await readList();
  }

  calcHoras(order) {
    //print(order);
    var diff = TimeDiff(order['timeEnd'], order['timeStart']);
    if (diff != null && diff['horas'] == null) {
      diff.horas = 0;
    }
    return diff;
  }

  calcPenalizacion(order, tiempo, precio) {
    var tiempoContratado = tiempo['difMin'] / 60; //Minutos
    setState(() {
      HContratadas = tiempoContratado;
    });

    var timeActual = DateTime.now().toUtc();

    //Horas y Fecha de la orden
    var f = DateTime.parse(order['date']).toYMD();
    var t = order['timeStart'].toString();
    var date = f + ' ' + t;
    var orderDate = DateTime.parse(date);

    //2 Horas Antes
    var newtimeHbefore = orderDate.add(new Duration(minutes: -140));

    if (timeActual.isAfter(newtimeHbefore) && timeActual.isBefore(orderDate)) {
      setState(() {
        isPenalizado = true;
        PenalizacionMsg = "You will be rated with 1 star";
      });
    } else {
      setState(() {
        isPenalizado = false;
        PenalizacionMsg = "";
      });
    }
  }

  showConfirmDialog(item) {
    print(item);
    // set up the buttons
    Widget cancelButton = OutlinedButton.icon(
      label: Text(
        "No ",
        style: TextStyle(color: Colors.red),
      ),
      icon: Icon(
        Icons.cancel,
        color: Colors.red,
      ),
      style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.red,
          ),
          textStyle: TextStyle(
            color: Colors.red,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = OutlinedButton.icon(
      label: Text("Yes"),
      icon: Icon(BootstrapIcons.check),
      style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.purple,
          ),
          textStyle: TextStyle(
            color: Colors.purple,
          )),

      //child: Text("Confirm"),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        StartSession(item);

        //Navigator.pop(context);
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
        // }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        "Please confirm you are ready for assignment",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My orders'),
      ),
      body: Stack(alignment: FractionalOffset.center, children: [
        Container(
            padding: EdgeInsets.all(2),
            child: ListView.builder(
                itemCount: (list['data'] != null)
                    ? list['data']
                        .where((element) =>
                            element['status'] == "open" ||
                            element['status'] == "parcialClient" ||
                            element['status'] == "parcialProvider" ||
                            element['status'] == "closed" ||
                            element['status'] == "pending")
                        .length
                    : 0, //list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        border: Border.all(
                            color: Color.fromARGB(255, 241, 238, 238),
                            width: 3.0,
                            style: BorderStyle.none),
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 3,
                        shape: BeveledRectangleBorder(),
                        child: InkWell(
                          splashColor: Colors.red.withAlpha(30),
                          onTap: () {
                            //_showOfficeDetail(list['data'][index]);
                            if (list['data'][index]['status'] == "closed")
                              AppMessage.ShowInfo(
                                  "This Job has finished", context);
                            else
                              _showDetail(list['data'][index]);
                            // print(list['data'][index]);
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
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Column(children: [
                                            SizedBox(
                                              width: 40,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/images/' +
                                                      list['data'][index]
                                                              ['languageCode']
                                                          .toUpperCase() +
                                                      '.png'),
                                            ),
                                            Text(
                                              list['data'][index]['language']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: APP_COLORS.Primary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              list['data'][index]['officeName']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  //color: APP_COLORS.Primary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Event: " +
                                                  list['data'][index]
                                                          ['activity']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: APP_COLORS.Primary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Date: " +
                                                  DateTime.parse(list['data']
                                                          [index]['date'])
                                                      .toYMD(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: APP_COLORS.Primary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ]),
                                  if (list['data'][index]['status'] == "open")
                                    Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Icon(
                                        BootstrapIcons.check2_all,
                                        color: Colors.green,
                                        size: 25,
                                      ),
                                    ),
                                  if (list['data'][index]['status'] ==
                                      "parcialProvider")
                                    Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                  if (list['data'][index]['status'] ==
                                      "parcialClient")
                                    Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                  if (list['data'][index]['status'] == "closed")
                                    Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.lock_rounded,
                                              color: Colors.deepPurple,
                                              size: 30,
                                            ),
                                          ],
                                        )),
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
    );
  }

  void _showDetail(item) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      isScrollControlled: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.all(20),
        backgroundColor: Colors.white,
        elevation: 0,
        child: FractionallySizedBox(
          heightFactor: 0.9,
          child: Column(children: [
            Row(children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/' +
                        item['languageCode'].toUpperCase() +
                        '.png'),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['activity'].toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: APP_COLORS.Primary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    item['language'].toString(),
                    style: TextStyle(
                        fontSize: 12,
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  item['officeName'].toString(),
                  style: TextStyle(
                      fontSize: 13,
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
                  "Address: " + item['officeAddress'].toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  "Date: " +
                      DateFormat.yMMMEd('en_US')
                          .format(DateTime.parse(item['date']).toLocal())
                          .toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      "Start Time: " + item['timeStart'].toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                      height: 0,
                    ),
                    Text(
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      "End Time: " + item['timeEnd'].toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      child: Row(
                        children: [
                          (item['status'] != "open")
                              ? Icon(Icons.play_circle, color: Colors.purple)
                              : Icon(Icons.stop_circle, color: Colors.purple),
                          SizedBox(
                            width: 5,
                          ),
                          (item['status'] != "open")
                              ? Text(
                                  "Confirm Presence",
                                  style: TextStyle(color: Colors.purple),
                                )
                              : Text(
                                  "Finish Assignment",
                                  style: TextStyle(color: Colors.purple),
                                )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      onPressed: () {
                        print(item);
                        if (item['status'] == "pending" ||
                            item['status'] == "parcialClient") {
                          showConfirmDialog(item);
                        } else if (item['status'] == "parcialProvider") {
                          Navigator.pop(context);
                          AppMessage.ShowInfo(
                              "You already started  this assignment", context);
                        } else {
                          print("Cerrando Orden");
                          showDialgFinishOrder(item);
                        }
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      child: Row(
                        children: [
                          Icon(Icons.cancel, color: Colors.red),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Cancel Job",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        CancelJob(item);
                      },
                    ),
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
}

//----------------
