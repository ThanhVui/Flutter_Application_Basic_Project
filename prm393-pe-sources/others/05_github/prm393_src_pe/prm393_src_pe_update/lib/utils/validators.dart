class Validators {
  static String? required(String? value, String name) {
    if (value == null || value.isEmpty) {
      return "$name is required";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return "Price is required";
    }
    if (double.tryParse(value) == null) {
      return "Enter a valid number";
    }
    return null;
  }
}
