import 'package:money_app/data/service/httpservice.dart';
import 'package:money_app/data/usecase/request/add_transaction_request.dart';
import 'package:money_app/data/usecase/response/get_all_transaction_response.dart';
import 'package:money_app/data/usecase/response/get_single_transaction_response.dart';

class TransactionRepository {
  final HttpService apiService;

  TransactionRepository(this.apiService);

  Future<GetAllTransactionResponse> getAllTransactions() async {
    final response = await apiService.get('transactions');
    try {
      if (response.statusCode == 200) {
        final responseData = GetAllTransactionResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetAllTransactionResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      throw Exception('Error parsing transactions: $e');
    }
  }

  Future<GetTransactionsResponse> createTransaction({
    AddTransactionRequest? request,
  }) async {
    try {
      final response = await apiService.postWithFile(
        'transactions',
        request!.toMap(),
        request.image,
        'image',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = GetTransactionsResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetTransactionsResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      throw Exception('Error creating transaction: $e');
    }
  }
}
