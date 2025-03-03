import 'package:dio/dio.dart';

import '../controllers/config.Controller.dart';

class OptionsDio {
  Future<BaseOptions> getOptions() async {
    final url = await ConfigController.instance.getUrlBase();

    final options = BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(milliseconds: 50000),
      receiveTimeout: const Duration(milliseconds: 50000),
    );
    return options;
  }
}
