import 'package:explenses_planner/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList({Key key, this.transactions, this.deleteTx})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No Transaction yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                  Container(
                    child: Image.asset('images/waiting.png'),
                    height: constraints.maxHeight * 0.6,
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (cxt, index) {
              return Card(
                elevation: 2,
                margin: EdgeInsets.all(4),
                child: ListTile(
                  leading: Container(
                    width: 110,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          '\$${transactions[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  title: Text(transactions[index].title,
                      style: Theme.of(context).textTheme.title),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () => deleteTx(transactions[index].id),
                          label: Text('delete'),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () => deleteTx(transactions[index].id),
                        ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}

//Card(
//child: Row(
//children: <Widget>[
//Container(
//child: Text(
//'\$${transactions[index].amount.toStringAsFixed(2)}',
//style: TextStyle(
//color: Theme.of(context).primaryColor,
//fontWeight: FontWeight.bold),
//),
//decoration: BoxDecoration(
//border: Border.all(
//color: Theme.of(context).primaryColor,
//width: 2,
//),
//),
//padding: EdgeInsets.all(20),
//margin: EdgeInsets.symmetric(
//vertical: 10,
//horizontal: 15,
//),
//),
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text(transactions[index].title,
//style: Theme.of(context).textTheme.title),
//Text(
//DateFormat.yMMMd().format(transactions[index].date),
//style: TextStyle(
//fontSize: 12.0,
//color: Colors.grey,
//),
//),
//],
//),
//],
//),
//);
