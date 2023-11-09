import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/myRoutes/layout.dart';
import 'package:adlitem_flutter/myWidgets/klogin.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/SystemAccountService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/colors.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  SystemAccount user = new SystemAccount();

  @override
  void initState() {
    super.initState();

    CheckLoggedIn();
  }

  CheckLoggedIn() async {
    setState(() {
      isLoading = !isLoading;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    Map res = await SystemAccountService().getSystemAccountByEmail(email ?? '');
    if (res['success'] == -1) {
      setState(() {
        isLoading = !isLoading;
      });
    } else if (res['success'] == 0) {
      setState(() {
        isLoading = !isLoading;
      });
    } else if (res['success'] == 1) {
      if (mounted)
        setState(() {
          user.userGroup = res['data']['userGroup'];
          user.verificationToken = res['data']['verificationToken'];
          user.systemaccountId = res['data']['systemaccountId'];
          user.name = res['data']['name'];
          user.lastname = res['data']['lastname'];
          user.email = res['data']['email'];
          user.rate = res['data']['rate'];
          user.cancelAgree = res['data']['cancelAgree'] == 1 ? true : false;
        });
      context.read<AppProvider>().login(user);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      onGenerateRoute: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: APP_COLORS.Primary, centerTitle: true),
        primaryColor: APP_COLORS.Primary,
        hintColor: Colors.grey,
        popupMenuTheme: PopupMenuThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 16.0, fontFamily: 'Arial'),
            displaySmall:
                TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
      ),
      home: Scaffold(
        body: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height,
                      child: !app.user.isLogged
                          ? KLogin()
                          : Layout(role: app.user.userGroup),
                      // child: InternetConectivity(
                      //     widget: KLogin(title: "Welcome to Adlitem")),
                    )
                  ],
                ),
              ),
              if (isLoading)
                Container(
                    constraints: BoxConstraints.expand(),
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1)),
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              APP_COLORS.Primary),
                          backgroundColor: Color.fromARGB(0, 8, 6, 6),
                          semanticsLabel: "Wait...",
                          color: APP_COLORS.Primary,
                        ))),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/main') {
      return MaterialPageRoute(
        builder: (context) {
          return MyApp();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          return Text("NOT FOUND");
        },
      );
    }
  }
}
