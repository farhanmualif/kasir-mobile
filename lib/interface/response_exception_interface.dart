class ResponseException {

  final ErrorMessage message;

  ResponseException({ required this.message});

  factory ResponseException.fromJson(Map<String, dynamic> json) {
    return ResponseException(
      message: ErrorMessage.fromJson(json['message']),
    );
  }
}

class ErrorMessage {
  final Map<String, List<String>> errors;

  ErrorMessage({required this.errors});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> errorMap = {};

    json.forEach((key, value) {
      if (value is List) {
        errorMap[key] = List<String>.from(value);
      } else if (value is String) {
        errorMap[key] = [value];
      }
    });

    return ErrorMessage(errors: errorMap);
  }

  List<String>? getErrorsFor(String field) {
    return errors[field];
  }
}
