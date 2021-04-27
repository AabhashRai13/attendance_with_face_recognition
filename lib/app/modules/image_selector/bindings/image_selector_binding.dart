import 'package:get/get.dart';

import '../controllers/image_selector_controller.dart';

class ImageSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageSelectorController>(
      () => ImageSelectorController(),
    );
  }
}
