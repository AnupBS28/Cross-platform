import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Home());
  });
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyApp();
  }
}

class MyApp extends State<Home> {
  // This widget is the root of your application.
  var prvOperandState = '';
  var prevExpression;
  var oldexprn = '';
  double oldres = 0;
  var operand = '';
  bool operator = true;
  var evaluate = false;
  double resultt = 0;
  bool resultActive = false;

  evaluateExpr(String expr) {
    int exprLen = expr.length;
    int i = 0;
    List<double> operand = List();
    List operators = List();

    int numberStartIndx = 0;
    int numberEndIndex = 0;
    while (i < exprLen) {
      print('while i:${i} exprLen: ${exprLen}');
      var ipchar = expr[i];
      var type = getType(ipchar);
      if ((i == 0 || i == exprLen - 1) && type == -1) {
        i++;
        continue;
      }

      if (type == 0) //operand
      {
        numberEndIndex++;
      } else if (type == -1) {
        operators.add(ipchar);
        if (numberEndIndex != numberStartIndx) {
          operand.add(double.parse(
              this.operand.substring(numberStartIndx, numberEndIndex)));
        }
        numberStartIndx = i + 1;
        numberEndIndex = numberStartIndx;
      }
      i++;
    }
    operand.add(
        double.parse(this.operand.substring(numberStartIndx, numberEndIndex)));

    print(operand);
    print(operators);

    double res = 0;

    int j = 0;
    for (int i = 0; i < operand.length - 1; i++) {
      double x1 = operand[i];
      double x2 = operand[i + 1];
      var operation = operators[j];
      j++;
      switch (operation) {
        case '+':
          res = x1 + x2;
          break;

        case '-':
          res = x1 - x2;
          break;

        case 'x':
          res = x1 * x2;
          break;

        case '/':
          res = x1 / x2;
          break;

        case '%':
          res = x1 % x2;
          break;
      }

      operand[i + 1] = res;
    }

    return operand[operand.length - 1];
  }

  getType(var inp) {
    //0 integer , 1 clear screen , 2 delete single digit ,3 evaluate ,4 floating number , -1 operator
    try {
      var x = int.parse(inp);
      return 0;
    } catch (e) {
      if (inp == 'AC')
        return 1;
      else if (inp == 'Del') {
        return 2;
      } else if (inp == '=') {
        return 3;
      } else if (inp == '.') {
        return 4;
      } else if (inp == '<>') return 5;
      return -1;
    }
  }

  callback(operandd) {
    //print("myapp${operandd}");
    var inptype = getType(operandd); //0 integer , 1 clear screen ,
    // 2 delete single digit ,3 evaluate ,4 floating number , -1 operator

    setState(() {
      this.prvOperandState = this.operand;

      var strng = this.operand;
      int strngLen = strng.length;

      if (strngLen != 0 && getType(strng[strngLen - 1]) == -1) {
        this.operator = true;
      }
      if (inptype == 0) {
        this.operator = false;
      }
      if ((inptype == 0 || inptype == -1 || inptype == 4) && !this.operator) {
        this.operand = this.operand + operandd;
      } else if (inptype == 1) {
        this.oldexprn = this.prevExpression;
        this.oldres = resultt;
        this.operand = '';
        this.resultt = 0;
      } else if (inptype == 2) {
        if (strngLen >= 2) {
          this.operand = strng.substring(0, strngLen - 1);
        } else if (strngLen <= 1) this.operand = '';

        if (operand.length >= 1 &&
            getType(this.operand[this.operand.length - 1]) != -1) {
          this.operator = false;
        }
      }

      if (inptype == 3) {
        double res = evaluateExpr(operand);
        this.prevExpression = operand;
        this.resultt = res;
        this.resultActive = true;
      } else
        this.resultActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calculator'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black87,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      oldexprn,
                      style: TextStyle(color: Colors.white30, fontSize: 15),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      oldres.toString(),
                      style: TextStyle(color: Colors.white30, fontSize: 17),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white30,
                  thickness: .3,
                  indent: 130,
                  endIndent: 0,
                  height: 10,
                  key: Key('hellomm'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      operand,
                      style: TextStyle(
                        fontSize: resultActive ? 20 : 40,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      resultActive && resultt.toString() != '0'
                          ? '=' + resultt.toString()
                          : resultt.toString(),
                      style: TextStyle(fontSize: resultActive ? 60 : 30),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white30,
                  thickness: .5,
                  indent: 1,
                  endIndent: 1,
                  height: 10,
                  key: Key('hello'),
                ),
                Table(

                    //border: TableBorder.all(color: Colors.white30),
                    defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                    children: <TableRow>[
                      TableRow(children: <Widget>[
                        Appcell(
                            text: 'AC',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: 'Del',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '%',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '/',
                            callback: this.callback,
                            getType: this.getType),
                      ]),
                      TableRow(children: <Widget>[
                        Appcell(
                            text: '7',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '8',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '9',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: 'x',
                            callback: this.callback,
                            getType: this.getType),
                      ]),
                      TableRow(children: <Widget>[
                        Appcell(
                            text: '4',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '5',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '6',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '-',
                            callback: this.callback,
                            getType: this.getType),
                      ]),
                      TableRow(children: <Widget>[
                        Appcell(
                            text: '1',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '2',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '3',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '+',
                            callback: this.callback,
                            getType: this.getType),
                      ]),
                      TableRow(children: <Widget>[
                        Appcell(
                            text: '',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '0',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '.',
                            callback: this.callback,
                            getType: this.getType),
                        Appcell(
                            text: '=',
                            callback: this.callback,
                            getType: this.getType),
                      ])
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//class Appcell extends StatefulWidget {
//  Appcell({this.text});
//  var text;
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return Cell(text: text);
//  }
//}

class Appcell extends StatelessWidget {
  Appcell({this.text, this.callback, this.getType});
  final String text;
  final Function getType;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var type = getType(text); //0 integer , 1 clear screen ,
    // 2 delete single digit ,3 evaluate ,4 floating number , -1 operator
    return Container(
      //color: Colors.green,
      width: text == '0' ? 70 : 35,
      child: RaisedButton(
        color: text == '=' ? Colors.deepOrangeAccent : Colors.black87,
        shape: RoundedRectangleBorder(
            borderRadius: type == 3
                ? BorderRadius.circular(45)
                : BorderRadius.circular(0)),
        padding: EdgeInsets.all(23),
        onPressed: () {
          //print(text);
          callback(text);
        },
        child: Text(
          text.toString(),
          textAlign: text == '=' ? TextAlign.center : TextAlign.justify,
          style: TextStyle(
              color: type == -1 || type == 1 || type == 2
                  ? Colors.deepOrangeAccent
                  : Colors.white70,
              fontSize: 25),
        ),
      ),
    );
  }
}
