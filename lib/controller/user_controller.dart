import 'package:flutter_e_commerce_app_with_backend/data/repository/user_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/models/response_model.dart';
import 'package:flutter_e_commerce_app_with_backend/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({
    required this.userRepo,
  });

  bool _isLoading = false;
  late UserModel _userModel;
  bool get isLoading => _isLoading;
  UserModel get getUserModel => _userModel;

  Future<ResponseModel> getUserInfo() async {
    Response response = await userRepo.getUserInfo();
    late ResponseModel
        responseModel; //create an obj and late need initialize later
    if (response.statusCode == 200) {
      _isLoading = true;
      _userModel = UserModel.fromJson(response.body);
      responseModel = ResponseModel(true, "Successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }
}
