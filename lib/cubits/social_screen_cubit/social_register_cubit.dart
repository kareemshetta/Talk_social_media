import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/cubits/social_cubit/social_cubit.dart';

import 'package:social_media_app/models/user_model.dart';
import 'social_register_state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  bool isPassword = false;
  IconData visibilityIcon = Icons.visibility_off;
  void toggleVisibility() {
    isPassword = !isPassword;
    visibilityIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(SocialRegisterToggleVisibilityState());
  }

  void createUser(
      {required String email,
      required String name,
      required String uId,
      required String phone,
      required coverImage,
      required String image,
      required String bio}) async {
    final user = UserModel(
        email: email,
        coverImage: coverImage,
        id: uId,
        name: name,
        phone: phone,
        image: image,
        bio: bio);
    FirebaseFirestore.instance.collection('users').doc(uId).set(user.toMap());
    emit(SocialCreateNewUserSuccessState());
  }

  String token = '';

  Future<void> registerUser(
      {required String email,
      required String password,
      required String name,
      required BuildContext context,
      String image =
          'https://img.freepik.com/free-photo/pensive-grey-haired-bearded-'
              'old-man-stands-with-arms-crossed-looks-away-thoughtfully-wears-casual'
              '-jumper-ponders-plans-weekend-going-visit'
              '-children-isolated-brown-studio-wall_273609-44174.jpg?'
              't=st=1664978104~exp=1664978704~hmac=d66b7192dd94a26254e37e5498165d47c0'
              '66db8cfe8afb0bae8e91e94cb54845',
      String bio = 'write your bio',
      String coverImage =
          'https://img.freepik.com/free-photo/pensive-grey-haired-bearded-'
              'old-man-stands-with-arms-crossed-looks-away-thoughtfully-wears-casual'
              '-jumper-ponders-plans-weekend-going-visit'
              '-children-isolated-brown-studio-wall_273609-44174.jpg?'
              't=st=1664978104~exp=1664978704~hmac=d66b7192dd94a26254e37e5498165d47c0'
              '66db8cfe8afb0bae8e91e94cb54845',
      required String phoneNumber}) async {
    emit(SocialRegisterLoadingState());
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCred.user != null) {
        createUser(
            email: email,
            name: name,
            uId: userCred.user!.uid,
            phone: phoneNumber,
            image: image,
            coverImage: coverImage,
            bio: bio);
        token = await userCred.user!.getIdToken();
        emit(SocialRegisterSuccessState(userCred.user!.uid));
        SocialCubit.get(context).getCurrentUserData();
      } else {
        emit(SocialRegisterErrorState(
            'Register error..,please check your credential'));
        throw (Exception('Register error'));
      }
    } on FirebaseAuthException catch (err) {
      print(err);
      emit(SocialRegisterErrorState(err.message!));
      throw err;
    }
  }
}
