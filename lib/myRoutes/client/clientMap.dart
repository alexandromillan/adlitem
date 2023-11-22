import 'dart:async';

import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/helpers/WebSocket.dart';
import 'package:adlitem_flutter/models/ClientOrder.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/Notifications.dart';
import 'package:adlitem_flutter/myRoutes/client/OnlineProviders.dart';
import 'package:adlitem_flutter/myRoutes/client/ProviderOverview.dart';
import 'package:adlitem_flutter/myRoutes/client/offices/offices_list.dart';
import 'package:adlitem_flutter/myRoutes/client/orders/create_order.dart';
import 'package:adlitem_flutter/myRoutes/client/orders/order_list.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/clientServices/OrderService.dart';
//import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClientMap extends StatefulWidget {
  const ClientMap({Key? key}) : super(key: key);

  @override
  ClientMapState createState() => ClientMapState();
}

class ClientMapState extends State<ClientMap> {
  final IO.Socket socket = WebSocketApp().SetConnection();

  final mapController = MapController();

  List<Marker> markers = <Marker>[];
  Map listProviders = new Map();
  int ordersCount = 0;

  SystemAccount u = SystemAccount();
  bool isLoading = false;

  var listNotif = Map();
  var user = SystemAccount();

  @override
  void initState() {
    super.initState();
    GetMyOrdersCount();
    _connectocket();
  }

  void dispose() {
    super.dispose();
  }

  _connectocket() {
    socket.onConnect((data) => print("Connection OK"));
    SystemAccount u = context.read<AppProvider>().getLoggedUser();
    socket.emit('userId', u.systemaccountId);
    socket.on(
        'getProvidersConnected',
        (response) => {
              if (mounted)
                setState(() {
                  if (listProviders != response) listProviders = response;
                }),
              //CreateMarkersProviders(),
              //print(listProviders['data'].length)
            });

    socket.on(
        'getNotificationByUser',
        (response) => {
              if (mounted)
                setState(() {
                  if (listNotif != response) listNotif = response;
                }),
              print(listNotif)
            });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Server Disconnected'));
  }

  GetMyOrdersCount() {
    SystemAccount u = context.read<AppProvider>().getLoggedUser();
    const oneSec = Duration(seconds: 20);
    // Timer.periodic(oneSec, (Timer t) => );
    Timer.periodic(oneSec, (timer) async {
      var orders = await OrderService().GetbyUser(u);
      ordersCount = orders['data'].length;
    });
  }

  CreateMarkersProviders() async {
    List<Marker> tempMarkers = <Marker>[];
    markers.clear();
    //var res = await SystemAccountService().getConnectedProviders();
    var res = await listProviders;
    if (res['success'] == 1) {
      for (int i = 0; i < res['data'].length; i++) {
        //print(res['data'][i]);
        tempMarkers.add(new Marker(
            width: 160,
            height: 160,
            rotate: true,
            point:
                LatLng(res['data'][i]['latitude'], res['data'][i]['longitude']),
            builder: (context) => Stack(
                  children: [
                    FloatingActionButton.extended(
                        heroTag: res['data'][i]['areascoverageId'],
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    ProviderOverview(provider: res['data'][i])),
                          );
                        },
                        label: Text(
                          res['data'][i]['providerGroup'],
                          style: TextStyle(fontSize: 12),
                        ),
                        foregroundColor: Colors.yellow[160],
                        backgroundColor: APP_COLORS.Primary,
                        icon: Icon(
                          Icons.person_4_rounded,
                          size: 20,
                        )),
                    Positioned(
                        top: 40,
                        left: 30,
                        child: Icon(
                          BootstrapIcons.caret_down_fill,
                          color: APP_COLORS.Primary,
                        )),
                  ],
                )));
      }
      if (mounted)
        setState(() {
          markers = tempMarkers;
        });
    }
    //print(markers);
  }

  void _abrirContato() {
    AppMessage.ShowInfo("TAP", "TAP BUTTON");
  }

  @override
  Widget build(BuildContext context) {
    //CreateMarkersProviders();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CreateOrder(reloadCallBack: null)),
          );
        },
        elevation: 0,
        backgroundColor: APP_COLORS.Primary,
        label: Text(
          "Add Job",
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add_card,
          color: Colors.white,
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[dashBg, content],
        ),
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            child: Container(color: Colors.deepPurple),
            flex: 2,
          ),
          Expanded(
            child: Container(color: Colors.transparent),
            flex: 5,
          ),
        ],
      );
  get content => Container(
        child: Column(
          children: <Widget>[
            header,
            grid,
          ],
        ),
      );

  get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        title: Text(
          'CLIENT DATA',
          style: TextStyle(color: Colors.white),
        ),
        // subtitle: Text(
        //   '10 items',
        //   style: TextStyle(color: Colors.blue),
        // ),
        // trailing: CircleAvatar(),
      );
  get grid => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: [
                Item(
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => OrderList()),
                        );
                      },
                      icon: Icon(
                        BootstrapIcons.archive,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                    ),
                    "MY ORDERS",
                    this.ordersCount),
                ItemOffice(),
                Item(
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => OnlineProviders()),
                        );
                      },
                      icon: Icon(
                        Icons.person_search,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                    ),
                    "ONLINE PROVIDERS",
                    listProviders['data'] != null
                        ? listProviders['data'].length
                        : 0),
                Item(
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Notifications()),
                        );
                      },
                      icon: Icon(
                        BootstrapIcons.bell_fill,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                    ),
                    "NOTIFICATIONS",
                    listNotif['data'] != null ? listNotif['data'].length : 0),
              ]),
        ),
      );

  Widget Item(IconButton icon, String texto, int count) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              texto,
            ),
            badges.Badge(
              badgeContent: Text(
                count.toString(),
                style: TextStyle(color: Colors.white),
              ),
              position: badges.BadgePosition.topEnd(top: 30, end: -15),
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.black45),
              showBadge: true,
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -10, end: -10),
                showBadge: true,
                ignorePointer: false,
                onTap: () {},
                badgeContent: icon,
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.blueAccent),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ItemOffice() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "OFFICES",
            ),
            badges.Badge(
              badgeContent: Text(
                "0",
                style: TextStyle(color: Colors.white),
              ),
              position: badges.BadgePosition.topEnd(top: 30, end: -15),
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.black45),
              showBadge: false,
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -10, end: -10),
                showBadge: true,
                ignorePointer: false,
                onTap: () {},
                badgeContent: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => OfficesList()),
                      );
                    },
                    icon: Icon(
                      BootstrapIcons.building_check,
                      size: 40,
                      color: Colors.white,
                    )),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.blueAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
