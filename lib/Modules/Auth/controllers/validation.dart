import 'package:email_validator/email_validator.dart';
import 'package:fashion/Utils/Constants/string_constant.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ValidationController extends GetxController {
  // Error messages for validation
  var nameError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var checkboxError = ''.obs;
  var imageError = ''.obs;
  var phoneError = ''.obs;
  var genderError = ''.obs;
  var addressError = ''.obs;
  var address1Error = ''.obs;
  var cityError = ''.obs;
  var stateError = ''.obs;
  var pinError = ''.obs;

  //product detail screen
  var sizeError = ''.obs;
  var colorError = ''.obs;

  //////////
  var agreeToTerms = false.obs;
  var userName = ''.obs; //to store username from signUp screen
  var profileImage = Rxn<File>(null); // To store selected image
  var userImage = ''.obs;

  //profile page list view -- list
  final List<String> profileList = <String>[
    StringConstants.row1,
    StringConstants.row2,
    StringConstants.row3,
    StringConstants.row4,
    StringConstants.row5,
    StringConstants.row6,
    StringConstants.row7,
    StringConstants.logout,
  ];

  //Gender Dropdown
  var selectedDropdownItem =
      StringConstants.select.obs; //default select dropdown
  var genderDropdownValues = const [
    StringConstants.select,
    StringConstants.male,
    StringConstants.female,
    StringConstants.other
  ];

  //phone number dropdown
  var phoneNumber = ''.obs;
  var selectedCountrycode =
      StringConstants.country1.obs; //default country code dropdown
  var countryCode = const [
    StringConstants.country1,
    StringConstants.country2,
    StringConstants.country3,
  ];

  void checkBox() {
    agreeToTerms.value = !agreeToTerms.value;
  }

// Method to update the selected dropdown value
  void setSelectedDropdownItem(String value) {
    selectedDropdownItem.value = value;
    validateGender(value); // to validate
  }

  // Method to update the selected country code
  void setSelectedCountryCode(String value) {
    selectedCountrycode.value = value;
  }

  // Method to update the phone number
  void setPhoneNumber(String value) {
    phoneNumber.value = value;
    validatePhone(value); // to validate
  }

  //for product details screen validation
  void validateSize(String size) {
    if (size.isEmpty) {
      sizeError.value = 'Please select Size.';
    } else {
      sizeError.value = '';
    }
  }

  void validateColor(String color) {
    if (color.isEmpty) {
      colorError.value = 'Please select Color.';
    } else {
      colorError.value = '';
    }
  }

  // Validations
  void validateName(String value) {
    if (value.isEmpty) {
      nameError.value = 'Name cannot be empty';
    } else if (value.length < 3) {
      nameError.value = 'Name must be at least 3 characters long';
    } else {
      nameError.value = '';
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email cannot be empty';
    } else if (!EmailValidator.validate(value)) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password cannot be empty';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters long';
    } else if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
        .hasMatch(value)) {
      passwordError.value =
          'Please enter a password with at least 6 characters, including 1 lowercase, 1 uppercase, 1 number, and 1 special character';
    } else {
      passwordError.value = '';
    }
  }

  void validateCheckbox() {
    if (!agreeToTerms.value) {
      checkboxError.value =
          'You can\'t proceed please, Accept Terms & Condition first';
    } else {
      checkboxError.value = '';
    }
  }

  // Method to validate image
  void validateImage() {
    if (profileImage.value == null) {
      imageError.value = 'Profile image is required';
    } else {
      imageError.value = '';
    }
  }

  // Method to validate phone number
  void validatePhone(String value) {
    if (value == '+1' || value.isEmpty) {
      phoneError.value = 'Phone number cannot be empty || select country code';
    } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      phoneError.value = 'Please enter a valid phone number';
    } else {
      phoneError.value = '';
    }
  }

  // Method to validate gender
  void validateGender(String value) {
    if (value == 'Select' || value.isEmpty) {
      genderError.value = 'Please select a gender';
    } else {
      genderError.value = '';
    }
  }

  //address validation conditionF

  void validateAddress(String address) {
    if (address.isEmpty) {
      addressError.value = 'Address cannot be empty';
    } else {
      addressError.value = '';
    }
  }

  void validateAddress1(String address1) {
    address1Error.value = '';
  }

  void validateCity(String city) {
    if (city.isEmpty) {
      cityError.value = 'City cannot be empty';
    } else {
      cityError.value = '';
    }
  }

  void validateState(String state) {
    if (state.isEmpty) {
      stateError.value = 'State cannot be empty';
    } else {
      stateError.value = '';
    }
  }

  void validatePin(String pin) {
    if (pin.isEmpty) {
      pinError.value = 'PIN cannot be empty';
    } else if (pin.length != 6) {
      pinError.value = 'PIN must be 6 digits';
    } else {
      pinError.value = '';
    }
  }

  void validateConfirmPassword(String password, String confirmPassword) {
    confirmPasswordError.value =
        (password == confirmPassword) ? '' : "Passwords do not match";
  }

  var updatedPassword = ''.obs; // to store new password value

  void saveNewPassword(String newPassword) {
    updatedPassword.value = newPassword;
    print("New Password: $newPassword");
  }

  // Optionally, set the user name from sign-up
  void setUserName(String name) {
    userName.value = name;
  }

  // Image Picker instance
  final ImagePicker _picker = ImagePicker();

  // Method to pick image from gallery
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      imageError.value = '';
    }
  }

  // Method to pick image from camera

  Future<void> pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      imageError.value = '';
    }
  }
}
