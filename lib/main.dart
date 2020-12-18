import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

bool _switchVal = false;
final _lightTheme =
    ThemeData(brightness: Brightness.light, primaryColor: Colors.blueGrey);
final _darkTheme =
    ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      //theme: _switchVal ? _lightTheme : _darkTheme,
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget buildButton(String btnText) {
    return Expanded(
      child: FlatButton(
        padding: EdgeInsets.all(24.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        onPressed: () => {btnPressed(btnText)},
        onLongPress: () => {btnLongPressed(btnText)},
        child: Text(
          btnText,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  String DisValue = "";
  String FirstValue = "";
  var FirstvalLength;
  String SecondValue = "";
  String Operator = "";
  String Result = "";

 
  Calc() {
    if (Operator == "+") {
      try {
        Result = (int.parse(FirstValue) + int.parse(SecondValue)).toString();
      } on Exception catch (_) {
        Result =
            (double.parse(FirstValue) + double.parse(SecondValue)).toString();
      }
    } else if (Operator == "-") {
      try {
        Result = (int.parse(FirstValue) - int.parse(SecondValue)).toString();
      } on Exception catch (_) {
        Result =
            (double.parse(FirstValue) - double.parse(SecondValue)).toString();
      }
    } else if (Operator == "*") {
      try {
        Result = (int.parse(FirstValue) * int.parse(SecondValue)).toString();
      } on Exception catch (_) {
        Result =
            (double.parse(FirstValue) * double.parse(SecondValue)).toString();
      }
    } else if (Operator == "/") {
      try {
        Result = (int.parse(FirstValue) / int.parse(SecondValue)).toString();
      } on Exception catch (_) {
        Result =
            (double.parse(FirstValue) / double.parse(SecondValue)).toString();
      }
    }
  }

  btnLongPressed(String btntext) {
    setState(() {
      if (btntext == "C" || btntext == "<") {
        clear();
      }
    });
  }

  clear() {
    DisValue = "";
    FirstValue = "";
    Operator = "";
    Result = "";
  }

  btnPressed(String btntext) {
    print(btntext);
    setState(() {
      if (btntext == "C") {
        clear();
      } else if (btntext == "<") {
        if (DisValue == "") {
          return;
        }
        if (DisValue.length == 1) {
          DisValue = "";
          return;
        }
        if ((DisValue[DisValue.length - 1]) == "+" ||
            (DisValue[DisValue.length - 1]) == "-" ||
            (DisValue[DisValue.length - 1]) == "*" ||
            (DisValue[DisValue.length - 1]) == "/") {
          Operator = "";
        }

        DisValue = DisValue.substring(0, DisValue.length - 1);
        if ((DisValue[DisValue.length - 1]) == "+" ||
            (DisValue[DisValue.length - 1]) == "-" ||
            (DisValue[DisValue.length - 1]) == "*" ||
            (DisValue[DisValue.length - 1]) == "/") {
          SecondValue = "";
          Result = "";
        }

        if (SecondValue != "") {
          SecondValue = SecondValue.substring(0, SecondValue.length - 1);
          Calc();
        }
      } else if (DisValue.length >= 60) {
        if (DisValue.length == 61) {
          DisValue = DisValue.substring(0, DisValue.length - 1);
        }
        return;
      } else if (btntext == "=") {
        if (Operator == "") {
          return;
        }
        DisValue = Result;
        FirstValue = Result;
        FirstvalLength = FirstValue.length;
        Result = "";
        SecondValue = "";
        Operator = "";
      }
      // else if (Operator != "") {
      //   if (btntext == "+" ||
      //       btntext == "-" ||
      //       btntext == "*" ||
      //       btntext == "/") {
      //     Operator = btntext;
      //     DisValue = DisValue.substring(0, DisValue.length - 1) + btntext;
      //     print(DisValue);
      //     return;
      //   }
      // }
      else if (Operator != "") {
        if (btntext == "+" ||
            btntext == "-" ||
            btntext == "*" ||
            btntext == "/") {
          if (SecondValue == "") {
            return;
          }
          DisValue = (Result + btntext);
          FirstValue = Result;
          FirstvalLength = FirstValue.length;
          Operator = btntext;
          Result = "";
          if (btntext == "=") {
            DisValue = Result;
            FirstValue = Result;
            FirstvalLength = FirstValue.length;
            Result = "";
          }
        } else {
          if (btntext == ".") {
            if (SecondValue.contains(".")) {
              return;
            } else {
              DisValue += btntext;
              SecondValue = DisValue.substring(FirstvalLength + 1);
              return;
            }
          }
          DisValue += btntext;
          if (DisValue.length == 61) {
            DisValue = DisValue.substring(0, DisValue.length - 1);
          }
          SecondValue = DisValue.substring(FirstvalLength + 1);
          Calc();
        }
      } else if (btntext == "+" ||
          btntext == "-" ||
          btntext == "*" ||
          btntext == "/") {
        if (DisValue == "") {
          return;
        }
        FirstValue = DisValue;
        FirstvalLength = FirstValue.length;
        Operator = btntext;
        DisValue += btntext;
      } else if (btntext == ".") {
        if (DisValue.contains(".")) {
          return;
        } else {
          DisValue += btntext;
          if (DisValue.length == 61) {
            DisValue = DisValue.substring(0, DisValue.length - 1);
          }
        }
      } else {
        DisValue += btntext;
        if (DisValue.length == 61) {
          DisValue = DisValue.substring(0, DisValue.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
        actions: [
          Switch(
              value: _switchVal,
              onChanged: (newValue) {
                setState(() {
                  _switchVal = newValue;
                });
              })
        ],
      ),
      body: Container(
        child: Column(children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(15),
            child: Text(
              DisValue,
              style: TextStyle(fontSize: 45),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(15),
            child: Text(
              Result,
              style: TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(255, 255, 255, 0.7),
              ),
            ),
          ),
          Expanded(child: Divider()),
          Row(
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("/"),
            ],
          ),
          Row(
            children: [
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("*"),
            ],
          ),
          Row(
            children: [
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("-"),
            ],
          ),
          Row(
            children: [
              buildButton("0"),
              buildButton("."),
              buildButton("00"),
              buildButton("+"),
            ],
          ),
          Row(
            children: [
              buildButton("C"),
              buildButton("="),
              buildButton("<"),
            ],
          ),
        ]),
      ),
    );
  }
}
