class CustomException implements Exception {
  final String? message;
  // CustomException() {}
  // CustomException.withMessage(String mes) {
  //   this.message = mes;
  // }
  CustomException(this.message);
  // CustomException(){

  // };
  @override
  String toString() {
    if (message is String) return 'CustomException:$message';
    return 'CustomException:Unknown';
  }
}
