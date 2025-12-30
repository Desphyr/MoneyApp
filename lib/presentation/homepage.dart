import 'package:flutter/material.dart';
import 'package:money_app/data/model/transaction.dart';
import 'package:money_app/data/repository/category_repository.dart';
import 'package:money_app/data/repository/transaction_repository.dart';
import 'package:money_app/data/service/httpservice.dart';
import 'package:money_app/data/usecase/response/GetCategoryResponse.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GetCategoryResponse? listcategory;
  final categoryRepo=CategoryRepository(HttpService());
  GetTransactionResponse? listtransaction;
  final tr = TransactionRepository(HttpService());
  
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadcategory();
    loadtransaction();
  }

   Future<void>loadcategory () async {
    final response = await categoryRepo.getAllCategory();

    setState(() {
      listcategory = response;
    });
  }

  Future<void>loadtransaction () async {
    final response = await tr.getTransaction();

    setState(() {
      listtransaction = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:SafeArea(child: Column(
      children: [
        Text('DaftarCategory'),
        Expanded(child: ListView.builder(
          itemCount: listcategory?.data.length,
          itemBuilder: (context, index) {
          return Text(listcategory!.data[index].name);

        },)),
        Expanded(child: ListView.builder(
          itemCount: listtransaction?.data.length,
          itemBuilder: (context, index) {
          return ListTile(
            leading: Text(listtransaction!.data[index].amount.toString()),
            title: Text(listtransaction!.data[index].categoryName),
          );

        },))
      ],
    )));
  }
}