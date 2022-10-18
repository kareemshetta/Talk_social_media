import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubits/social_cubit/social_states.dart';
import 'package:social_media_app/models/message_model.dart';
import 'package:social_media_app/models/user_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/post_model.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  UserModel? currentUser;

  void getCurrentUserData() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final userData = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .snapshots();
    userData.listen((userData) {
      currentUser = UserModel.fromJson(userData.data());
      print('useData:${userData.data}');
      emit(SocialGetCurrentUserDataChangeState());
    });
  }

  final imagePicker = ImagePicker();
  File? profileImage;
  File? coverImage;

  void getProfileImage() async {
    try {
      final XFile? pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        emit(SocialGetProfileImageSuccessState());
      }
    } catch (err) {
      print(err);
      emit(SocialGetProfileImageErrorState());
    }
  }

  void getCoverImage() async {
    try {
      final XFile? pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 30);
      if (pickedImage != null) {
        coverImage = File(pickedImage.path);
        emit(SocialGetCoverImageSuccessState());
      }
    } catch (err) {
      print(err);
      emit(SocialGetCoverImageErrorState());
    }
  }

  String profileImageUrl = '';

  Future<void> uploadProfileImage() async {
    try {
      if (profileImage != null) {
        final uploadedTask = await FirebaseStorage.instance
            .ref()
            .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
            .putFile(profileImage!);
        profileImageUrl = await uploadedTask.ref.getDownloadURL();
        print('profileimageurl$profileImageUrl');
        emit(SocialUploadProfileImageSuccessState());
      } else {
        print('no profile photo picked');
      }
    } catch (err) {
      print(err);
      emit(SocialUploadProfileImageSuccessState());
    }
  }

  String coverImageUrl = '';

  Future<void> uploadCoverImage() async {
    try {
      if (coverImage != null) {
        final uploadedTask = await FirebaseStorage.instance
            .ref()
            .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
            .putFile(coverImage!);
        coverImageUrl = await uploadedTask.ref.getDownloadURL();
        print('profileCover$profileImageUrl');
        emit(SocialUploadProfileCoverImageSuccessState());
      } else {
        print('no cover photo picked');
      }
    } catch (err) {
      print(err);
      emit(SocialUploadProfileCoverImageSuccessState());
    }
  }

  void updateUserData(
      {required String name,
      required String bio,
      required String phone}) async {
    emit(SocialLoadingUserUpdateState());
    try {
      if (profileImage != null) {
        await uploadProfileImage();
      } else if (coverImage != null) {
        await uploadCoverImage();
      }
      final user = UserModel(
          email: currentUser!.email,
          coverImage: coverImageUrl.trim().isEmpty
              ? currentUser!.coverImage
              : coverImageUrl,
          id: currentUser!.id,
          name: name,
          phone: phone,
          image: profileImageUrl.trim().isEmpty
              ? currentUser!.image
              : profileImageUrl,
          bio: bio);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.id)
          .update(user.toMap());
      emit(SocialUserUpdateSuccessState());
      coverImage = null;
      profileImage = null;
    } catch (err) {
      print(err);
      emit(SocialUserUpdateErrorState());
    }
  }

  File? postImage;

  void getPostImage() async {
    try {
      final XFile? pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
      if (pickedImage != null) {
        postImage = File(pickedImage.path);
        emit(SocialGetPostImageSuccessState());
      }
    } catch (err) {
      print(err);
      emit(SocialGetPostImageErrorState());
    }
  }

  Future<void> cratePostWithoutImage(
      {required String text, required String dateTime}) async {
    emit(SocialLoadingCreatePostState());
    try {
      if (postImage == null) {}
      final postModel = PostModel(
          uId: currentUser!.id,
          image: '',
          text: text,
          dataTime: dateTime,
          name: currentUser!.name,
          userImage: currentUser!.image);
      final post = await FirebaseFirestore.instance
          .collection('posts')
          .add(postModel.toMap());
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('like')
          .doc(currentUser!.id)
          .set({'like': false});
      print(post.id);
      emit(SocialCreatePostSuccessState());
    } catch (err) {
      print(err);
      emit(SocialCreatePostErrorState());
    }
  }

  String postImageUrl = '';

  Future<void> uploadPostImage() async {
    try {
      if (postImage != null) {
        final uploadedTask = await FirebaseStorage.instance
            .ref()
            .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
            .putFile(postImage!);
        postImageUrl = await uploadedTask.ref.getDownloadURL();
        print('postImageUrl$postImageUrl');
        emit(SocialUploadPostImageSuccessState());
      } else {
        print('no post photo picked');
      }
    } catch (err) {
      print(err);
      emit(SocialUploadPostImageSuccessState());
    }
  }

  Future<void> cratePostWithImage(
      {required String text, required String dateTime}) async {
    emit(SocialLoadingCreatePostState());
    try {
      if (postImage != null) {
        await uploadPostImage();
        print('postImageUrl:$postImageUrl');
        final postModel = PostModel(
          uId: currentUser!.id,
          image: postImageUrl,
          text: text,
          dataTime: dateTime,
          userImage: currentUser!.image,
          name: currentUser!.name,
        );

        final post = await FirebaseFirestore.instance
            .collection('posts')
            .add(postModel.toMap());
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.id)
            .collection('like')
            .doc(currentUser!.id)
            .set({'like': false});
        emit(SocialCreatePostSuccessState());
      }
    } catch (err) {
      print(err);
      emit(SocialCreatePostErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  //:Todo use future

  // List<PostModel> postsList = [];
  // List<String> postIdes = [];
  // List<int> postsLikeNumbers = [];
  // void getPosts() {
  //   emit(SocialGetPostsLoadingState());
  //   final postsSnapshot = FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('dateTime', descending: true)
  //       .snapshots();
  //   postsSnapshot.listen((posts) {
  //     // postsList = posts.docs
  //     //     .map((e) => PostModel.fromJson(e.data()))
  //     //     .toList()
  //     //     .reversed
  //     //     .toList();
  //     // postIdes = posts.docs.map((e) => e.id).toList().reversed.toList();
  //     // posts.docs.forEach((element) {
  //     //   element.reference.collection('like').get().then((value) {
  //     //     postsLikeNumbers.add(value.docs.length);
  //
  //     for (var element in posts.docs) {
  //       print('postsgeted:${element.data()}');
  //       postIdes.add(element.id);
  //       postsList.add(PostModel.fromJson(element.data()));
  //       element.reference.collection('like').snapshots().listen((event) {
  //         postsLikeNumbers.add(event.docs.length);
  //       });
  //     }
  //     print('postLength:${postsList.length}');
  //   });
  //   // ).catchError(onError);
  //
  //   // });
  //   // print('postList$postsList');
  //   emit(SocialGetPostsSuccessState());
  // }

  Future<void> likePost(String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('like')
          .doc(currentUser!.id)
          .update({'like': true});
      emit(SocialToggleLikeSuccessState());
    } catch (err) {
      print(err);
      emit(SocialToggleLikeErrorState());
    }
  }

  List<int> likes = [];

  void getPostLikesNumber() {
    likes = [];
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) => value.docs.forEach((element) {
              element.reference.collection('like').get().then((value) {
                likes.add(value.docs.length);
              });
              emit(SocialGetLikesNumberSuccessState());
            }))
        .catchError((error) {
      print(error);
      emit(SocialGetLikesNumberErrorState());
    });
  }

  List<UserModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.id != currentUser!.id) {
            users.add(UserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        print(error);
        emit(SocialGetAllUsersErrorState());
      });
    }
  }

  void sendMessage(
      {required String text,
      required String receiverId,
      required String dateTime}) {
    final messageModel = MessageModel(
      senderId: currentUser!.id,
      receiverId: receiverId,
      text: text,
      dateTime: dateTime,
    );
    // send to my collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((err) {
      print(err);
      emit(SocialSendMessageErrorState());
    });
// to receiver collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(currentUser!.id)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((err) {
      print(err);
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> message = [];
  void getMessage(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .snapshots()
        .listen((event) {
      message = [];
      for (var messDoc in event.docs) {
        message.add(MessageModel.fromJson(messDoc.data()));
      }
      emit(SocialGetAllMessageSuccessState());
    });
  }
}
