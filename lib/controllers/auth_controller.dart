import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthController {
  // ignore: unused_field
  static FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static final LocalAuthentication auth = LocalAuthentication();

  static setAuth(User user, String password) async {
    try {
      await _flutterSecureStorage.write(
        key: "is_logged_in",
        value: true.toString(),
      );

      await _flutterSecureStorage.write(
        key: "login_uid",
        value: user.uid,
      );

      await _flutterSecureStorage.write(
        key: "login_email",
        value: user.email!,
      );

      await _flutterSecureStorage.write(
        key: "login_password",
        value: password,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static purgeAuth() async {
    try {
      await _flutterSecureStorage.delete(
        key: "is_logged_in",
      );

      await _flutterSecureStorage.delete(
        key: "login_uid",
      );

      await _flutterSecureStorage.delete(
        key: "login_email",
      );

      await _flutterSecureStorage.delete(
        key: "login_password",
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      if (res.user == null) {
        return {
          "result": false,
          "message": "User not found!!",
        };
      }

      await setAuth(
        res.user!,
        password,
      );

      return {
        "result": true,
        "message": "Logged in successfully ... ",
      };
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.message.toString(),
      };
    }
  }

  static Future<bool> checkLogin() async {
    try {
      bool isLoggedIn = (await _flutterSecureStorage.read(
                  key: "is_logged_in")) !=
              null
          ? bool.parse((await _flutterSecureStorage.read(key: "is_logged_in"))!)
          : false;

      if (isLoggedIn) {
        final bool canAuthenticateWithBiometrics =
            await auth.canCheckBiometrics;
        print("User Logged IN ... ");
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        if (canAuthenticate) {
          print("Can Authenticate ... ");
          final List<BiometricType> availableBiometrics =
              await auth.getAvailableBiometrics();

          if (availableBiometrics.isNotEmpty) {
            print("Found Biometrics ... ");
            // Some biometrics are enrolled.
            try {
              final bool didAuthenticate = await auth.authenticate(
                localizedReason: 'Please authenticate to login',
                options: AuthenticationOptions(
                  biometricOnly: true,
                ),
              );

              if (!(didAuthenticate)) {
                return false;
              }
            } on PlatformException catch (ex) {
              print(ex.message);
              return false;
            }
          }
        }

        var email = await _flutterSecureStorage.read(
          key: "login_email",
        );

        var password = await _flutterSecureStorage.read(
          key: "login_password",
        );

        var res = await AuthController.login(email!, password!);

        return res["result"] as bool;
      }

      return isLoggedIn;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      try {
        await purgeAuth();
      } catch (e) {
        print(e.toString());
      }

      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection("Users")
          .doc(
            FirebaseAuth.instance.currentUser!.uid,
          )
          .get();

      if (!res.exists) {
        return {
          "result": false,
          "message": "Uset not found!!",
        };
      }

      var data = res.data()!;

      return {
        "result": true,
        "message": "Retrieved successfully ... ",
        "data": {
          ...data,
          "id": res.id,
        },
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }
}
