import 'package:adlitem_flutter/constants/colors.dart';

import 'package:adlitem_flutter/constants/environment.dart';

import 'package:adlitem_flutter/helpers/AppMessage.dart';

import 'package:adlitem_flutter/models/systemAccount.dart';

// import 'package:adlitem_flutter/myRoutes/client/orders/AssignJob.dart';

import 'package:adlitem_flutter/myRoutes/client/orders/create_order.dart';

import 'package:adlitem_flutter/myWidgets/mydrawer.dart';

import 'package:adlitem_flutter/providers/AppProvider.dart';

import 'package:adlitem_flutter/services/clientServices/OrderService.dart';

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


class OrderList extends StatefulWidget {

  const OrderList({Key? key}) : super(key: key);


  @override

  _OrderListState createState() => _OrderListState();

}


class _OrderListState extends State<OrderList> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var itemListCity = <DropdownMenuItem>[];

  var itemListCounty = <DropdownMenuItem>[];

  var itemListOffices = <DropdownMenuItem>[];

  var list = Map();

  var user = SystemAccount();

  bool isLoading = false;

  final _formKey = GlobalKey<FormBuilderState>();


  final IO.Socket socket = WebSocketApp().SetConnection();


  @override

  void initState() {

    _connectocket();

    super.initState();

  }


  void _ReloadCallBack() {

    readList();

  }


  _connectocket() {

    socket.onConnect((data) => print("Connection OK"));

    SystemAccount u = context.read<AppProvider>().getLoggedUser();

    socket.emit('userId', u.systemaccountId);

    socket.on(

        'getOrdersByUser',

        (response) => {

              if (mounted)

                setState(() {

                  if (list != response) list = response;

                }),

            });

    socket.onConnectError((data) => print('Connection Error: $data'));

    socket.onDisconnect((data) => print('Server Disconnected'));

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      key: scaffoldKey,

      //bottomNavigationBar: Icon(Icons.back_hand),

      drawer: myDrawer(),

      floatingActionButton: FloatingActionButton.extended(

        elevation: 0,

        backgroundColor: APP_COLORS.Primary,

        onPressed: () {

          Navigator.push(

            context,

            CupertinoPageRoute(

                builder: (context) =>

                    CreateOrder(reloadCallBack: _ReloadCallBack)),

          );

        },

        label: Text(

          "Add Job",

          style: TextStyle(color: Colors.white),

        ),

        icon: Icon(

          Icons.add_card,

          color: Colors.white,

        ),

      ),

      appBar: AppBar(

        automaticallyImplyLeading: false,

        leading: IconButton(

            onPressed: (() {

              Navigator.pop(context);

            }),

            icon: Icon(Icons.arrow_back)),

        actions: [

          IconButton(

            icon: const Icon(Icons.menu),

            onPressed: () {

              scaffoldKey.currentState!.openDrawer();

            },

          ),

        ],

        title: const Text('My Orders'),

      ),

      body: Stack(alignment: FractionalOffset.center, children: [

        Container(

            padding: EdgeInsets.all(2),

            child: ListView.builder(

                itemCount: (list['data'] != null)

                    ? list['data']

                        .where((element) =>

                            //element['status'] == "open" ||

                            //element['status'] == "parcialClient" ||

                            //element['status'] == "parcialProvider" ||

                            //element['status'] == "pending" ||

                            element['estado'] != "parcialProviderClosed")

                        .length

                    : 0, //list

                itemBuilder: (BuildContext context, int index) {

                  //var notifications;

                  return Container(

                      padding: EdgeInsets.all(5),

                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(0)),

                      ),

                      child: Card(

                        color: Colors.white,

                        shape: RoundedRectangleBorder(

                            side: BorderSide.none,

                            borderRadius: BorderRadius.only(

                                topLeft: Radius.circular(0),

                                bottomLeft: Radius.circular(0))),

                        clipBehavior: Clip.antiAliasWithSaveLayer,

                        elevation: 3,

                        child: InkWell(

                          splashColor: Colors.red.withAlpha(30),

                          onTap: () {

                            _showDetail(list['data'][index]);

                          },

                          child: Column(

                            children: [

                              Padding(

                                  padding: EdgeInsets.all(10),

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

                                                  color: list['data'][index]

                                                              ['status'] ==

                                                          "PENDING"

                                                      ? APP_COLORS.Primary

                                                      : Colors.green,

                                                ),

                                                child: IconButton(

                                                    color: Colors.black26,

                                                    onPressed: () {

                                                      //showAlertDialog(context);

                                                    },

                                                    icon: Icon(

                                                      Icons.gavel_outlined,

                                                      color: Colors.white,

                                                      size: 25,

                                                    ))),

                                            Column(

                                              crossAxisAlignment:

                                                  CrossAxisAlignment.start,

                                              children: [

                                                Text(

                                                  list['data'][index]

                                                          ['officeName']

                                                      .toString(),

                                                  style: TextStyle(

                                                      fontSize: 15,

                                                      color: Colors.grey,

                                                      fontWeight:

                                                          FontWeight.bold),

                                                ),

                                                Badge(

                                                  textColor: Colors.white,

                                                  backgroundColor: list['data']

                                                                  [index]

                                                              ['status'] ==

                                                          "PENDING"

                                                      ? APP_COLORS.Primary

                                                      : Colors.green,

                                                  label: Text(

                                                    list['data'][index]

                                                            ['activity']

                                                        .toString(),

                                                    style: TextStyle(

                                                        fontSize: 12,

                                                        color: Colors.white,

                                                        fontWeight:

                                                            FontWeight.bold),

                                                  ),

                                                  largeSize: 20,

                                                ),

                                              ],

                                            ),

                                          ],

                                        ),

                                        list['data'][index]['status'] ==

                                                "PENDING"

                                            ? Padding(

                                                padding:

                                                    EdgeInsets.only(top: 5),

                                                child: Image.asset(

                                                  "assets/images/publish.png",

                                                  width: 80,

                                                  height: 60,

                                                ),

                                              )

                                            : list['data'][index]['status'] ==

                                                        "FREE" ||

                                                    list['data'][index]

                                                            ['status'] ==

                                                        "BLOCKED"

                                                ? Padding(

                                                    padding:

                                                        EdgeInsets.only(top: 5),

                                                    child: Image.asset(

                                                      "assets/images/available.png",

                                                      width: 80,

                                                      height: 60,

                                                    ),

                                                  )

                                                : (list['data'][index]

                                                            ['estado'] ==

                                                        "open"

                                                    ? Padding(

                                                        padding:

                                                            EdgeInsets.only(

                                                                right: 30),

                                                        child: Icon(

                                                          BootstrapIcons

                                                              .check2_all,

                                                          color: Colors.green,

                                                          size: 25,

                                                        ),

                                                      )

                                                    : list['data'][index]

                                                                ['estado'] ==

                                                            "parcialProvider"

                                                        ? Padding(

                                                            padding:

                                                                EdgeInsets.only(

                                                                    top: 5),

                                                            child: Column(

                                                              mainAxisSize:

                                                                  MainAxisSize

                                                                      .max,

                                                              crossAxisAlignment:

                                                                  CrossAxisAlignment

                                                                      .center,

                                                              children: [

                                                                Text(

                                                                  list['data'][

                                                                              index]

                                                                          [

                                                                          'target'] +

                                                                      "is ready, please confirm to start",

                                                                  style: TextStyle(

                                                                      fontSize:

                                                                          10),

                                                                ),

                                                                // Icon(

                                                                //   BootstrapIcons

                                                                //       .check2_circle,

                                                                //   color: APP_COLORS

                                                                //       .Primary,

                                                                //   size: 20,

                                                                // ),

                                                              ],

                                                            ))

                                                        : list['data'][index][

                                                                    'estado'] ==

                                                                "closed"

                                                            ? (Padding(

                                                                padding: EdgeInsets.only(

                                                                    top: 5,

                                                                    right: 30),

                                                                child: Column(

                                                                  mainAxisSize:

                                                                      MainAxisSize

                                                                          .max,

                                                                  crossAxisAlignment:

                                                                      CrossAxisAlignment

                                                                          .center,

                                                                  children: [

                                                                    // Text(

                                                                    //   "Order is CLosed",

                                                                    //   style: TextStyle(

                                                                    //       fontSize:

                                                                    //           10),

                                                                    // ),

                                                                    Icon(

                                                                      Icons

                                                                          .lock,

                                                                      color: APP_COLORS

                                                                          .Success,

                                                                      size: 25,

                                                                    ),

                                                                  ],

                                                                )))

                                                            : (Padding(

                                                                padding: EdgeInsets.only(top: 5),

                                                                child: Column(

                                                                  mainAxisSize:

                                                                      MainAxisSize

                                                                          .max,

                                                                  crossAxisAlignment:

                                                                      CrossAxisAlignment

                                                                          .center,

                                                                  children: [

                                                                    Text(

                                                                      list['data'][index]

                                                                              [

                                                                              'target'] +

                                                                          " is out of the area",

                                                                      style: TextStyle(

                                                                          fontSize:

                                                                              10),

                                                                    ),

                                                                    // Icon(

                                                                    //   Icons.cancel,

                                                                    //   color:

                                                                    //       APP_COLORS

                                                                    //           .Danger,

                                                                    //   size: 20,

                                                                    // ),

                                                                  ],

                                                                )))),

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

      ]),

    );

  }


  //methods

  readList() async {

    setState(() {

      isLoading = true;

    });

    SystemAccount u = await context.read<AppProvider>().getLoggedUser();

    Map _list = await OrderService().GetbyUser(u);

    //Map _list = await OrderProcessedService().GetbyProvider(u);

    if (this.mounted) {

      setState(() {

        list = _list;

      });

      setState(() {

        isLoading = false;

      });

    }

  }


  void _showDetail(item) {

    print(item);

    showModalBottomSheet(

      shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.only(

              topLeft: Radius.circular(20), topRight: Radius.circular(20))),

      isScrollControlled: false,

      context: context,

      backgroundColor: Colors.white,

      builder: (BuildContext context) => Dialog(

        insetPadding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),

        backgroundColor: Colors.white,

        elevation: 0,

        child: FractionallySizedBox(

          heightFactor: 1,

          child: Column(children: [

            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

              Padding(

                  padding: EdgeInsets.all(5),

                  child: SizedBox(

                    width: 30,

                    height: 30,

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

                        fontSize: 15,

                        //color: Colors.brown,

                        fontWeight: FontWeight.bold),

                  ),

                ],

              )

            ]),

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Badge(

                  textColor: Colors.white,

                  largeSize: 25,

                  backgroundColor: APP_COLORS.Primary,

                  label: Text(

                    softWrap: true,

                    overflow: TextOverflow.fade,

                    maxLines: 3,

                    textAlign: TextAlign.center,

                    item['officeName'].toString(),

                    style: TextStyle(

                        fontSize: 14,

                        color: Colors.white,

                        fontWeight: FontWeight.bold),

                  ),

                ),

                Divider(),

                Row(children: [

                  Icon(BootstrapIcons.geo_alt_fill),

                  SizedBox(

                    width: 10,

                  ),

                  Text(

                    softWrap: true,

                    overflow: TextOverflow.fade,

                    maxLines: 2,

                    textAlign: TextAlign.center,

                    item['officeAddress'].toString(),

                    style: TextStyle(

                        fontSize: LABELTEXT - 5,

                        //color: Colors.brown,

                        fontWeight: FontWeight.bold),

                  )

                ]),

                SizedBox(

                  height: 10,

                ),

                Row(children: [

                  Icon(BootstrapIcons.calendar2_date_fill),

                  SizedBox(

                    width: 10,

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

                        fontSize: LABELTEXT - 5,

                        //color: Colors.brown,

                        fontWeight: FontWeight.bold),

                  )

                ]),

                SizedBox(

                  height: 10,

                ),

                Row(children: [

                  Icon(BootstrapIcons.clock_fill),

                  SizedBox(

                    width: 10,

                  ),

                  Text(

                    softWrap: true,

                    overflow: TextOverflow.fade,

                    maxLines: 2,

                    textAlign: TextAlign.center,

                    "Start Time: " + item['timeStart'].toString(),

                    style: TextStyle(

                        fontSize: LABELTEXT - 5,

                        //color: Colors.brown,

                        fontWeight: FontWeight.bold),

                  )

                ]),

                SizedBox(

                  height: 10,

                ),

                Row(children: [

                  Icon(BootstrapIcons.clock_fill),

                  SizedBox(

                    width: 10,

                  ),

                  Text(

                    softWrap: true,

                    overflow: TextOverflow.fade,

                    maxLines: 2,

                    textAlign: TextAlign.center,

                    "End Time: " + item['timeEnd'].toString(),

                    style: TextStyle(

                        fontSize: LABELTEXT - 5,

                        //color: Colors.brown,

                        fontWeight: FontWeight.bold),

                  )

                ]),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.end,

                  mainAxisSize: MainAxisSize.max,

                  children: [

                    IconButton(

                        color: Colors.red,

                        onPressed: () {

                          Navigator.pop(context);

                          showDeleteDialog(item);

                          //showConfirmDialog(item);

                        },

                        icon: Icon(

                          BootstrapIcons.trash,

                          color: Colors.red,

                          size: 25,

                        )),

                  ],

                ),

                Divider(),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.end,

                  mainAxisAlignment: MainAxisAlignment.end,

                  mainAxisSize: MainAxisSize.max,

                  children: [

                    (item['status'] != "PENDING" && item['status'] != "FREE") &&

                            (item['estado'] == "parcialProvider")

                        ? OutlinedButton(

                            child: Row(

                              children: [

                                (item['estado'] != "open")

                                    ? Icon(Icons.check_circle,

                                        color: Colors.purple)

                                    : Icon(Icons.stop_circle,

                                        color: Colors.purple),

                                SizedBox(

                                  width: 5,

                                ),

                                (item['estado'] != "open")

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

                              //print(item);

                              if (item['estado'] == "pending" ||

                                  item['estado'] == "parcialProvider") {

                                showConfirmDialog(item);

                              } else if (item['estado'] == "parcialClient") {

                                Navigator.pop(context);

                                AppMessage.ShowInfo(

                                    "You already started  this assignment",

                                    context);

                              } else {

                                showDialgFinishOrder(item);

                              }

                            },

                          )

                        : SizedBox(),

                    SizedBox(

                      width: 10,

                    ),

                    item['status'] == "PENDING"

                        ? OutlinedButton(

                            child: Row(

                              children: [

                                Icon(Icons.send_rounded, color: Colors.red),

                                SizedBox(

                                  width: 10,

                                ),

                                Text(

                                  "Publish Job",

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

                              Navigator.pop(context);

                              PublishJob(item);

                            },

                          )

                        : (item['status'] != "ACCEPTED"

                            ? OutlinedButton(

                                child: Row(

                                  children: [

                                    Icon(Icons.cancel, color: Colors.red),

                                    SizedBox(

                                      width: 10,

                                    ),

                                    Text(

                                      "Cancel Publish",

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

                                  Navigator.pop(context);

                                  UnPublishJob(item);

                                },

                              )

                            : (item['status'] != "open")

                                ? OutlinedButton(

                                    child: Row(

                                      children: [

                                        Icon(Icons.stop_circle,

                                            color: Colors.purple),

                                        SizedBox(

                                          width: 10,

                                        ),

                                        Text(

                                          "Finish Assignment",

                                          style:

                                              TextStyle(color: Colors.purple),

                                        )

                                      ],

                                    ),

                                    style: OutlinedButton.styleFrom(

                                      side: BorderSide(

                                        color: Colors.purple,

                                      ),

                                    ),

                                    onPressed: () {

                                      Navigator.pop(context);

                                    },

                                  )

                                : OutlinedButton(

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

                                      Navigator.pop(context);

                                    },

                                  ))

                  ],

                ),

                // Divider(),

                // Row(

                //   children: [

                //     item['status'] == "PENDING"

                //         ? FloatingActionButton.extended(

                //             icon: Icon(

                //               BootstrapIcons.send_check_fill,

                //               size: 15,

                //             ),

                //             label: Text(

                //               "Publish Job",

                //               style: TextStyle(fontSize: 12),

                //             ),

                //             backgroundColor: Colors.green,

                //             foregroundColor: Colors.white,

                //             onPressed: () => {

                //               Navigator.pop(context),

                //               PublishJob(item),

                //             },

                //           )

                //         : (item['status'] != "ACCEPTED"

                //             ? FloatingActionButton.extended(

                //                 icon: Icon(

                //                   BootstrapIcons.send_check_fill,

                //                   size: 15,

                //                 ),

                //                 label: Text(

                //                   "Cancel Publish",

                //                   style: TextStyle(fontSize: 12),

                //                 ),

                //                 backgroundColor: Colors.green,

                //                 foregroundColor: Colors.white,

                //                 onPressed: () => {

                //                   Navigator.pop(context),

                //                   //print(item),

                //                   UnPublishJob(item),

                //                 },

                //               )

                //             : FloatingActionButton.extended(

                //                 icon: Icon(

                //                   BootstrapIcons.send_check_fill,

                //                   size: 15,

                //                 ),

                //                 label: Text(

                //                   "Cancel JOB",

                //                   style: TextStyle(fontSize: 12),

                //                 ),

                //                 backgroundColor: Colors.green,

                //                 foregroundColor: Colors.white,

                //                 onPressed: () => {

                //                   Navigator.pop(context),

                //                   //print(item),

                //                   //UnPublishJob(item),

                //                 },

                //               )),

                //     SizedBox(

                //       width: 10,

                //     ),

                //     if (item['status'] == "PENDING")

                //       FloatingActionButton.extended(

                //         icon: Icon(

                //           BootstrapIcons.person_fill_up,

                //           size: 15,

                //         ),

                //         label: Text(

                //           "Assign to provider",

                //           style: TextStyle(fontSize: 12),

                //         ),

                //         backgroundColor: APP_COLORS.Primary,

                //         foregroundColor: Colors.white,

                //         onPressed: () => {

                //           Navigator.pop(context),

                //           Navigator.push(

                //             context,

                //             CupertinoPageRoute(

                //                 builder: (context) => AssignJob(job: item)),

                //           )

                //         },

                //       ),

                //  ],

                //)

              ],

            ),

          ]),

        ),

      ),

      //barrierColor: BARRIERCOLOR,

    );

  }


  PublishJob(item) async {

    //Navigator.pop(context);

    Map res = await OrderService().UpdateStatus(item['orderId'], "FREE");

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

      readList();

      AppMessage.ShowInfo(res['message'], context);

    } else {

      setState(() {

        isLoading = false;

      });

    }

  }


  UnPublishJob(item) async {

    //Navigator.pop(context);

    Map res = await OrderService().UpdateStatus(item['orderId'], "PENDING");

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

      readList();

      AppMessage.ShowInfo(res['message'], context);

    } else {

      setState(() {

        isLoading = false;

      });

    }

  }


  showConfirmDialog(item) {

    print("Confirm dilog");

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


        Navigator.pop(context);

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

        "Please confirm you are ready for assignment",

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


  showDeleteDialog(item) {

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

        DeleteJob(item);


        Navigator.pop(context);

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

        "Really want to remove this job ?",

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


  StartSession(order) async {

    // print(order);

    var time = DateFormat.Hms('en_US').format(DateTime.now());

    await OrderService().UpdateTimeStart(order['orderId'], time.toString());

    if (order['estado'] == "pending") {

      await OrderProcessedService()

          .UpdateStatus(order['orderId'], 'parcialClient');

    } else if (order['estado'] == "parcialProvider") {

      await OrderProcessedService().UpdateStatus(order['orderId'], 'open');

    } else if (order['estado'] == "parcialClient") {

      AppMessage.ShowInfo("You already confirm", context);

    }


    await readList();

    setState(() {

      isLoading = false;

    });

    //print(time);

  }


  showConfirmPublish(item) {

    // set up the buttons

    Widget cancelButton = OutlinedButton(

      child: Text("Cancel"),

      onPressed: () {

        Navigator.pop(context);

      },

    );

    Widget continueButton = OutlinedButton.icon(

      label: Text("Confirm"),

      icon: Icon(BootstrapIcons.check),

      //child: Text("Confirm"),

      onPressed: () async {

        setState(() {

          isLoading = true;

        });

        //Navigator.pop(context);

        Map res = await OrderService().UpdateStatus(item['orderId'], "FREE");

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

          readList();

          AppMessage.ShowInfo(res['message'], context);

        } else {

          setState(() {

            isLoading = false;

          });

        }

      },

    ); // set up the AlertDialog

    //print(item);

    AlertDialog alert = AlertDialog(

      title: Text("Confirm Publish"),

      content: Text(

        "Really want to publish this order ?",

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

          //CloseJob(_formKey.currentState!.value, data);

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

                                          color: Colors.brown[900],

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


  void DeleteJob(item) {}

}

