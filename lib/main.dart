// main.dart
import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/add_transaction_page.dart';
import 'pages/analysis_page.dart';
import 'pages/profile_page.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  runApp(FinanceTrackerApp());
}

class FinanceTrackerApp extends StatefulWidget {
  @override
  _FinanceTrackerAppState createState() => _FinanceTrackerAppState();
}

class _FinanceTrackerAppState extends State<FinanceTrackerApp> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _transactions = [];

  void _addTransaction(Map<String, dynamic> transaction) {
    setState(() {
      _transactions.add(transaction);
    });
  }

  List<Widget> get _pages => [
    DashboardPage(transactions: _transactions),
    AddTransactionPage(onAddTransaction: _addTransaction),
    AnalysisPage(transactions: _transactions),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Finance Tracker'),
          backgroundColor: Colors.indigo,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analysis'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
