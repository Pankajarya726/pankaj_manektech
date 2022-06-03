import 'dart:developer';

import 'package:com_pankaj_test/model/product_response.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  String getProductUrl = "http://205.134.254.135/~mobile/MtProject/public/api/product_list.php";

  Future<ProductResponse> getProduct(Map<String, dynamic> input) async {
    try {
      Dio _dio = Dio();

      Response res = await _dio.post(getProductUrl,
          data: input,
          options: Options(headers: {
            "token": "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz"
          }));

      log(res.data.toString());
      if (res.statusCode == 200) {
        return ProductResponse.fromJson(res.toString());
      } else {
        return ProductResponse(status: 0, data: [], message: res.statusMessage!, totalPage: 0, totalRecord: 0);
      }
    } catch (exception) {
      return ProductResponse(status: 0, data: [], message: "Internal server error", totalPage: 0, totalRecord: 0);
    }
  }
}
