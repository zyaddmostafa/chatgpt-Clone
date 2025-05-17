class SignUpRequestBody {
  final String email;
  final String password;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  SignUpRequestBody({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });
}
