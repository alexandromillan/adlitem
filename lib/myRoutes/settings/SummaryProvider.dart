import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/providerServices/ActivityRatesService.dart';
import 'package:adlitem_flutter/services/providerServices/LanguageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SummaryProfileProvider extends StatefulWidget {
  const SummaryProfileProvider({Key? key}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<SummaryProfileProvider> {
  var listLang = [];
  var listActivity = [];

  bool isLoading = false;
  @override
  void initState() {
    readSelLangs();
    readActivities();
    super.initState();
  }

  readSelLangs() async {
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
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
    SystemAccount u = await context.read<AppProvider>().getLoggedUser();
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
    SystemAccount u = context.read<AppProvider>().getLoggedUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.purple[900],
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
                                    u.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    u.lastname,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(),
                                  Text(
                                    u.email,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBar.builder(
                                    initialRating: u.rate,
                                    minRating: 1,
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
                  color: Colors.blue[200],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                      splashColor: Colors.red.withAlpha(30),
                      onTap: () {},
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: listLang
                              .map((e) => new Container(
                                    child: ListTile(
                                      dense: true,
                                      leading: SizedBox(
                                        child: Image.asset('assets/images/' +
                                            e['code'].toUpperCase() +
                                            '.png'),
                                        width: 40,
                                        height: 30,
                                      ),
                                      title: new Text(
                                        e['name'],
                                        style: TextStyle(
                                            fontSize: 14,
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
                  color: Colors.red[600],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                      splashColor: Colors.red.withAlpha(30),
                      onTap: () {},
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: listActivity
                              .map((e) => new Container(
                                    child: ListTile(
                                      dense: true,
                                      leading: Icon(
                                        Icons.gavel,
                                        size: 25,
                                        color: Colors.white,
                                      ),

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
