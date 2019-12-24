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
        primaryColor: const Color(0xFF448AFF),
        accentColor: const Color(0xFF448AFF),
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

  String _outputFinalValue;

  //bool _active false;

  final d = Decimal.tryParse;

  //入力項目のコントローラ

  var _controllerCurrentBalance = TextEditingController();
  var _controllerMonthlyAddition = TextEditingController();
  var _controllerInterestRateYear = TextEditingController();
  var _controllerPeriodYear = TextEditingController();

  //List<String> valueList = ['1ヶ月ごと', '2ヶ月ごと', '6ヶ月ごと', '12ヶ月ごと'];
  String _value;

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
/*    var inputCurrentBalance = d(_inputCurrentBalance);
    var inputMonthlyAddition = d(_inputMonthlyAddition);
    var inputInterestRateYear = d(_inputInterestRateYear);
    var inputPeriodYear = d(_inputPeriodYear);
    var inputInterestRateYearNum =
    d((inputInterestRateYear.toDouble() / 100 + 1).toString());
    var inputInterestRateMonth =
        (pow(inputInterestRateYearNum.toDouble(), d('0.0833333').toDouble()) *
            10000)
            .round() /
            10000;

    calcValue(inputCurrentBalance, inputMonthlyAddition, inputInterestRateMonth,
        inputPeriodYear);
*/
    this.setState(() {
      _controllerCurrentBalance.clear();
      _controllerMonthlyAddition.clear();
      _controllerInterestRateYear.clear();
      _controllerPeriodYear.clear();
    });
  }

  void calcValue(var a, var b, var c, var d) {}

  @override
  void initState() {
    _inputCurrentBalance = 'OK';
    _outputFinalValue = 'NG';
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
                              icon: Icon(
                                Icons.attach_money,
                                size: 35.0,
                              ),
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
                                fontWeight: FontWeight.w600,
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
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 35.0,
                              ),
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
                                fontWeight: FontWeight.w600,
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
                              icon: Icon(
                                Icons.cached,
                                size: 35.0,
                              ),
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
                                fontWeight: FontWeight.w600,
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
                              icon: Icon(
                                Icons.schedule,
                                size: 35.0,
                              ),
                              fillColor: Colors.blueAccent,
                              hoverColor: Colors.blueAccent,
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
                                fontWeight: FontWeight.w600,
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
                          child: Row(children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                "積立タイプ",
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Roboto",
                                    color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButton(
                                value: _value,
                                items: [
                                  DropdownMenuItem(
                                    value: "1",
                                    child: Text(
                                      "1ヶ月ごと",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Roboto",
                                          color: Colors.black54),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "2",
                                    child: Text(
                                      "2ヶ月ごと",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Roboto",
                                          color: Colors.black54),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "6",
                                    child: Text(
                                      "6ヶ月ごと",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Roboto",
                                          color: Colors.black54),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "12",
                                    child: Text(
                                      "12ヶ月ごと",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Roboto",
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                                iconEnabledColor: Colors.blueAccent,

                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            "投資総額：" + _outputFinalValue + "万円",
                            style: TextStyle(
                              fontSize: 26.0,
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
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            "増加率　：" + _inputCurrentBalance + "％",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 70.0),
                          child: RaisedButton.icon(
                            highlightElevation: 16.0,
                            highlightColor: Colors.orangeAccent,
                            splashColor: Colors.purple,
                            icon: Icon(
                              Icons.restore_from_trash,
                              color: Colors.blueGrey,
                              size: 45.0,
                            ),
                            label: Text(
                              "数値をクリアする",
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                  color: Colors.blueGrey),
                            ),
                            color: Colors.white,
                            shape: Border(
                              top: BorderSide(color: Colors.red, width: 1.5),
                              left: BorderSide(color: Colors.blue, width: 1.5),
                              right:
                                  BorderSide(color: Colors.yellow, width: 1.5),
                              bottom:
                                  BorderSide(color: Colors.green, width: 1.5),
                            ),
                            onPressed: buttonPressed,
                          ),
                        ),
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
          onPressed: buttonPressed,
          icon: new Icon(
            Icons.tag_faces,
            size: 40.0,
          ),
          label: Text("GO!",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
                fontSize: 35.0,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
