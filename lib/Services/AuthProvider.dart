import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';

class AuthProvider extends BaseViewModel {
  final _ser = FirebaseAuth.instance;
  User get user => _ser.currentUser;
  signIn() async {
    setBusy(true);
    await _ser.signInAnonymously();
    setBusy(false);
  }
}
