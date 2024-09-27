
import 'package:fashion/Modules/Auth/controllers/validation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ValidationController validationController =
      Get.put(ValidationController());

  var obscureText = false.obs;
  var isPasswordVisible = true.obs;
  var isCnfPasswordVisible = true.obs;

  // Profile Image

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleCnfPasswordVisibility() {
    isCnfPasswordVisible.value = !isCnfPasswordVisible.value;
  }
}
