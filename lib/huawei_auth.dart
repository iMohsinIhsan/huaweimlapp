import 'package:huawei_account/huawei_account.dart';

class HuaweiAuth {
  sign() async {
    try {
      final AccountAuthParamsHelper accountAuthParamsHelper = AccountAuthParamsHelper();
      final AccountAuthParams accountAuthParams = accountAuthParamsHelper.createParams();
      final AccountAuthService authService = AccountAuthManager.getService(accountAuthParams);

      authService.signIn();
    } catch (e) {
      print(e);
    }
  }
}
