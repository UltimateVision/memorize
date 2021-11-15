class FormUtils {

  FormUtils._();

  static String? requiredFieldValidator(String fieldName, String? value) =>
      (value == null || value.isEmpty) ? '$fieldName is required' : null;
}