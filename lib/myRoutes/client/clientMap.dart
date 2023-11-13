import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/helpers/WebSocket.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/client/ProviderOverview.dart';
import 'package:adlitem_flutter/myRoutes/client/orders/create_order.dart';
//import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

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

  SystemAccount u = SystemAccount();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _connectocket();
  }

  void dispose() {
    super.dispose();
  }

  _connectocket() {
    socket.onConnect((data) => print("Connection OK"));
    socket.on(
        'getProvidersConnected',
        (response) => {
              if (mounted)
                setState(() {
                  listProviders = response;
                }),
              CreateMarkersProviders(),
              //print(response['data'])
            });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Server Disconnected'));
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
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "images/office.png",
              width: 160,
              height: 160,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    //onTap: _abrirEmpresa,
                    child: Image.asset(
                      "images/provider.png",
                      width: 160,
                      height: 160,
                    ),
                  ),
                  GestureDetector(
                    onTap: _abrirContato,
                    child: Image.asset(
                      "images/ordenes.png",
                      width: 160,
                      height: 160,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        // onTap: _abrirCliente,
                        child: Image.asset(
                          "images/notificacion.png",
                          width: 160,
                          height: 160,
                        ),
                      )
                    ],
                  ),
                  Stack(children: [
                    GestureDetector(
                      onTap: _abrirContato,
                      child: Image.asset(
                        "images/config.png",
                        width: 160,
                        height: 160,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
