import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/helpers/WebSocket.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/client/ProviderOverview.dart';
import 'package:adlitem_flutter/myRoutes/client/orders/create_order.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class OnlineProviders extends StatefulWidget {
  const OnlineProviders({Key? key}) : super(key: key);

  @override
  OnlineProvidersState createState() => OnlineProvidersState();
}

class OnlineProvidersState extends State<OnlineProviders> {
  final IO.Socket socket = WebSocketApp().SetConnection();

  final mapController = MapController();

  List<Marker> markers = <Marker>[];
  Map listProviders = new Map();

  SystemAccount u = SystemAccount();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _connectocket();
    isLoading = false;
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
            width: 250,
            height: 250,
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
                        foregroundColor: Colors.yellow[200],
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

  @override
  Widget build(BuildContext context) {
    //CreateMarkersProviders();
    return SafeArea(
      child: Stack(children: [
        Scaffold(
            appBar: AppBar(
              title: Text("Available Providers"),
            ),
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
              label: Text("Add Job"),
              icon: Icon(Icons.add_card),
            ),
            body: Center(
                child: Container(
                    child: FlutterMap(
              options: MapOptions(
                  center: LatLng((LATITUDE), (LONGITUDE)),
                  interactiveFlags: InteractiveFlag.all,
                  zoom: 9,
                  maxZoom: 15,
                  rotation: 0,
                  scrollWheelVelocity: 0.005,
                  enableMultiFingerGestureRace: true,
                  enableScrollWheel: true),
              children: <Widget>[
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
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
            )))),
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
}
