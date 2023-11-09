import 'package:adlitem_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Adlitem'),
      ),
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
              'version 1.0.7',
              style: TextStyle(
                  fontSize: 15,
                  color: APP_COLORS.Primary,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  textAlign: TextAlign.justify,
                  " Adlitem originates out of the need for modernization and cost efficiency in the litigation support industry. We are proud to be the first full-service platform designed to meet the industry requirements in the digital and interconnected environment of the 21st Century. Using state-or-the-art technology to optimize its operation, Adlitem connects Clients and Providers on their terms, in a free market environment where they can exchange their needs and services fast, efficiently and securely as well as build up on their individual network to obtain coverage for every stage of litigation, from filing and discovery to settlement or trial.",
                  style: TextStyle(
                    fontSize: 15,
                    color: APP_COLORS.Primary,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Attorneys',
              style: TextStyle(
                  fontSize: 15,
                  color: APP_COLORS.Primary,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  textAlign: TextAlign.justify,
                  "Works with independent providers at their personal rates to promote competitiveness and quality and offer a cost efficient support to your litigation. Whether it’s a court reporter, interpreter or translator that you need, you may find it in our network: the right one for your case, at the right price. ",
                  style: TextStyle(
                    fontSize: 15,
                    color: APP_COLORS.Primary,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Providers',
              style: TextStyle(
                  fontSize: 15,
                  color: APP_COLORS.Primary,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  textAlign: TextAlign.justify,
                  "You will be pleased to find in Adlitem the opportunity to offer your services in the legal industry, at your own rate, the one that’s fair for you and right for your qualifications without any intermediaries. With us, you can adjust your rates to meet the market requirements every time you need to, you can make yourself available whenever you have time to work and wherever you are and with a premium monthly membership for less than a cup of coffee, you can build up on your own network of clients allowing them to reach you first every time they post a job. ",
                  style: TextStyle(
                    fontSize: 15,
                    color: APP_COLORS.Primary,
                  ),
                )),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  textAlign: TextAlign.center,
                  "We’ll be honest! The only thing we’re missing is you! Join today!",
                  style: TextStyle(
                      fontSize: 15,
                      color: APP_COLORS.Primary,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  textAlign: TextAlign.center,
                  "All rights reserved",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      )),
    );
  }
}
