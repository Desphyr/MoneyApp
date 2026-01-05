import 'package:money_app/data/model/transaction.dart';
import 'package:money_app/data/service/httpservice.dart';
import 'package:money_app/data/usecase/request/add_transaction_request.dart';
import 'package:money_app/data/usecase/response/get_single_transaction_response.dart';

class TransactionRepository {
  final HttpService httpService;

  TransactionRepository(this.httpService);

  Future<GetTransactionResponse> getTransaction() async {
    final response = await httpService.get('transactions');
    if (response.statusCode == 200) {
      final responseData = GetTransactionResponse.fromJson(response.body);
      return responseData;
    } else {
      final errorResponse = GetTransactionResponse.fromJson(response.body);
      return errorResponse;
    }
  }

  Future<GetSingleTransactionResponse> createTransaction(
    AddTransactionRequest request,
  ) async {
    final body = request.toMap();
    final response = await httpService.postWithFile(
      'transactions',
      body,
      request.image,
    );
    if (response.statusCode == 201) {
      final responseData = GetSingleTransactionResponse.fromJson(response.body);
      return responseData;
    } else {
      final errorResponse = GetSingleTransactionResponse.fromJson(
        response.body,
      );
      return errorResponse;
    }
  }

  Future<GetSingleTransactionResponse> updateTransaction(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await httpService.put('transactions/$id', body);
    if (response.statusCode == 200) {
      final responseData = GetSingleTransactionResponse.fromJson(response.body);
      return responseData;
    } else {
      final errorResponse = GetSingleTransactionResponse.fromJson(
        response.body,
      );
      return errorResponse;
    }
  }

  Future<GetSingleTransactionResponse> deleteTransaction(int id) async {
    final response = await httpService.delete('transactions/$id');
    if (response.statusCode == 200) {
      final responseData = GetSingleTransactionResponse.fromJson(response.body);
      return responseData;
    } else {
      final errorResponse = GetSingleTransactionResponse.fromJson(
        response.body,
      );
      return errorResponse;
    }
  }
}
