 

import 'package:cliveott/src/service/livetv_category_service.dart';
import 'package:get/get.dart';

import '../model/livetv_category_model.dart';
import '../model/livetvby_category_model.dart';
import '../service/livetvby_category_service.dart';

class LiveTvByCategoryController extends GetxController {
  RxBool categoryLoad = true.obs;
  List<LivetvByCategoryModel> _livetvcategorymodel = [];
  List<LivetvByCategoryModel> get getcategory => _livetvcategorymodel;
  var livetvbycategoryservice = LiveTvByCategoryService();
  Future liveTvBycategoryController({category_id}) async {
    try {
      var response = await livetvbycategoryservice.livetvBycategoryService(category_id: category_id);
      if (response != null) {
        _livetvcategorymodel.add(response);
        categoryLoad(false);
      } else {
        categoryLoad(false);
      }
    } catch (e) {
      rethrow;
    }
  }
}
