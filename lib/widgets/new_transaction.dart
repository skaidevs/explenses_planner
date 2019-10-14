import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction({@required this.addTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    try {
      widget.addTransaction(
        enteredTitle,
        enteredAmount,
        _selectedDate,
      );
    } catch (e) {
      e.toString();
    }

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Titile'),
                controller: titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date chosen'
                            : 'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            onPressed: _presentDatePicker,
                            child: Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : FlatButton(
                            onPressed: _presentDatePicker,
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
                child: Text(
                  'Add Transaction',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
