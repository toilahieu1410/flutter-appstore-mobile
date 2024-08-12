import 'package:app_store/provider/user_provider.dart';
import 'package:app_store/views/screens/authentication_screens/login_screen.dart';
import 'package:app_store/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // chạy ứng dụng Flutter đc bao bọc trong 1 ProviderScope để quản lý state
  runApp(ProviderScope(child: const MyApp()));
}

// Root widget của ứng dụng, 1 consumerWidget state thay đổi
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Phương thức kiểm tra token và thiết lập ng dùng nếu có sẵn
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // obtain 1 instance của sharedPreference để lưu trữ dữ liệu cục bộ
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Trích xuất authentication token và user dữ liệu được lưu trữ cục bộ
    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');

    // Nếu cả token và dữ liệu ng dùng có sẵn, ta cập nhật trạng tháng người dùng
    if(token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      ref.read(userProvider.notifier).signOut();
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // bỏ chữ debug ở trên màn hình
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(future: _checkTokenAndSetUser(ref), builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        final user = ref.watch(userProvider);

        return user !=null ? MainScreen() : LoginScreen();
      },)
    );
  }
}

