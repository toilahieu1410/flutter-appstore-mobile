import 'package:app_store/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  // constructor với đối tượng User mặc định
  // purpose: Quản lý trạng thái của đối tượng User
  UserProvider(): super(User(
    id: '', 
    fullName: '', 
    email: '', 
    state: '', 
    city: '', 
    locality: '',
    password: '',
    token: ''
    )
  );

  // Getter method to extract value from an object

  User? get user => state;

  // method to set user state from Json
  //purpose: updates he user sate base on json String respresentation of User Object

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  // Phương thức xoá trạng thái người dùng
  void signOut() {
    state = null;
  }
}

  // make the data accisible within the application
  final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());