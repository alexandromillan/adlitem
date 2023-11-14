import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsContidions extends StatefulWidget {
  const TermsContidions({Key? key}) : super(key: key);

  @override
  State<TermsContidions> createState() => _TermsContidionsState();
}

class _TermsContidionsState extends State<TermsContidions> {
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
              'Adlitem Terms and Conditions',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'In order to get some job, you must accept this terms',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                    textAlign: TextAlign.start,
                    "Introduction",
                    style: TextStyle(
                      fontSize: 20,
                      color: APP_COLORS.Primary,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.justify,
                    "Welcome to Adlitem, a platform connecting Attorneys and law firms with language interpreters for legal proceedings. By accessing and using our services, you agree to comply with and be  bound by the following Terms and Conditions. Please read them carefully",
                    style: TextStyle(
                      fontSize: 15,
                      color: APP_COLORS.Primary,
                    ),
                  ),
                ])),
            Container(
                padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Column(children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            "1.-Definitions",
                            style: TextStyle(
                              fontSize: 20,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                          Text("Adlitem"),
                          Text(
                            "Refers to the company providing the online platform connecting Attorneys and law firms with language interpreters",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            "Attorney/Law Firm",
                          ),
                          Text(
                            "Refers to individuals or entities seeking language interpretation services through the Adlitem platform",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Interpreter",
                          ),
                          Text(
                            "Refers to individuals providing language interpretation services through the Adlitem platform",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ])),
            SizedBox(
              height: 5,
            ),
            Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "3.- Service Description",
                            style: TextStyle(
                              fontSize: 20,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                          Text(
                            "Adlitem provides an online platform that allows Attorneys and law firms to post job requests for language interpreters, and allows interpreters to respond and provide their services. Interpreters are allowed to set their own personal rates for their services",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            "4.- Payment Terms",
                            style: TextStyle(
                              fontSize: 20,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                          Text(
                            "4.1- Interpreter Rates: Interpreters set their own rates for services provided through the Adlitem platform.",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                          Text(
                            "4.2- Attorney Payment:** Attorneys will pay Adlitem for the language interpretation services used. The payment includes the interpreter's fee plus a service fee of 15% of the total cost..",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                          Text(
                            "4.3- Payment Method:** Payment transactions will be facilitated through Adlitem's secure payment gateway..",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: APP_COLORS.Primary,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "5.- Platform Usage",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: APP_COLORS.Primary,
                                ),
                              ),
                              Text(
                                "5.1 Attorney Responsibilities: Attorneys are responsible for the accuracy of the information provided in job requests and for selecting interpreters based on their own criteria",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: APP_COLORS.Primary,
                                ),
                              ),
                              Text(
                                "5.2 Interpreter Responsibilities: Interpreters are responsible for delivering accurate and professional language interpretation services.",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: APP_COLORS.Primary,
                                ),
                              ),
                              Text(
                                "4.3- Payment Method:** Payment transactions will be facilitated through Adlitem's secure payment gateway..",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: APP_COLORS.Primary,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "6.- Service Fee",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: APP_COLORS.Primary,
                                ),
                              ),
                              Text(
                                "Adlitem charges Attorneys a service fee of 15% on top of the interpreter's fee. This fee covers the costs associated with operating and maintaining the Adlitem platform.",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: APP_COLORS.Primary,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ])),
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
