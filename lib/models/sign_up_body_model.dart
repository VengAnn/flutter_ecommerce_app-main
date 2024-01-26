class SignUpBody {
  final String name;
  final String password;
  final String phone;
  final String email;

  //Constructor
  SignUpBody({
    required this.name,
    required this.password,
    required this.phone,
    required this.email,
  });

  //convert obj to json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String,dynamic>();
    data['f_name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
