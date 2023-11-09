import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/utils.dart';
import 'package:adlitem_flutter/myRoutes/Notifications.dart';
import 'package:adlitem_flutter/myRoutes/about.dart';
import 'package:adlitem_flutter/myRoutes/client/offices/offices_list.dart';
import 'package:adlitem_flutter/myRoutes/client/orders/order_list.dart';
import 'package:adlitem_flutter/myRoutes/provider/AgendaProvider.dart';
import 'package:adlitem_flutter/myRoutes/settings.dart';
import 'package:adlitem_flutter/myWidgets/myavatar.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/myRoutes/provider/OrdersProvider.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adlitem_flutter/helpers/Devices.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = context.read<AppProvider>().getLoggedUser();

    var clientDrawer = ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(colors: [APP_COLORS.Primary, BLACK]),
              color: APP_COLORS.Primary,
              border: Border.symmetric(vertical: BorderSide.none),
            ),
            padding: EdgeInsets.only(right: 20, left: 5),
            child: Stack(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Myavatar(
                      radius: 40,
                      str: GetInitLetter(user.name) +
                          GetInitLetter(user.lastname))),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    user.name,
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  )),
              Align(
                  alignment: Alignment.centerRight + Alignment(0, 0.3),
                  child: Text(
                    user.lastname,
                    style: TextStyle(fontSize: 12.0, color: Colors.white70),
                  )),
            ])),
        ListTile(
          title: const Text('Home'),
          leading: Icon(CupertinoIcons.home),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Offices'),
          leading: Icon(BootstrapIcons.bank),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => OfficesList()),
            );
          },
        ),
        ListTile(
          title: const Text('Orders'),
          leading: Icon(BootstrapIcons.alexa),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => OrderList()),
            );
          },
        ),
        ListTile(
          title: const Text('Notifications'),
          leading: Icon(CupertinoIcons.bell),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => Notifications()),
            );
          },
        ),
        ListTile(
          title: const Text('About'),
          leading: Icon(BootstrapIcons.card_heading),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => About()),
            );
          },
        ),
        ListTile(
          title: const Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => Settings()),
            );
          },
        ),
        ListTile(
          title: const Text('Logout'),
          leading: Icon(Icons.logout),
          onTap: () {
            context.read<AppProvider>().logout();
          },
        ),
      ],
    );

    var providerDrawer = ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(colors: [APP_COLORS.Primary, BLACK]),
              color: APP_COLORS.Primary,
              border: Border.symmetric(vertical: BorderSide.none),
            ),
            padding: EdgeInsets.only(right: 20, left: 5),
            child: Stack(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Myavatar(
                      radius: 40,
                      str: GetInitLetter(user.name) +
                          GetInitLetter(user.lastname))),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    user.name,
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  )),
              Align(
                  alignment: Alignment.centerRight + Alignment(0, 0.3),
                  child: Text(
                    user.lastname,
                    style: TextStyle(fontSize: 12.0, color: Colors.white70),
                  )),
            ])),
        ListTile(
          title: const Text('Home'),
          leading: Icon(CupertinoIcons.home),
          onTap: () {},
        ),
        ListTile(
          title: const Text('My Assigments'),
          leading: Icon(BootstrapIcons.calendar2),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => TableBasicsExample()),
            );
          },
        ),
        ListTile(
          title: const Text('My Orders'),
          leading: Icon(BootstrapIcons.alexa),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => OrdersProvider()),
            );
          },
        ),
        ListTile(
          title: const Text('Notifications'),
          leading: Icon(CupertinoIcons.bell),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => Notifications()),
            );
          },
        ),
        ListTile(
          title: const Text('About'),
          leading: Icon(BootstrapIcons.card_heading),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => About()),
            );
          },
        ),
        ListTile(
          title: const Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => Settings()),
            );
          },
        ),
        ListTile(
          title: const Text('Logout'),
          leading: Icon(Icons.logout),
          onTap: () {
            context.read<AppProvider>().logout();
          },
        ),
      ],
    );

    return Container(
        width: Devices().isDesktop
            ? MediaQuery.of(context).size.width * 0.2
            : MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height,
        child: user.userGroup == 'CLI'
            ? Drawer(child: clientDrawer)
            : Drawer(child: providerDrawer));
  }
}
