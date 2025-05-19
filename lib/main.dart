import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/transaction_chart.dart';
import 'add_transaction_screen.dart';

void main() => runApp(FinanceTrackerApp());

class FinanceTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _transactions = [];

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = {
      'id': DateTime.now().toString(), // Unique ID
      'title': title,
      'amount': amount,
      'date': date,
    };

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx['id'] == id);
    });
  }

  void _openAddTransactionScreen(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          onAddTransaction: _addNewTransaction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
      ),
      body: Column(
        children: [
          TransactionChart(_transactions),
          Expanded(
            child: _transactions.isEmpty
                ? Center(child: Text('No transactions added yet!'))
                : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (ctx, index) {
                final tx = _transactions[index];
                return Card(
                  elevation: 3,
                  margin:
                  EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.indigo,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            'Rs ${tx['amount'].toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      tx['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    Text(DateFormat.yMMMd().format(tx['date'])),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.redAccent,
                      onPressed: () => _deleteTransaction(tx['id']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransactionScreen(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
