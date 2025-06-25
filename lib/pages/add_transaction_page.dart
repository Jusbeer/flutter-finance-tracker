import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddTransaction;

  const AddTransactionPage({super.key, required this.onAddTransaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedType; // 'income' or 'expense'

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitTransaction() {
    if (_selectedType == null ||
        _titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    final transaction = {
      'type': _selectedType,
      'title': _titleController.text,
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'date': _selectedDate!,
    };

    widget.onAddTransaction(transaction);

    // Clear fields after submission
    setState(() {
      _titleController.clear();
      _amountController.clear();
      _selectedDate = null;
      _selectedType = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Radio Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'income',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                Text('Income'),
                Radio<String>(
                  value: 'expense',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                Text('Expense'),
              ],
            ),

            // Title Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),

            // Amount Field
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),

            // Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'No date chosen!'
                      : 'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text('Choose Date'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitTransaction,
              child: Text('Add Transaction'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
