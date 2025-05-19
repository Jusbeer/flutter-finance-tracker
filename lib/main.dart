import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _transactions = [];

  // Adds a new transaction to the list
  void _addNewTransaction(String title, double amount, DateTime date) {
    setState(() {
      _transactions.add({
        'title': title,
        'amount': amount,
        'date': date,
      });
    });
  }

  // Opens the Add Transaction screen
  void _openAddTransactionScreen(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) =>
            AddTransactionScreen(onAddTransaction: _addNewTransaction),
      ),
    );
  }

  // Calculates total spending
  double get _totalSpending {
    return _transactions.fold(0.0, (sum, tx) => sum + tx['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
      ),
      body: Column(
        children: [
          // 🧾 Total Spending Summary Card
          Card(
            margin: EdgeInsets.all(16),
            elevation: 3,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Spending',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rs ${_totalSpending.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          // 📋 Transaction List or Empty Message
          Expanded(
            child: _transactions.isEmpty
                ? Center(
              child: Text(
                'No transactions added yet!',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (ctx, index) {
                final tx = _transactions[index];
                return Card(
                  margin:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.indigo,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
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
                    subtitle: Text(
                      DateFormat.yMMMMd().format(tx['date']),
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
