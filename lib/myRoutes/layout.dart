import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/client/dashboard_client.dart';
import 'package:adlitem_flutter/myRoutes/provider/dashboard_provider.dart';
import 'package:adlitem_flutter/myRoutes/terms_conditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  final SystemAccount user;
  const Layout({Key? key, required this.user}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    if (!widget.user.cancelAgree) {
      return TermsConditions();
    } else {
      if (widget.user.userGroup == "CLI") {
        return DashboardClient();
      } else {
        return DashboardProvider();
      }
    }
  }
}
