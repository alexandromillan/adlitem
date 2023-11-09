import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/helpers/TimeHelper.dart';
import 'package:adlitem_flutter/helpers/WebSocket.dart';
import 'package:adlitem_flutter/models/Fixed.dart';
import 'package:adlitem_flutter/models/ProviderAreaCoverage.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';

import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/NotificationService.dart';
import 'package:adlitem_flutter/services/clientServices/OrderService.dart';
import 'package:adlitem_flutter/services/providerServices/AreasCoverageService.dart';
import 'package:adlitem_flutter/services/providerServices/OrderAcceptedService.dart';
import 'package:adlitem_flutter/services/providerServices/OrderProcessedService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProviderMap extends StatefulWidget {
  const ProviderMap({Key? key}) : super(key: key);

  @override
  ProviderMapState createState() => ProviderMapState();
}

class ProviderMapState extends State<ProviderMap> {
  final IO.Socket socket = WebSocketApp().SetConnection();

  List<CityModel> checkBoxListTileModel = CityModel.getCities();
  final mapController = MapController();
  bool isConnected = false;
  var list = <ProviderAreaCoverage>[];

  List<Marker> markers = <Marker>[];
  Map listOrders = new Map();

  SystemAccount u = SystemAccount();
  var selAreas = [];
  var orders = Map();
  bool isLoading = false;
  String Area = "";
  String PenalizacionMsg = "";
  double PorcientoH = 0;
  double HContratadas = 0;
  late DateTime timeHbefore;
  var HorasAntes = {};

  @override
  void initState() {
    super.initState();
    u = context.read<AppProvider>().getLoggedUser();
    readSelAreas();
    readConnectedArea();
    CreateMarkers();
    _connectocket();
  }

  void dispose() {
    super.dispose();
  }

  _connectocket() {
    socket.onConnect((data) => print("Connection OK"));
    socket.on(
        'getOrders',
        (response) => {
              if (mounted)
                setState(() {
                  listOrders = response;
                }),
              CreateMarkers(),
              // print(response['data'])
            });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Server Disconnected'));
  }

  CreateMarkers() async {
    List<Marker> tempMarkers = <Marker>[];
    markers.clear();
    // var res = await OrderService().GetAll();

    var res = await listOrders;
    if (res['success'] == 1) {
      for (int i = 0; i < res['data'].length; i++) {
        //print(res['data'][i]['city']);
        if (res['data'][i]['city'] == Area) {
          if (res['data'][i]['status'] == "FREE")
            tempMarkers.add(new Marker(
              height: 300,
              width: 200,
              rotate: true,
              rotateAlignment: AlignmentDirectional.center,
              point: LatLng(
                  res['data'][i]['latitude'], res['data'][i]['longitude']),
              builder: (context) => Stack(
                children: [
                  FloatingActionButton.extended(
                      heroTag: res['data'][i]['orderId'],
                      //extendedPadding: EdgeInsets.only(bottom: 5, top: 5),
                      onPressed: () async {
                        // await UpdateOrderStatus(res['data'][i], ORDER_STATUS['blocked']);
                        var resp = await OrderService().UpdateStatus(
                            res['data'][i]['orderId'],
                            ORDER_STATUS['blocked']!);
                        //print(resp);
                        if (resp['success'] == 1) {
                          await CreateMarkers();
                          showDialgAcceptOrder(res['data'][i]);
                        }
                      },
                      label: Text(
                        res['data'][i]['activity'],
                        style: TextStyle(fontSize: 10),
                      ),
                      backgroundColor: APP_COLORS.Primary,
                      icon: Image.asset(
                          width: 25,
                          'assets/images/' +
                              res['data'][i]['languageCode'].toUpperCase() +
                              '.png')),
                  Positioned(
                      top: 40,
                      left: 30,
                      child: Icon(
                        BootstrapIcons.caret_down_fill,
                        color: APP_COLORS.Primary,
                      )),
                ],
              ),
            ));
        }
      }
      if (mounted)
        setState(() {
          markers = tempMarkers;
        });
      //print(markers[0]);
    }
  }

  readSelAreas() async {
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

      List<CityModel> temp = [];
      for (int i = 0; i < selAreas.length; i++) {
        //print(selAreas[i]);
        var city = new CityModel(
            id: selAreas[i]['areascoverageId'],
            county: selAreas[i]['county'],
            state: selAreas[i]['state'],
            latitude: selAreas[i]['latitude'],
            longitude: selAreas[i]['longitude'],
            selected: selAreas[i]['selected'] == 1 ? true : false,
            city: selAreas[i]['city'],
            color: 'green');
        temp.add(city);
        setState(() {
          checkBoxListTileModel = temp;
          isLoading = false;
        });
      }
      if (mounted)
        setState(() {
          checkBoxListTileModel = temp;
        });
    } catch (e) {
      AppMessage.ShowError(e, context);
    }
  }

  readConnectedArea() async {
    setState(() {
      isLoading = true;
    });
    var response =
        await AreasCoverageService().GetAreaConnectedbyUser(u.systemaccountId);
    if (response['success'] == 1) {
      if (response['data'].length > 0) {
        var data = response['data'][0];
        if (data['active'] == 1) {
          if (mounted)
            setState(() {
              // print(data);
              Area = data['city'];
              //cityId = data['markerId'];
              isConnected = true;
            });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          options: MapOptions(
              center: LatLng((LATITUDE), (LONGITUDE)),
              interactiveFlags: InteractiveFlag.all,
              zoom: 9,
              maxZoom: 15,
              rotation: 5,
              scrollWheelVelocity: 0.005,
              enableMultiFingerGestureRace: true,
              enableScrollWheel: true),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            if (isConnected)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 80,
                  size: Size(40, 40),
                  anchor: AnchorPos.align(AnchorAlign.center),
                  fitBoundsOptions: FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                      maxZoom: 15,
                      //forceIntegerZoomLevel: false,
                      inside: false),
                  markers: markers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: APP_COLORS.Primary),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
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
      floatingActionButton: isConnected
          ? FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                var response =
                    await AreasCoverageService().Disconnect(u.systemaccountId);
                if (response['success'] == 1) {
                  setState(() {
                    isConnected = false;
                  });
                  setState(() {
                    isLoading = false;
                  });
                  //AppMessage.ShowInfo("Disconnect succesfully", context);
                }
              },
              label: Text("Disconnect"),
              icon: Icon(BootstrapIcons.plug_fill),
              backgroundColor: Colors.green[400])
          : FloatingActionButton.extended(
              onPressed: () {
                showCityConnect(Padding(
                  padding: EdgeInsets.only(top: 55),
                  child: ListView.builder(
                      itemCount: checkBoxListTileModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                          margin: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: Color.fromARGB(255, 241, 238, 238),
                                width: 0,
                                style: BorderStyle.solid),
                          ),
                          child: Column(children: <Widget>[
                            new ListTile(
                              selected: false,
                              //font change
                              title: new Text(
                                checkBoxListTileModel[index].city,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                              leading: Icon(Icons.location_city),
                              trailing: Icon(BootstrapIcons.plug_fill),
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });
                                ConnectArea(
                                    checkBoxListTileModel[index].id, true);
                                setState(() {
                                  Area = checkBoxListTileModel[index].city;
                                  //cityId = checkBoxListTileModel[index].id;
                                });
                              },
                            )
                          ]),
                        );
                      }),
                ));
              },
              label: const Text('Connect'),
              icon: const Icon(BootstrapIcons.plug),
              backgroundColor: Color.fromARGB(255, 67, 37, 173)),
    );
  }

  void ConnectArea(areaId, status) async {
    setState(() {
      isLoading = true;
    });
    var response = await AreasCoverageService().Connect(areaId, status);
    print(areaId);
    if (response['success'] == 1) {
      setState(() {
        isConnected = true;
      });
      await CreateMarkers();
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      //AppMessage.ShowInfo("Connected successfully", context);
    }
  }

  void showCityConnect(Widget w) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        isScrollControlled: false,
        context: context,
        enableDrag: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(0),
            backgroundColor: Colors.white,
            elevation: 1,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                    top: 15,
                    child: Text(
                      "Select area to connect".toUpperCase(),
                      style: TextStyle(
                          color: APP_COLORS.Primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    )),
                Positioned(child: w),
              ],
            )));
  }

  dialogContent(data) {
    final int _duration = 12;
    final CountDownController _controller = CountDownController();
    return Container(
        child: Center(
      child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: _duration,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: _controller,

        // Width of the Countdown Widget.
        width: MediaQuery.of(context).size.width / 6,

        // Height of the Countdown Widget.
        height: MediaQuery.of(context).size.height / 6,

        // Ring Color for Countdown Widget.
        ringColor: Colors.grey[300]!,

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Colors.purpleAccent[100]!,

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.purple[500],

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 5.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.butt,

        // Text Style for Countdown Text.
        textStyle: const TextStyle(
          fontSize: 15.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.MM_SS,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: true,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: false,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: true,

        // This Callback will execute when the Countdown Starts.
        onStart: () async {
          //await UpdateOrderStatus(data, ORDER_STATUS['blocked']);
          // Here, do whatever you want
          debugPrint('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () async {
          await UpdateOrderStatus(data, ORDER_STATUS['free']);
          // Here, do whatever you want
          Navigator.pop(context);
          debugPrint('Countdown Ended');
        },

        // This Callback will execute when the Countdown Changes.
        onChange: (String timeStamp) {
          // Here, do whatever you want
          debugPrint('Countdown Changed $timeStamp');
        },

        /* 
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow 
              the default behavior.
          */
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (duration.inSeconds == 0) {
            // only format for '0'
            return "Order Release";
          }
          if (duration.inSeconds == 11) {
            return "10 Sec";
          } else {
            // other durations by it's default format
            return Function.apply(defaultFormatterFunction, [duration]);
          }
        },
      ),
    ));
  }

  void showDialgAcceptOrder(data) {
    showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return CupertinoAlertDialog(
              title: const Text('Confirm Accept Job'),
              content: Column(children: [
                dialogContent(data),
                //Divider(),
                Column(
                  children: [
                    Text("Event: " + data['activity']),
                    Text("Office: " + data['officeName']),
                    Text("Date: " +
                        DateFormat.yMMMd('en_US')
                            .format(DateTime.parse(data['date']))),
                    Text("Start at: " + data['timeStart']),
                  ],
                )
              ]),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  /// This parameter indicates this action is the default,
                  /// and turns the action's text to bold text.
                  isDefaultAction: true,
                  onPressed: () {
                    UpdateOrderStatus(data, ORDER_STATUS['free']);
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  /// This parameter indicates the action would perform
                  /// a destructive action such as deletion, and turns
                  /// the action's text color to red.
                  isDestructiveAction: true,
                  onPressed: () {
                    //print(data);
                    Acceptjob(data);
                    //UpdateOrderStatus(data, ORDER_STATUS['accepted']);
                    Navigator.pop(context);
                  },
                  child: const Text('Accept Job'),
                ),
              ],
            );
          });
        });
  }

  void Acceptjob(order) async {
    var u = context.read<AppProvider>().getLoggedUser();
    var accept = {
      'orderId': order['orderId'],
      'providerId': u.systemaccountId,
      'date': order['date'],
      'time': order['timeStart'],
    };
    //print(accept);

    var res = await OrderAcceptedService().Create(accept);
    //print(res);

    var diff = TimeDiff(order['timeEnd'], order['timeStart']);
    if (diff != null && diff['horas'] == null) {
      diff['horas'] = 0;
    }

    //Procesar orden
    var orden = {
      'orderId': order['orderId'],
      'providerId': u.systemaccountId,
      'date': order['date'],
      'duration': diff['horas'],
      'cost': order['priceRangeEnd'],
      'comision': order['priceRangeEnd'] * 0.15,
      'status': "pending",
    };

    await OrderProcessedService().Create(orden);

    //Generar notificacion
    var noti = {
      'systemAccountId': order['clientId'],
      'fecha': DateFormat.yMMMd('en_US').format(DateTime.now().toLocal()),
      'origen': "CLIENT",
      'descripcion': "ORDER ACCEPTED BY " + u.name + " " + u.lastname,
      'visible': 1,
    };
    await NotificationService().Create(noti);
    if (mounted)
      setState(() {
        isLoading = false;
      });
    AppMessage.ShowInfo(res['message'], context);
  }

  UpdateOrderStatus(order, status) async {
    await OrderService().UpdateStatus(order['orderId'], status);
    await CreateMarkers();
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
    //alert(tiempoContratado)
    setState(() {
      HContratadas = tiempoContratado;
    });

    var timeActual = DateTime.now();

    //Horas y Fecha de la orden
    var f = DateTime.parse(order['date']).toYMD();
    var t = order['timeStart'].toString();
    var date = f + ' ' + t;
    var orderDate = DateTime.parse(date);
    // print(orderDate);
    //Rangos de Horarios
    if (tiempoContratado >= 0 && tiempoContratado <= 4) {
      //2H antes
      //setPorcientoH(50);
      //setHorasAntes(2);
      var newtimeHbefore = orderDate.add(new Duration(hours: -2));
      //var newtimeHbefore = new DateTime(orderDate.hour(orderDate.getHours() - 2));
      //settimeHbefore(newtimeHbefore);

      if (timeActual.isAfter(newtimeHbefore)) {
        // console.log("Se paso de tiempo paga el 50%")
        double penaliz = (tiempoContratado) * (precio * (50 / 100));
        //setPenalizacion ((tiempoContratado / 60) * (precio * (PorcientoH/100)));
        //console.log(this.Penalizacion)
        setState(() {
          PenalizacionMsg =
              "If you cancel this job, will have to pay for this cancelation " +
                  penaliz.toString();
        });
        //setPenalizacionMsg("If you cancel this job, will have to pay for this cancelation $" + Math.round(penaliz));
      }
      //else {
      //     setPenalizacionMsg("You may cancel Job without penalization");
      //     setTitle("Confirm Cancel Job");
      //   }
      // } else if (tiempoContratado > 240 && tiempoContratado <= 480) {
      //   //4H antes
      //   // setPorcientoH(40);
      //   // setHorasAntes(4);
      //   // settimeHbefore(new Date(orderDate.setHours(orderDate.getHours() - 4)));

      //   let newtimeHbefore = new Date(
      //     orderDate.setHours(orderDate.getHours() - 4)
      //   );
      //   //  let newtimeHbefore = new Date(orderDate);
      //   //  let hrs = newtimeHbefore.getHours()-4;
      //   //  newtimeHbefore.setHours(hrs);

      //   //  console.log(newtimeHbefore)
      //   //  console.log(timeActual)
      //   //  console.log(hrs)

      //   if (timeActual > newtimeHbefore) {
      //     //alert(newtimeHbefore)
      //     // console.log("Se paso de tiempo paga el 40%")
      //     // setPenalizacion ((tiempoContratado / 60) * (precio * (40/100)));
      //     let penaliz = (tiempoContratado / 60) * (precio * (40 / 100));
      //     //console.log(this.Penalizacion)
      //     setPenalizacionMsg("If you cancel this job, will have to pay for this cancelation $" + Math.round(penaliz));
      //   } else {
      //     setPenalizacionMsg("You may cancel Job without penalization");
      //     setTitle("Confirm Cancel Job");
      //   }
      // } else if (tiempoContratado > 480 && tiempoContratado <= 1140) {
      //   //8H antes
      //   // setPorcientoH(30);
      //   // setHorasAntes(8);
      //   // settimeHbefore(new Date(orderDate.setHours(orderDate.getHours() - 8)));
      //   let newtimeHbefore = new Date(
      //     orderDate.setHours(orderDate.getHours() - 8)
      //   );
      //   // console.log("Actual:" + timeActual);
      //   // console.log("horas antes:" + newtimeHbefore);

      //   if (timeActual > newtimeHbefore) {
      //     //   console.log("Se paso de tiempo paga el 30%")
      //     // setPenalizacion ((tiempoContratado / 60) * (precio * (PorcientoH/100)));
      //     let penaliz = (tiempoContratado / 60) * (precio * (30 / 100));
      //     //console.log(this.Penalizacion)
      //     setPenalizacionMsg("If you cancel this job, will have to pay for this cancelation $" + Math.round(penaliz));
      //   } else {
      //     setPenalizacionMsg("You may cancel Job without penalization");
      //     setTitle("Confirm Cancel Job");
      //   }
      // } else if (tiempoContratado > 1140) {
      //   //12H antes
      //   // setPorcientoH(20);
      //   // setHorasAntes(12);
      //   // settimeHbefore(new Date(orderDate.setHours(orderDate.getHours() - 12)));
      //   let newtimeHbefore = new Date(
      //     orderDate.setHours(orderDate.getHours() - 12)
      //   );
      //   if (timeActual > newtimeHbefore) {
      //     // console.log("Se paso de tiempo paga el 30%")
      //     // setPenalizacion ((tiempoContratado / 60) * (precio * (PorcientoH/100)));
      //     let penaliz = (tiempoContratado / 60) * (precio * (20 / 100));
      //     //console.log(this.Penalizacion)
      //     setPenalizacionMsg("If you cancel this job, will have to pay for this cancelation $" + Math.round(penaliz));

      //   } else {
      //     setPenalizacionMsg("You may cancel Job without penalization");
      //     setTitle("Confirm Cancel Job");
      //   }
      // }
    }
  }
}
