import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/helpers/utils.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myWidgets/myavatar.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AssignJob extends StatefulWidget {
  const AssignJob({Key? key, required this.job}) : super(key: key);
  final job;
  @override
  _AssignJobState createState() => _AssignJobState();
}

class _AssignJobState extends State<AssignJob> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Text('ASSIGN JOB');
  var filter = '';
  bool showFilter = false;

  bool isLoading = false;
  var txtfilter = new TextEditingController();

  @override
  void initState() {
    readList();
    super.initState();
  }

  var list = Map();
  List _list = [];
  List temp = [];

  readList() async {
    setState(() {
      isLoading = true;
    });
    Map _providers = await SystemAccountService().getConnectedProviders();
    if (this.mounted) {
      setState(() {
        list = _providers;
        _list = temp = list['data'];
      });
      setState(() {
        isLoading = false;
      });
    }
    //print(list['data']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: !showFilter
        //     ? FloatingActionButton.small(
        //         onPressed: () {
        //           setState(() {
        //             showFilter = !showFilter;
        //           });
        //         },
        //         child: Icon(Icons.search))
        //     : FloatingActionButton.small(
        //         onPressed: () {
        //           setState(() {
        //             showFilter = !showFilter;
        //           });
        //         },
        //         child: Icon(Icons.close_rounded)),
        appBar: AppBar(
          title: customSearchBar,
          actions: [
            // IconButton(
            //     onPressed: () {
            //       setState(() {
            //         showFilter = !showFilter;
            //       });
            //     },
            //     icon: customIcon)
          ],
        ),
        body: Stack(alignment: FractionalOffset.center, children: [
          if (showFilter)
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
          Container(
              padding: EdgeInsets.all(2),
              child: ListView.builder(
                  itemCount: _list.length, //list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Card(
                          color: Colors.white70,
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50))),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          //elevation: 0,
                          child: InkWell(
                            splashColor: Colors.red.withAlpha(30),
                            onTap: () {
                              showConfirmDialog(list['data'][index]);
                            },
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            APP_COLORS.Primary),
                                                    child: Myavatar(
                                                        str: GetInitLetter(
                                                                list['data']
                                                                        [index]
                                                                    ['name']) +
                                                            GetInitLetter(list[
                                                                        'data']
                                                                    [index]
                                                                ['lastname']),
                                                        radius: 30)),
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          list['data'][index]
                                                                  ['name'] +
                                                              " " +
                                                              list['data'][
                                                                          index]
                                                                      [
                                                                      'lastname']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: APP_COLORS
                                                                  .Primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Badge(
                                                          textColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              APP_COLORS
                                                                  .Primary,
                                                          label: Text(
                                                            list['data'][index][
                                                                    'providerGroup']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          largeSize: 20,
                                                        ),
                                                        RatingBar.builder(
                                                          initialRating:
                                                              list['data']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'rate'] ??
                                                                  0,
                                                          minRating: 2,
                                                          maxRating: 5,
                                                          glow: true,
                                                          glowColor:
                                                              Colors.blue,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemSize: 15,
                                                          itemCount: 5,
                                                          wrapAlignment:
                                                              WrapAlignment
                                                                  .start,
                                                          itemPadding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: Colors
                                                                .amberAccent
                                                                .shade700,
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {
                                                            setState(() {
                                                              //this.rate = rating;
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    )),
                                              ]),
                                        ])),
                              ],
                            ),
                          ),
                        ));
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
        ]));
  }

  showConfirmDialog(item) {
    // set up the buttons
    Widget cancelButton = FloatingActionButton.extended(
      icon: Icon(
        Icons.close,
        size: 15,
      ),
      elevation: 0,
      label: Text(
        "Cancel",
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: Colors.purple.shade200,
      foregroundColor: Colors.white,
      onPressed: () => {
        Navigator.pop(context),
      },
    );

    Widget continueButton = FloatingActionButton.extended(
      icon: Icon(
        Icons.check,
        size: 15,
      ),
      label: Text(
        "Assign",
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: APP_COLORS.Primary,
      foregroundColor: Colors.white,
      onPressed: () => {
        Navigator.pop(context),
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm assignment"),
      content: Text(
        "Really want to assign order to " +
            item['providerGroup'] +
            " " +
            item['name'] +
            " ?",
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
