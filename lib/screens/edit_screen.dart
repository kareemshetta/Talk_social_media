import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components.dart';
import 'package:social_media_app/cubits/social_cubit/social_cubit.dart';
import 'package:social_media_app/cubits/social_cubit/social_states.dart';
import 'package:social_media_app/styles/colors.dart';

class EditScreen extends StatelessWidget {
  EditScreen({Key? key}) : super(key: key);
  static const routeName = 'edit-screen';
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final socialCubit = SocialCubit.get(context);
        final currentUser = socialCubit.currentUser;
        nameController.text = currentUser!.name;
        bioController.text = currentUser.bio;
        phoneController.text = currentUser.phone;
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit profile'),
            actions: [
              TextButton(
                onPressed: () {
                  socialCubit.updateUserData(
                      name: nameController.text,
                      bio: bioController.text,
                      phone: phoneController.text);
                },
                child: Text('Update'),
              ),
              SizedBox(
                width: 5,
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                socialCubit.profileImage == null;
                socialCubit.coverImage = null;
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                children: [
                  if (state is SocialLoadingUserUpdateState)
                    LinearProgressIndicator(),
                  Container(
                    height: 240,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 190,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: socialCubit.coverImage != null
                                    ? Image.file(
                                        socialCubit.coverImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        currentUser.coverImage,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: IconButton(
                                  onPressed: () {
                                    socialCubit.getCoverImage();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 67,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 63,
                                child: socialCubit.profileImage != null
                                    ? CircleAvatar(
                                        radius: 63,
                                        backgroundImage: FileImage(
                                            socialCubit.profileImage!),
                                      )
                                    : CircleAvatar(
                                        radius: 63,
                                        backgroundImage: NetworkImage(
                                          currentUser.image,
                                        ),
                                      ),
                              ),
                            ),
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  socialCubit.getProfileImage();
                                },
                                icon: Icon(
                                  Icons.edit,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (socialCubit.profileImage != null ||
                      socialCubit.coverImage != null)
                    Row(
                      children: [
                        if (socialCubit.profileImage != null &&
                            socialCubit.coverImage == null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                socialCubit.updateUserData(
                                  name: nameController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                );
                              },
                              icon: Icon(Icons.edit_note),
                              label: Text(
                                'Edit profile image',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: defaultColor),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        if (socialCubit.coverImage != null &&
                            socialCubit.profileImage == null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                socialCubit.updateUserData(
                                  name: nameController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                );
                              },
                              icon: Icon(Icons.edit_note),
                              label: Text(
                                'Edit cover image',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: defaultColor),
                              ),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  buildDefaultTextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter your name';
                      }
                      return null;
                    },
                    labelText: 'name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildDefaultTextFormField(
                    controller: bioController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please write your bio';
                      }
                      return null;
                    },
                    labelText: 'bio',
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildDefaultTextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please write your phone number';
                      }
                      return null;
                    },
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone_android),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
