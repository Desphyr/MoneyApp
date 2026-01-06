import 'package:money_app/data/service/httpservice.dart';
import 'package:money_app/data/usecase/response/get_all_category_response.dart';

class CategoryRepository {
  final HttpService httpService;

  CategoryRepository(this.httpService);

  Future<GetCategoryResponse> getAllCategory() async {
    final response = await httpService.get('categories');

    if (response.statusCode == 200) {
      final responseData = GetCategoryResponse.fromJson(response.body);
      return responseData;
    } else {
      final errorResponse = GetCategoryResponse.fromJson(response.body);
      return errorResponse;
    }
  }
}
