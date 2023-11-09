import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/settings/Profile.dart';
import 'package:adlitem_flutter/myRoutes/settings/ResetPassword.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings/SummaryProvider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var u = SystemAccount();
  @override
  void initState() {
    u = context.read<AppProvider>().getLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    //var s3 = size.width / 3;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
          child: InkWell(
              child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1)),
              border: Border.all(
                  color: Color.fromARGB(255, 241, 238, 238),
                  width: 1.0,
                  style: BorderStyle.solid),
            ),
            child: Column(children: <Widget>[
              ListTile(
                leading: Icon(Icons.person_2),
                dense: false,
                //minLeadingWidth: 3,
                iconColor: APP_COLORS.Primary,
                title: Text("Profile"),
                subtitle: Text(
                  "Set the user info",
                  style: TextStyle(fontSize: 12),
                ),
                isThreeLine: false,
                selected: false,
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.password),
                trailing: Icon(Icons.arrow_forward_ios),
                iconColor: APP_COLORS.Primary,
                title: Text("Password"),
                subtitle: Text(
                  "Reset your password",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => ResetPassword()),
                  );
                },
              ),
              if (u.userGroup == "PRO")
                ListTile(
                  leading: Icon(BootstrapIcons.person_circle),
                  trailing: Icon(Icons.arrow_forward_ios),
                  iconColor: APP_COLORS.Primary,
                  title: Text(
                    "Provider Overview",
                  ),
                  subtitle: Text(
                    "Information summary",
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => SummaryProfileProvider()),
                    );
                  },
                )
            ]),
          ),
        ],
      ))),
    );
  }

  profile() {
    return Container();
  }

  notification() {
    return Container();
  }

  password() {
    return Container();
  }

  showDialog(Widget widget) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        isScrollControlled: false,
        context: context,
        enableDrag: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            elevation: 0,
            child: widget));
  }
}
