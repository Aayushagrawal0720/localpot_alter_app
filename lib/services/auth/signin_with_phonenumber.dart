import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

@immutable
class FUser {
  const FUser({@required this.uid});

  final String uid;
}

class SigninWithPhoneNumber with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _codeSent = false;
  bool _verificationComplete = false;
  bool _verificationFailed = false;
  bool _codeAutoRetrievalTimeout = false;
  String _verificationFailMessage;
  String _phone;

  User _user;
  String _verificationId;

  bool _loading = false;

  ConfirmationResult confirmationResult;

  FUser _userFromFirebase(User user) {
    return user == null ? null : FUser(uid: user.uid);
  }

  Stream<FUser> get initialisingFirebaseAuth {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  isCodeSent() => _codeSent;

  isVerificationComplete() => _verificationComplete;

  isVerificationFailed() => _verificationFailed;

  isCodeAutoRetrievalTimeout() => _codeAutoRetrievalTimeout;

  getVerificationFailMessage() => _verificationFailMessage;

  getUser() => _user;

  phoneSignin(String phone) async {
    _phone = phone;
    await Future.delayed(Duration(microseconds: 200));
    _loading = true;
    notifyListeners();
    if (kIsWeb) {
      print("---------------------------WEB RENDERING-------------");
      confirmationResult = await _auth.signInWithPhoneNumber(
          phone,
          RecaptchaVerifier(
            container: 'recaptchaDOM',
            size: RecaptchaVerifierSize.normal,
            theme: RecaptchaVerifierTheme.light,
            onSuccess: () => print('reCAPTCHA Completed!'),
            onError: (FirebaseAuthException error) => print(error),
            onExpired: () => print('reCAPTCHA Expired!'),
          )
      );
    } else {
      _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          _auth.signInWithCredential(credential).then((UserCredential user) {
            _user = user.user;
            _verificationComplete = true;
            _loading = false;
            notifyListeners();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          _verificationFailed = true;
          _verificationFailMessage = e.message;
          _loading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int resendToken) {
          _codeSent = true;
          _verificationId = verificationId;
          _loading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _codeAutoRetrievalTimeout = true;
          _loading = false;
          notifyListeners();
        },
      );
    }
  }

  verifyCode(String smsCode) async {
    if (kIsWeb) {
      UserCredential userCredential =
      await confirmationResult.confirm(smsCode);
      print(userCredential.additionalUserInfo.profile.values);
    }
    PhoneAuthCredential _credentials = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    _auth.signInWithCredential(_credentials).then((UserCredential user) {
      _user = user.user;
      _verificationComplete = true;
      notifyListeners();
    }).catchError((err) {
      print(err);
    });
  }

  getPhone() => _phone;

  getLoading() => _loading;
}
