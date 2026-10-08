import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_auth_state.dart';

class AdminAuthCubit extends Cubit<AdminAuthState> {
  AdminAuthCubit({bool startAsAdmin = false})
      : super(startAsAdmin ? AdminAuthState.admin() : AdminAuthState.customer());

  void loginAsAdmin({
    String userName = 'Zara Philip',
    String shopName = 'Zara Official Motors',
  }) {
    emit(
      AdminAuthState.admin().copyWith(
        userName: userName,
        shopName: shopName,
      ),
    );
  }

  void loginAsCustomer() {
    emit(AdminAuthState.customer());
  }

  void toggleRole() {
    if (state.isAdmin) {
      loginAsCustomer();
    } else {
      loginAsAdmin();
    }
  }
}
