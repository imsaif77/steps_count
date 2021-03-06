import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:steps_count/app/app.locator.dart';
import 'package:steps_count/app/app.router.dart';
import 'package:steps_count/ui/base/authentication_viewmodel.dart';

import 'login_view.form.dart';

class LoginViewModel extends AuthenticationViewModel {
  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  String pass = "admin";
  String animationType = "idle";
  LoginViewModel() : super(successRoute: Routes.dashboardView);

  updatePass(String val) {
    pass = val;
    notifyListeners();
  }

  updateAnimationType(String val) {
    print(val);
    animationType = val;
    notifyListeners();
  }

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthenticationService!.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );

  void navigateToCreateAccount() {}
}
