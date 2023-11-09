import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/client/orders/create_order.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:adlitem_flutter/services/providerServices/ActivityRatesService.dart';
import 'package:adlitem_flutter/services/providerServices/LanguageService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProviderOverview extends StatefulWidget {
  const ProviderOverview({Key? key, this.provider}) : super(key: key);
  final provider;

  @override
  _ProviderOverviewState createState() => _ProviderOverviewState();
}

class _ProviderOverviewState extends State<ProviderOverview> {
  var listLang = [];
  var listActivity = [];
  var provider = {};

  bool isLoading = false;
  @override
  void initState() {
    readProviderData();
    readSelLangs();
    readActivities();
    super.initState();
  }

  readProviderData() async {
    try {
      var res = await SystemAccountService()
          .getProviderByEmail(widget.provider['username']);

      if (res['success'] == 0) {
        setState(() {
          isLoading = false;
        });
        return Container(child: Text("No Data"));
      }
      if (res['success'] == 1) {
        setState(() {
          provider = res['data'];
          isLoading = false;
        });
        return Container(child: Text("No Data"));
      }
    } catch (e) {
      AppMessage.ShowError(e, context);
    }
  }

  readSelLangs() async {
    SystemAccount u = new SystemAccount();
    u.systemaccountId = widget.provider['systemaccountId'];

    try {
      var res = await LanguageService().GetbyUser(u);
      //print(res);

      if (res['success'] == 0) {
        setState(() {
          isLoading = false;
        });
        return Container(child: Text("No Data"));
      }
      if (res['success'] == 1) {
        if (mounted)
          setState(() {
            listLang = res['data'];
            isLoading = false;
          });
        return Container(child: Text("No Data"));
      }
    } catch (e) {
      AppMessage.ShowError(e, context);
    }
  }

  readActivities() async {
    SystemAccount u = new SystemAccount();
    u.systemaccountId = widget.provider['systemaccountId'];
    try {
      var res = await ActivityRateService().GetbyUser(u);
      //print(res);

      if (res['success'] == 0) {
        setState(() {
          isLoading = false;
        });
        return Container(child: Text("No Data"));
      }
      if (res['success'] == 1) {
        setState(() {
          listActivity = res['data'];
          isLoading = false;
        });
        return Container(child: Text("No Data"));
      }
    } catch (e) {
      AppMessage.ShowError(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
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
        label: Text("Send Job"),
        icon: Icon(Icons.add_card),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.purple[700],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    splashColor: Colors.red.withAlpha(30),
                    onTap: () {},
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider['name'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    provider['lastname'].toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(),
                                  Text(
                                    provider['providerGroup'].toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 10, top: 10, left: 10, right: 40),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RatingBar.builder(
                                    initialRating: provider['rate'] ?? 0,
                                    minRating: 2,
                                    maxRating: 5,
                                    glow: true,
                                    glowColor: Colors.blue,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemSize: 14,
                                    itemCount: 5,
                                    wrapAlignment: WrapAlignment.start,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        //this.rate = rating;
                                      });
                                    },
                                  )
                                ]),
                          ),
                        ]),
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.purple[700],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                      splashColor: Colors.red.withAlpha(30),
                      onTap: () {
                        //_showOfficeDetail(list['data'][index]);
                        // _showDetail(list['data'][index]);
                        // print(list['data'][index]);
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: listLang
                              .map((e) => new Container(
                                    child: ListTile(
                                      dense: true,
                                      leading: SizedBox(
                                          width: 40,
                                          height: 30,
                                          child: Padding(
                                              padding: EdgeInsets.all(3),
                                              child: Image.asset(
                                                  'assets/images/' +
                                                      e['code'].toUpperCase() +
                                                      '.png'))),
                                      title: new Text(
                                        e['name'],
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      //value: checkBoxListTileModel[index].isCheck,
                                    ),
                                  ))
                              .toList())),
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.purple[700],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                      splashColor: Colors.red.withAlpha(30),
                      onTap: () {
                        //_showOfficeDetail(list['data'][index]);
                        // _showDetail(list['data'][index]);
                        // print(list['data'][index]);
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: listActivity
                              .map((e) => new Container(
                                    child: ListTile(
                                      dense: true,
                                      leading: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.gavel,
                                            size: 25,
                                            color: Colors.amber,
                                          )),

                                      title: new Text(
                                        e['activity'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5),
                                      ),
                                      //value: checkBoxListTileModel[index].isCheck,
                                    ),
                                  ))
                              .toList())),
                )),
          ],
        ),
      ),
    );
  }
}
