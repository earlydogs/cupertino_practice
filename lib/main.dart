import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _tab = <Tab>[
    Tab(text: 'Input', icon: Icon(Icons.attach_money)),
    Tab(text: 'Graph', icon: Icon(Icons.trending_up)),
    Tab(text: 'Table', icon: Icon(Icons.view_list)),
  ];

  final FocusNode _currentBalanceFocusNode = FocusNode();
  final FocusNode _monthlyAdditionFocusNode = FocusNode();
  final FocusNode _interestRateYearFocusNode = FocusNode();
  final FocusNode _periodYearFocusNode = FocusNode();

  String _inputCurrentBalance;
  String _inputMonthlyAddition;
  String _inputInterestRateYear;
  String _inputPeriodYear;

  final d = Decimal.tryParse;

  //入力項目のコントローラ

  var _controllerCurrentBalance = TextEditingController();
  var _controllerMonthlyAddition = TextEditingController();
  var _controllerInterestRateYear = TextEditingController();
  var _controllerPeriodYear = TextEditingController();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[100],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _currentBalanceFocusNode,
        ),
        KeyboardAction(
          focusNode: _monthlyAdditionFocusNode,
        ),
        KeyboardAction(
          focusNode: _interestRateYearFocusNode,
        ),
        KeyboardAction(
          focusNode: _periodYearFocusNode,
        ),
      ],
    );
  }

  void buttonPressed() {
    //big decimal で受け取る。が、Doubleで計算しちゃう。。
//    var inputCurrentBalance = d(_controllerCurrentBalance.text);
//    var inputMonthlyAddition = d(_controllerMonthlyAddition.text);
//    var inputInterestRateYear = d(_controllerInterestRateYear.text);
//    var inputPeriodYear = d(_controllerPeriodYear.text);
//    var inputInterestRateYearNum =
//    d((inputInterestRateYear.toDouble() / 100 + 1).toString());
//    var inputInterestRateMonth =
//        (pow(inputInterestRateYearNum.toDouble(), d('0.0833333').toDouble()) *
//            10000)
//            .round() /
//            10000;

//    calcValue(inputCurrentBalance, inputMonthlyAddition, inputInterestRateMonth,
//        inputPeriodYear);

    setState(() {
      _inputCurrentBalance = _controllerCurrentBalance.text;
    });
  }

  void calcValue(var a, var b, var c, var d) {}

  @override
  void initState() {
    _inputCurrentBalance = 'OK';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // キーボード出現によるWidget高さ自動調整をオフ
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0), // here the desired height
          child: AppBar(
            title: const Text('iCC 複利計算',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                )),
            bottom: TabBar(
              //isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: _tab,
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(children: <Widget>[
            KeyboardActions(
              config: _buildConfig(context),
              child: GestureDetector(
                onTap: () {
                  _currentBalanceFocusNode.unfocus();
                  _monthlyAdditionFocusNode.unfocus();
                  _interestRateYearFocusNode.unfocus();
                  _periodYearFocusNode.unfocus();
                },
                child: Card(
                  margin: EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "元本（万円）",
                              hintText: "数値で入力してください",
                              icon: Icon(Icons.attach_money),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: "",
                            ),
                            controller: _controllerCurrentBalance,
                            keyboardType: TextInputType.number,
                            focusNode: _currentBalanceFocusNode,
                            maxLength: 8,
                            maxLengthEnforced: true,
                            style: TextStyle(
                                fontSize: 16.0,
                                height: 0.8,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                            onChanged: (controller) {
                              setState(() {
                                _inputCurrentBalance =
                                    _controllerCurrentBalance.text;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "積立金額（万円）",
                              hintText: "数値で入力してください",
                              icon: Icon(Icons.add_circle_outline),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: "",
                            ),
                            controller: _controllerMonthlyAddition,
                            keyboardType: TextInputType.number,
                            focusNode: _monthlyAdditionFocusNode,
                            maxLength: 8,
                            maxLengthEnforced: true,
                            style: TextStyle(
                                fontSize: 16.0,
                                height: 0.8,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                            onChanged: (controller) {
                              setState(() {
                                _inputMonthlyAddition =
                                    _controllerMonthlyAddition.text;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "年利（％）",
                              hintText: "数値で入力してください",
                              icon: Icon(Icons.cached),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: "",
                            ),
                            controller: _controllerInterestRateYear,
                            keyboardType: TextInputType.number,
                            focusNode: _interestRateYearFocusNode,
                            maxLength: 5,
                            maxLengthEnforced: true,
                            style: TextStyle(
                                fontSize: 16.0,
                                height: 0.8,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                            onChanged: (controller) {
                              setState(() {
                                _inputInterestRateYear =
                                    _controllerInterestRateYear.text;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "投資期間（年）",
                              hintText: "数値で入力してください",
                              icon: Icon(Icons.schedule),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: "",
                            ),
                            controller: _controllerPeriodYear,
                            keyboardType: TextInputType.number,
                            focusNode: _periodYearFocusNode,
                            maxLength: 5,
                            maxLengthEnforced: true,
                            style: TextStyle(
                                fontSize: 16.0,
                                height: 0.8,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                            onChanged: (controller) {
                              setState(() {
                                _inputPeriodYear = _controllerPeriodYear.text;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: FlatButton(
                            padding: EdgeInsets.all(15.0),
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text(
                              "複利計算",
                              style: TextStyle(
                                  fontSize: 19.0,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                  color: Colors.white),
                            ),
                            onPressed: buttonPressed,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            "投資総額：" + _inputCurrentBalance + "万円",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            "最終金額：" + _inputCurrentBalance + "万円",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 70.0),
                          child: Text(
                            "増加率　：" + _inputCurrentBalance + "％",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TabPage(title: 'Graph', icon: Icons.trending_up),
            TabPage(title: 'Table', icon: Icons.view_list),
          ]),
        ),
        drawer: Drawer(child: ListView()),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            this.setState(() {
              _controllerCurrentBalance.clear();
              _controllerMonthlyAddition.clear();
              _controllerInterestRateYear.clear();
              _controllerPeriodYear.clear();
            });
          },
          icon: new Icon(Icons.done),
          label: Text("数値をクリアする",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final IconData icon;
  final String title;

  const TabPage({Key key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 72.0, color: textStyle.color),
            Text(title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
