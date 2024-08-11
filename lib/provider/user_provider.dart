import 'package:app_store/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  // constructor initializing with default User Object
  // purpose: Manage the state of the user object allowing updates
  UserProvider(): super(User(id: '', fullName: '', email: '', state: '', city: '', locality: '', password: '', token: ''))
}