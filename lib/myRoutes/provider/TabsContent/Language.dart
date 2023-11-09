import 'package:adlitem_flutter/constants/colors.dart';
import 'package:adlitem_flutter/helpers/AppMessage.dart';
import 'package:adlitem_flutter/models/Fixed.dart';
import 'package:adlitem_flutter/models/ProviderLanguage.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:adlitem_flutter/providers/AppProvider.dart';
import 'package:adlitem_flutter/services/providerServices/LanguageService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  List<LanguageModel> checkBoxListTileModel = LanguageModel.getLanguages();
  var list = <ProviderLanguage>[];
  SystemAccount u = SystemAccount();
  var selLangs = [];
  List<LanguageModel> langList = [];
  bool isLoading = false;

  @override
  void initState() {
    u = context.read<AppProvider>().getLoggedUser();
    readSelLangs();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  readSelLangs() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map _listUser = await LanguageService().GetbyUser(u);
      //print(_listUser);

      if (_listUser['success'] == 0) {
        setState(() {
          isLoading = false;
        });
        return Container(child: Text("No Data"));
      }
      if (mounted)
        setState(() {
          selLangs = _listUser['data'];
        });
      list = [];
      for (int i = 0; i < selLangs.length; i++) {
        for (int j = 0; j < checkBoxListTileModel.length; j++) {
          if (checkBoxListTileModel[j].id == selLangs[i]['languageId']) {
            checkBoxListTileModel[j].isCheck = true;
            list.add(ProviderLanguage(
                languageId: selLangs[i]['languageId'],
                systemaccountId: u.systemaccountId,
                code: selLangs[i]['code'],
                language: selLangs[i]['name']));
          }
        }
      }
      if (mounted)
        setState(() {
          isLoading = false;
        });
    } catch (e) {
      AppMessage.ShowError(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          save();
        },
        label: Text("Save"),
        icon: Icon(Icons.check),
        backgroundColor: APP_COLORS.Primary,
      ),
      appBar: AppBar(
        title: Text(
          "Languages",
          style: TextStyle(
              color: APP_COLORS.Primary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Stack(alignment: FractionalOffset.center, children: [
        Container(
            padding: EdgeInsets.all(2),
            child: ListView.builder(
                itemCount: checkBoxListTileModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                          color: Color.fromARGB(255, 241, 238, 238),
                          width: 3.0,
                          style: BorderStyle.solid),
                    ),
                    child: Column(children: <Widget>[
                      new CheckboxListTile(
                        checkboxShape: CircleBorder(side: BorderSide.none),
                        //tileColor: Colors.blue[100],
                        activeColor: Color.fromARGB(255, 76, 9, 139),
                        dense: true,
                        //font change
                        title: new Text(
                          checkBoxListTileModel[index].name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                        value: checkBoxListTileModel[index].isCheck,
                        secondary: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/images/' +
                              checkBoxListTileModel[index].code.toUpperCase() +
                              '.png'),
                        ),
                        onChanged: (bool? value) {
                          itemChange(value, index);
                        },
                      )
                    ]),
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

  save() async {
    setState(() {
      isLoading = true;
    });
    var jsonList = [];
    var jsonLang = {};
    for (int i = 0; i < list.length; i++) {
      jsonLang = {
        'systemaccountId': list[i].systemaccountId,
        'languageId': list[i].languageId,
        'code': list[i].code.toUpperCase(),
        'name': list[i].language
      };
      jsonList.add(jsonLang);
    }
    var _data = {"langs": jsonList, "systemaccountId": u.systemaccountId};

    if (list.length <= 0) {
      AppMessage.ShowInfo("Select languages", context);
      return;
    }
    var res = await LanguageService().Create(_data);

    if (res['success'] == -1) {
      //AppMessage.ShowError(res['message'], context);
      setState(() {
        isLoading = false;
      });
    } else if (res['success'] == 0) {
      AppMessage.ShowError(res['message'], context);
      setState(() {
        isLoading = false;
      });
    } else if (res['success'] == 1) {
      setState(() {
        isLoading = false;
      });
      //_formKey.currentState!.reset();
      //readListOffices();
      AppMessage.ShowInfo(res['message'], context);
    } else {
      //AppMessage.ShowInfo(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
  }

  void itemChange(bool? val, int index) async {
    setState(() {
      checkBoxListTileModel[index].isCheck = val!;
    });
    ProviderLanguage item = new ProviderLanguage(
        systemaccountId: this.u.systemaccountId,
        languageId: checkBoxListTileModel[index].id,
        language: checkBoxListTileModel[index].name,
        code: checkBoxListTileModel[index].code);
    if (val == true) {
      list.add(item);
    } else {
      list.removeWhere(
        (e) => e.languageId == item.languageId,
      );
    }
  }
}
