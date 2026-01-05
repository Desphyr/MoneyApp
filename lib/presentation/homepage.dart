import 'package:flutter/material.dart';
import 'package:money_app/data/model/transaction.dart';
import 'package:money_app/data/repository/category_repository.dart';
import 'package:money_app/data/repository/transaction_repository.dart';
import 'package:money_app/data/service/httpservice.dart';
import 'package:money_app/data/usecase/response/get_category_response.dart';
import 'package:money_app/presentation/insert_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GetCategoryResponse? listcategory;
  final categoryRepo = CategoryRepository(HttpService());
  GetTransactionResponse? listtransaction;
  final tr = TransactionRepository(HttpService());

  @override
  void initState() {
    super.initState();
    loadcategory();
    loadtransaction();
  }

  Future<void> loadcategory() async {
    final response = await categoryRepo.getAllCategory();
    setState(() {
      listcategory = response;
    });
  }

  Future<void> loadtransaction() async {
    final response = await tr.getTransaction();
    setState(() {
      listtransaction = response;
    });
  }

  int _calculateBalance() {
    if (listtransaction?.data == null) return 0;
    int balance = 0;
    for (var transaction in listtransaction!.data) {
      if (transaction.categoryType.toLowerCase() == 'income') {
        balance += transaction.amount;
      } else if (transaction.categoryType.toLowerCase() == 'expense') {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  int _calculateIncome() {
    if (listtransaction?.data == null) return 0;
    return listtransaction!.data
        .where((t) => t.categoryType.toLowerCase() == 'income')
        .fold(0, (sum, t) => sum + t.amount);
  }

  int _calculateExpense() {
    if (listtransaction?.data == null) return 0;
    return listtransaction!.data
        .where((t) => t.categoryType.toLowerCase() == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertPage()),
          );
          if (result == true) {
            loadtransaction();
          }
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Balance',
                          amount: _calculateBalance(),
                          color: Colors.deepPurple,
                          icon: Icons.account_balance_wallet,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Income',
                          amount: _calculateIncome(),
                          color: Colors.green,
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Expense',
                          amount: _calculateExpense(),
                          color: Colors.red,
                          icon: Icons.trending_down,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: listtransaction == null
                  ? const Center(child: CircularProgressIndicator())
                  : listtransaction!.data.isEmpty
                  ? const Center(child: Text('No transactions yet'))
                  : ListView.builder(
                      itemCount: listtransaction!.data.length,
                      itemBuilder: (context, index) {
                        final transaction = listtransaction!.data[index];
                        return _TransactionCard(
                          transaction: transaction,
                          onDelete: () async {
                            await tr.deleteTransaction(transaction.id);
                            loadtransaction();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Datum transaction;
  final VoidCallback onDelete;

  const _TransactionCard({required this.transaction, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.categoryType.toLowerCase() == 'income';
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.note ?? '', style: const TextStyle(fontSize: 12)),
            Text(
              transaction.transactionDate.toString().split(' ')[0],
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} Rp ${transaction.amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Transaction'),
              content: const Text(
                'Are you sure you want to delete this transaction?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
