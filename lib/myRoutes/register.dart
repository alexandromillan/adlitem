import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/myRoutes/provider/register_provider.dart';
import 'package:adlitem_flutter/myStyles/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adlitem_flutter/myRoutes/client/register_client.dart';

class Register extends StatefulWidget {
  Register({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String client = "";
  String provider = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Provider"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Client"),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Adlitem SignUp Options',
            //style: Style_HeaderText(),
          ),
        ),
        body: TabBarView(
          children: [
            RegisterProvider(),
            RegisterClient(),
          ],
        ),
      ),
    );
  }

  TextRegister(type) {
    if (type == "PROVIDER") {
      return Text(
        "You will be pleased to find in Adlitem the opportunity to offer your services in the legal industry, at  your own rate, the one that’s fair for you and right for your qualifications without any intermediaries. With us, you can "
        "adjust your rates to meet the market requirements every time you "
        "need to, you can build up on "
        "your own network of clients allowing them to reach you first "
        "every time they post a job.",
        style: Style_ALLText_md(),
        textAlign: TextAlign.justify,
      );
    } else {
      return Text(
        "Works with independent providers at their "
        "personal rates to promote competitiveness and quality and offer "
        "a cost efficient support to your litigation. Whether it’s a "
        "court reporter, interpreter or translator that you need, you may "
        "find it in our network: the right one for your case, at the"
        "right price.",
        style: Style_ALLText_md(),
        textAlign: TextAlign.justify,
      );
    }
  }

  RegisterProvider() {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (provider == "" || provider == Null) {
                AppMessage.ShowError("Select a provider option", context);
                return;
              }
              // _showMaterialDialogProvider(provider);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          RegisterProviderDialog(ProType: provider)));
            },
            label: const Text('Next'),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            backgroundColor: APP_COLORS.Primary),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      //margin: EdgeInsets.all(5),
                      width: size.width / 1.08,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 223, 226, 227),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 154, 102, 4),
                              offset: Offset(7, 7),
                              blurRadius: 6,
                            ),
                          ]),
                      child: Flex(direction: Axis.horizontal, children: [
                        Expanded(child: TextRegister("PROVIDER"))
                      ]),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            RadioListTile(
              title: Text("Interpreter"),
              value: "Interpreter",
              groupValue: this.provider,
              onChanged: (value) {
                setState(() {
                  this.provider = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text("Court Reporter"),
              value: "CourtReporter",
              groupValue: provider,
              onChanged: (value) {
                setState(() {
                  provider = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text("Translator"),
              value: "Translator",
              groupValue: provider,
              onChanged: (value) {
                setState(() {
                  provider = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text("Substitute Attorney"),
              value: "Substitute Attorney",
              groupValue: provider,
              onChanged: (value) {
                setState(() {
                  provider = value.toString();
                });
              },
            ),
          ]),
        ));
  }

  RegisterClient() {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (client == "" || client == Null) {
                AppMessage.ShowError("Select a client option", context);
                return;
              }
              // _showMaterialDialogClient(client);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          RegisterClientDialog(CliType: client)));
            },
            label: const Text('Next'),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            backgroundColor: APP_COLORS.Primary),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      //margin: EdgeInsets.all(5),
                      width: size.width / 1.08,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 223, 226, 227),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 154, 102, 4),
                              offset: Offset(7, 7),
                              blurRadius: 6,
                            ),
                          ]),
                      child: Flex(
                          direction: Axis.horizontal,
                          children: [Expanded(child: TextRegister("CLIENT"))]),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            RadioListTile(
              title: Text("Law Firm"),
              value: "LawFirm",
              groupValue: client,
              onChanged: (value) {
                setState(() {
                  client = value.toString();
                  //print(client);
                });
              },
            ),
            RadioListTile(
              title: Text("Attorney"),
              value: "Attorney",
              groupValue: client,
              onChanged: (value) {
                setState(() {
                  client = value.toString();
                  //print(client);
                });
              },
            ),
            SizedBox(height: 144),
          ]),
        ));
  }

  // void _showMaterialDialogProvider(String pro) {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext context) =>
  //           Dialog(child: RegisterProviderDialog(ProType: pro)),
  //       barrierDismissible: true,
  //       barrierColor: BARRIERCOLOR);
  // }

  // void _showMaterialDialogClient(String cli) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) => Dialog(
  //         child: GestureDetector(
  //             child: RegisterClientDialog(
  //       CliType: cli,
  //     ))),
  //     barrierDismissible: true,
  //     barrierColor: BARRIERCOLOR,
  //   );
  // }
}
