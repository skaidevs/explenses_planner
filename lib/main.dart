import 'dart:io';

import 'package:explenses_planner/models/transaction.dart';
import 'package:explenses_planner/widgets/chart.dart';
import 'package:explenses_planner/widgets/new_transaction.dart';
import 'package:explenses_planner/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense',
      theme: ThemeData(
        errorColor: Colors.redAccent,
        primarySwatch: Colors.teal,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20.0,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
//    Transaction(
//      id: '1',
//      title: 'New Shoes',
//      amount: 126.9,
//      date: DateTime.now(),
//    ),
//    Transaction(
//      id: '2',
//      title: 'Shirts',
//      amount: 536.9,
//      date: DateTime.now(),
//    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newText = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newText);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(addTransaction: _addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _startAddNewTransaction(context);
                  },
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ))
        : AppBar(
            title: Text("Expenses"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _startAddNewTransaction(context);
                  }),
            ],
          );
    final transactionList = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTx: _deleteTransaction,
      ),
    );
    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ignore: sdk_version_ui_as_code
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart', style: Theme.of(context).textTheme.title),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandscape) // ignore: sdk_version_ui_as_code
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(
                recentTransactions: _recentTransactions,
              ),
            ),
          // ignore: sdk_version_ui_as_code
          if (!isLandscape)
            transactionList,
          if (isLandscape) // ignore: sdk_version_ui_as_code
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(
                      recentTransactions: _recentTransactions,
                    ),
                  )
                : transactionList,
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                    child: Icon(Icons.add),
                  ),
          );
  }
}
