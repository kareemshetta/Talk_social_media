import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubits/social_cubit/social_cubit.dart';
import 'package:social_media_app/cubits/social_screen_cubit/social_login_state.dart';

import '../../models/user_model.dart';
import '../../network/local/cache_helper.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  SocialLoginCubit() : super(SocialLoginInitialState());
  static SocialLoginCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  bool isPassword = false;
  IconData visibilityIcon = Icons.visibility_off;
  void toggleVisibility() {
    isPassword = !isPassword;
    visibilityIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(SocialToggleVisibilityState());
  }

  String token = '';
  Future<dynamic> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    emit(SocialLoginLoadingState());
    try {
      final userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCred.user != null) {
        emit(SocialLoginSuccessState(userCred.user!.uid));
        SocialCubit.get(context).getCurrentUserData();
      } else {
        emit(SocialLoginErrorState('login error,please check your credential'));
        throw (Exception('login error'));
      }

      // CacheHelper.saveData(key: 'token', value: token);
      // print('message${userModel.message}');
      // emit(SocialLoginSuccessState(userModel));
      // return responseData;
    } on FirebaseAuthException catch (err) {
      print(err);
      emit(SocialLoginErrorState(err.message!));
    }
  }
}
