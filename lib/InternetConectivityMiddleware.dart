import 'package:adlitem_flutter/constants/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConectivity extends StatefulWidget {
  const InternetConectivity({Key? key, required this.widget}) : super(key: key);
  final Widget widget;
  @override
  _InternetConectivityState createState() => _InternetConectivityState();
}

class _InternetConectivityState extends State<InternetConectivity> {
  @override
  Widget build(BuildContext context) {
    Connectivity connectivity = new Connectivity();

    return Scaffold(
      body: StreamBuilder<ConnectivityResult>(
        stream: connectivity.onConnectivityChanged,
        builder: (_, snapshot) {
          return InternetConnectionWidget(
            snapshot: snapshot,
            widget: widget.widget,
          );
        },
      ),
    );
  }
}

class InternetConnectionWidget extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget;

  const InternetConnectionWidget(
      {super.key, required this.snapshot, required this.widget});

  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        final state = snapshot.data!;
        switch (state) {
          case ConnectivityResult.none:
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 50,
                  color: APP_COLORS.Danger,
                ),
                Text(
                  "No Internet Connection.",
                  style: TextStyle(
                      color: APP_COLORS.Danger,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ));
          default:
            return widget;
        }
      // case ConnectionState.waiting:
      //   return widget;
      default:
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 50,
              color: APP_COLORS.Danger,
            ),
            Text(
              "No Internet Connection.",
              style: TextStyle(
                  color: APP_COLORS.Danger,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
    }
  }
}
