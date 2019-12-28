import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'dart:math';

import 'package:keyboard_actions/keyboard_actions.dart';

void main() => runApp(new MyApp());

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

  //FocusNode
  final FocusNode _currentBalanceFocusNode = FocusNode(); // 入力項目：元本（万円）
  final FocusNode _monthlyAdditionFocusNode = FocusNode(); // 入力項目：積立金額（万円）
  final FocusNode _interestRateYearFocusNode = FocusNode(); // 入力項目：年利（％）
  final FocusNode _periodYearFocusNode = FocusNode(); // 入力項目：投資期間（年）

  //入力項目のコントローラ
  var _controllerCurrentBalance = TextEditingController(); // 入力項目：元本（万円）
  var _controllerMonthlyAddition = TextEditingController(); // 入力項目：積立金額（万円）
  var _controllerInterestRateYear = TextEditingController(); // 入力項目：年利（％）
  var _controllerPeriodYear = TextEditingController(); // 入力項目：投資期間（年）

  //onChanged時、コントローラ => Decimalで受けるインスタンス
  Decimal _inputCurrentBalance; // 入力項目：元本（万円）
  Decimal _inputMonthlyAddition; // 入力項目：積立金額（万円）
  Decimal _inputInterestRateYear; // 入力項目：年利（％）
  Decimal _inputPeriodYear; // 入力項目：投資期間（年）

  Decimal _inputInterestRateYearActualNumber; // 年利（実数）
  Decimal _inputInterestRateMonthActualNumber; // 月利（実数）

  //積立タイプ
  String _additionalType; // Xヶ月。文字列。1,2,6,12の４パターン

  //試験的に使ってみる変数たち
  String _outputFinalValue;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //bool _active false;

  final d = Decimal.tryParse;

  //List<String> valueList = ['1ヶ月ごと', '2ヶ月ごと', '6ヶ月ごと', '12ヶ月ごと'];
  //String _additionalType = '1';

  //KeyboardActionsConfig
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

  //項目設定メソッド
  void setDecimalCurrentBalance(String value) {
    this.setState(() {
      _inputCurrentBalance = Decimal.parse(_controllerCurrentBalance.text);
    });
    print(_inputCurrentBalance);
  }

  void setDecimalMonthlyAddition(String value) {
    this.setState(() {
      _inputMonthlyAddition = Decimal.parse(_controllerMonthlyAddition.text);
    });
    print(_inputMonthlyAddition);
  }

  void setDecimalInterestRateYear(String value) {
    this.setState(() {
      _inputInterestRateYear = Decimal.parse(_controllerInterestRateYear.text);
      _inputInterestRateYearActualNumber =
          _inputInterestRateYear / Decimal.fromInt(100) + Decimal.fromInt(1);
      _inputInterestRateMonthActualNumber = Decimal.parse(((pow(
                          _inputInterestRateYearActualNumber.toDouble(),
                          double.parse('0.0833333')) *
                      10000)
                  .round() /
              10000)
          .toString());
    });
    print(_inputInterestRateYear);
    print(_inputInterestRateYearActualNumber);
    print(_inputInterestRateMonthActualNumber);
  }

  void setDecimalPeriodYear(String value) {
    this.setState(() {
      _inputPeriodYear = Decimal.parse(_controllerPeriodYear.text);
    });
    print(_inputPeriodYear);
  }

  //GOボタン押下処理
  void buttonPressed() {
    //入力チェック
    if ((_controllerCurrentBalance.text == '') ||
        (_controllerInterestRateYear.text == '') ||
        (_controllerPeriodYear.text == '')) {
      print('入力エラー');
      final snackBarInputError = SnackBar(
        content: Text('条件を入れてね！'),
        action: SnackBarAction(
          label: 'すみません（汗）',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      _scaffoldKey.currentState.showSnackBar(snackBarInputError);
    } else {
      //メイン処理コール
      calcValueMain();
    }
  }

  //メイン処理
  void calcValueMain() {
    //積立金額埋め
    if (_controllerMonthlyAddition.text == '') {
      this.setState(() {
        _inputMonthlyAddition = Decimal.parse('0');
      });
    }

    print(_inputCurrentBalance);
    print(_inputMonthlyAddition);
    print(_inputInterestRateYear);
    print(_inputInterestRateYearActualNumber);
    print(_inputInterestRateMonthActualNumber);
    print(_inputPeriodYear);

    //積立タイプごとに計算分岐
    switch (_additionalType) {
      case '1':
        {
          calcValueStandard(
            _inputCurrentBalance,
            _inputMonthlyAddition,
            _inputInterestRateMonthActualNumber,
            _inputPeriodYear,
          );
        }
        break;
      case '2':
        {
          calcValueTwiceMonth(
            _inputCurrentBalance,
            _inputMonthlyAddition,
            _inputInterestRateMonthActualNumber,
            _inputPeriodYear,
          );
        }
        break;
      case '6':
        {
          calcValueHalfYear(
            _inputCurrentBalance,
            _inputMonthlyAddition,
            _inputInterestRateMonthActualNumber,
            _inputPeriodYear,
          );
        }
        break;
      case '12':
        {
          calcValueOneYear(
            _inputCurrentBalance,
            _inputMonthlyAddition,
            _inputInterestRateMonthActualNumber,
            _inputPeriodYear,
          );
        }
        break;
      default:
        {
          print('積立タイプ例外エラー');
        }
        break;
    }
  }

  void calcValueStandard(
    Decimal a,
    Decimal b,
    Decimal c,
    Decimal d,
  ) {
    /*ここに計算を書く*/
  }

  void calcValueTwiceMonth(
    Decimal a,
    Decimal b,
    Decimal c,
    Decimal d,
  ) {
    /*ここに計算を書く*/
  }

  void calcValueHalfYear(
    Decimal a,
    Decimal b,
    Decimal c,
    Decimal d,
  ) {
    /*ここに計算を書く*/
  }

  void calcValueOneYear(
    Decimal a,
    Decimal b,
    Decimal c,
    Decimal d,
  ) {
    /*ここに計算を書く*/
  }

  //数値クリア処理
  void allClear() {
    _currentBalanceFocusNode.unfocus();
    _monthlyAdditionFocusNode.unfocus();
    _interestRateYearFocusNode.unfocus();
    _periodYearFocusNode.unfocus();
    this.setState(() {
      _controllerCurrentBalance.clear();
      _controllerMonthlyAddition.clear();
      _controllerInterestRateYear.clear();
      _controllerPeriodYear.clear();
      this._additionalType = '1';
      this._inputCurrentBalance = null;
      this._inputMonthlyAddition = null;
      this._inputInterestRateYear = null;
      this._inputPeriodYear = null;
      this._inputInterestRateMonthActualNumber = null;
      this._inputInterestRateYearActualNumber = null;
    });
    final snackBarClear = SnackBar(
      content: Text('クリアしました！'),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    _scaffoldKey.currentState.showSnackBar(snackBarClear);
  }

  @override
  void initState() {
    _additionalType = '1';
    _outputFinalValue = 'NG';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false, // キーボード出現によるWidget高さ自動調整をオフ
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0), // here the desired height
          child: AppBar(
            title: const Text('iCC 複利計算',
                style: TextStyle(
                  fontFamily: 'Roboto',
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
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Center(
                            child: Text(
                              '計算条件',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '元本（万円）',
                              hintText: '数値を入力',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixText: '万円',
                              suffixStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  height: 0.8,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto'),
                              icon: Icon(
                                Icons.attach_money,
                                size: 35.0,
                              ),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: '',
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
                                fontFamily: 'Roboto'),
                            onChanged: setDecimalCurrentBalance,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '積立金額（万円）',
                              hintText: '数値を入力',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixText: '万円',
                              suffixStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  height: 0.8,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto'),
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 35.0,
                              ),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: '',
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
                                fontFamily: 'Roboto'),
                            onChanged: setDecimalMonthlyAddition,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '年利（％）',
                              hintText: '数値を入力',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixText: '％',
                              suffixStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  height: 0.8,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto'),
                              icon: Icon(
                                Icons.cached,
                                size: 35.0,
                              ),
                              fillColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: '',
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
                                fontFamily: 'Roboto'),
                            onChanged: setDecimalInterestRateYear,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '投資期間（年）',
                              hintText: '数値を入力',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixText: '年',
                              suffixStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  height: 0.8,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto'),
                              icon: Icon(
                                Icons.schedule,
                                size: 35.0,
                              ),
                              fillColor: Colors.blueAccent,
                              hoverColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              counterText: '',
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
                                fontFamily: 'Roboto'),
                            onChanged: setDecimalPeriodYear,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                '積立タイプ',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButton(
                                value: _additionalType,
                                items: [
                                  DropdownMenuItem(
                                    value: '1',
                                    child: Text(
                                      '1ヶ月ごと',
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: Colors.black54),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '2',
                                    child: Text(
                                      '2ヶ月ごと',
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: Colors.black54),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '6',
                                    child: Text(
                                      '6ヶ月ごと',
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: Colors.black54),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '12',
                                    child: Text(
                                      '12ヶ月ごと',
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _additionalType = value;
                                  });
                                },
                                iconEnabledColor: Colors.blueAccent,
                              ),
                            ),
                          ]),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Center(
                            child: Text(
                              '計算結果',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            '投資総額：' + _outputFinalValue + '万円',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            '最終金額：' + _outputFinalValue + '万円',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: Text(
                            '増加率　：' + _outputFinalValue + '％',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 120.0),
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
                              '条件をクリアする',
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: Colors.blueGrey),
                            ),
                            color: Colors.white,
                            shape: Border(
                              top: BorderSide(color: Colors.red, width: 2.0),
                              left: BorderSide(color: Colors.blue, width: 2.0),
                              right:
                                  BorderSide(color: Colors.yellow, width: 2.0),
                              bottom:
                                  BorderSide(color: Colors.green, width: 2.0),
                            ),
                            onPressed: allClear,
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
          label: Text('GO!',
              style: TextStyle(
                fontFamily: 'Roboto',
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
