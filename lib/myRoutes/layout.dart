import 'package:adlitem_flutter/myRoutes/client/dashboard_client.dart';
import 'package:adlitem_flutter/myRoutes/provider/dashboard_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  final String role;
  const Layout({Key? key, required this.role}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    if (widget.role == "CLI") {
      return DashboardClient();
    } else {
      return DashboardProvider();
    }
  }
}
