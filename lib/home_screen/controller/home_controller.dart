import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
}
