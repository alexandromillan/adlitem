import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/NotificationService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var list = Map();
  var user = SystemAccount();

  final IO.Socket socket = IO.io(SOCKET_BASE_URL_APP,
      IO.OptionBuilder().setTransports(['websocket']).build());

  _connectocket() {
    socket.onConnect((data) => print("Connection OK"));
    SystemAccount u = context.read<AppProvider>().getLoggedUser();
    socket.emit('userId', u.systemaccountId);
    socket.on(
        'getNotificationByUser',
        (response) => {
              if (mounted)
                setState(() {
                  if (list != response) list = response;
                }),
              //(response['data'])
            });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Server Disconnected'));
  }

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _connectocket();
  }

  @override
  void dispose() {
    super.dispose();
    //socket.disconnect();
  }

  readList() async {
    setState(() {
      isLoading = true;
    });
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
    Map _list = await NotificationService().GetbyUser(u);
    if (this.mounted) {
      setState(() {
        list = _list;
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _connectocket();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notifications'),
      ),
      body: Stack(alignment: FractionalOffset.center, children: [
        Container(
            padding: EdgeInsets.all(2),
            child: ListView.builder(
                itemCount: (list['data'] != null)
                    ? list['data'].length
                    : 0, //list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    //color: Color.fromRGBO(224, 251, 253, 1.0),
                    child: ListTile(
                      dense: false,
                      title: Row(children: [
                        Column(
                          children: [
                            IconButton(
                              color: APP_COLORS.Primary,
                              onPressed: () {},
                              icon: Icon(BootstrapIcons.bell_fill),
                              iconSize: 20,
                            )
                          ],
                        ),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.left,
                              softWrap: true,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: list['data'][index]['descripcion']
                                        .toString()
                                        .toLowerCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: " | Date: " +
                                        list['data'][index]['fecha'].toString(),
                                    style: TextStyle(color: Colors.black)),
                              ]),
                            ),
                          ],
                        )),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                NotificationService()
                                    .Delete(list['data'][index]['id']);
                                readList();
                              },
                              icon: Icon(BootstrapIcons.trash),
                              iconSize: 20,
                            )
                          ],
                        )
                      ]),
                    ),
                  );
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
}
