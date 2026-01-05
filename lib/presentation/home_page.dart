import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:money_app/data/model/transaction.dart';
import 'package:money_app/data/repository/transaction_repository.dart';
import 'package:money_app/data/service/httpservice.dart';
import 'package:money_app/presentation/insert_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _balance = 0;
  double _income = 0;
  double _expense = 0;
  final _transactionRepo = TransactionRepository(HttpService());
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _calculateTotals() {
    double tempIncome = 0;
    double tempExpense = 0;

    for (var tx in _transactions) {
      if (tx.categoryType == 'income') {
        tempIncome += tx.amount;
      } else {
        tempExpense += tx.amount;
      }
    }

    _income = tempIncome;
    _expense = tempExpense;
    _balance = tempIncome - tempExpense;
  }

  Future<void> _loadData() async {
    try {
      final response = await _transactionRepo.getAllTransactions();
      if (response.status == 'success') {
        setState(() {
          _transactions = response.data;
          _calculateTotals();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data: ${response.message}')),
          );
        }
        log('Gagal memuat data: ${response.message}');
      }
    } catch (e) {
      log('Error loading transactions: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 24.0),
              const Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _transactions.isEmpty
                    ? const Center(child: Text('Belum ada transaksi'))
                    : ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final tx = _transactions[index];
                          return _buildTransactionItem(tx);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertPage()),
          );
          if (result == true) {
            _loadData();
          }
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Balance: Rp${_balance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Income: Rp${_income.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
                Text(
                  'Expense: Rp${_expense.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(
          tx.image ?? 'https://via.placeholder.com/150',
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.monetization_on);
          },
          fit: BoxFit.fitWidth,
        ),
      ),
      title: Text(
        tx.note ?? 'No Description',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tx.categoryName} • ${tx.categoryType.toUpperCase()}',
            style: TextStyle(
              fontSize: 14,
              color: tx.categoryType == 'income' ? Colors.green : Colors.red,
            ),
          ),
          Text(
            tx.transactionDate.toString(),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
      trailing: Text(
        "${tx.categoryType == "income" ? '+' : '-'}Rp${tx.amount.toStringAsFixed(0)}",
        style: TextStyle(
          color: tx.categoryType == "income" ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      isThreeLine: true,
    );
  }
}
