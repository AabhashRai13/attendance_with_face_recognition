import 'package:get/get.dart';
import 'package:attendance_project/app/modules/home/bindings/home_binding.dart';
import 'package:attendance_project/app/modules/home/views/home_view.dart';
import 'package:attendance_project/app/modules/image_selector/bindings/image_selector_binding.dart';
import 'package:attendance_project/app/modules/image_selector/views/image_selector_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_SELECTOR,
      page: () => ImageSelectorView(),
      binding: ImageSelectorBinding(),
    ),
    
  ];
}
