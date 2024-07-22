class RegisterResult {
  String store;
  String address;
  String name;
  String email;

  RegisterResult(
      {required this.store,
      required this.address,
      required this.name,
      required this.email});

  factory RegisterResult.fromjson(Map<String, dynamic> data) {
    return RegisterResult(
        store: data['store'],
        address: data['address'],
        name: data['name'],
        email: data['email']);
  }
}
