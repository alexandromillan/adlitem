import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class cancelFees extends StatefulWidget {
  const cancelFees({Key? key}) : super(key: key);

  @override
  State<cancelFees> createState() => _cancelFeesState();
}

class _cancelFeesState extends State<cancelFees> {
  @override
  Widget build(BuildContext context) {
    SystemAccount u = context.read<AppProvider>().getLoggedUser();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Read and Accept Cancelation fees'),
      // ),
      body: SingleChildScrollView(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              "assets/images/logo-sm.png",
              width: 100,
              height: 80,
            ),
            Text(
              'Cancelation Fees',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'In order to get some job, you must accept this terms',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  textAlign: TextAlign.justify,
                  "Adlitem originates out of the need for modernization and cost efficiency in the litigation support industry. We are proud to be the first full-service platform designed to meet the industry requirements in the digital and interconnected environment of the 21st Century. Using state-or-the-art technology to optimize its operation, Adlitem connects Clients and Providers on their terms, in a free market environment where they can exchange their needs and services fast, efficiently and securely as well as build up on their individual network to obtain coverage for every stage of litigation, from filing and discovery to settlement or trial.",
                  style: TextStyle(
                    fontSize: 12,
                    color: APP_COLORS.Primary,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            OutlinedButton.icon(
              label: Text("Yes, I Accept this terms"),
              icon: Icon(BootstrapIcons.check),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                  backgroundColor: APP_COLORS.Primary,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),

              //child: Text("Confirm"),
              onPressed: () async {
                context.read<AppProvider>().AcceptCancelation();
                SystemAccountService().updateCancelAgree(u.systemaccountId);
              },
            )
          ],
        ),
      )),
    );
  }
}
