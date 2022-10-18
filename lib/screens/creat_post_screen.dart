import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubits/social_cubit/social_cubit.dart';
import 'package:social_media_app/cubits/social_cubit/social_states.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key}) : super(key: key);
  static const routeName = 'create-post-screen';
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final socialCubit = SocialCubit.get(context);
        final appBar = AppBar(
          title: Text('Create Post'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              socialCubit.removePostImage();
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      if (socialCubit.postImage != null) {
                        await socialCubit.cratePostWithImage(
                          text: textController.text,
                          dateTime: DateTime.now().toIso8601String(),
                        );
                      } else {
                        await socialCubit.cratePostWithoutImage(
                          text: textController.text,
                          dateTime: DateTime.now().toIso8601String(),
                        );
                      }
                      Navigator.of(context).pop();
                      textController.text = '';
                      socialCubit.removePostImage();
                    },
                    child: Text('Post')),
                SizedBox(
                  width: 10,
                )
              ],
            )
          ],
        );
        return Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              child: SizedBox(
                height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is SocialLoadingCreatePostState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 4,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          socialCubit.currentUser!.image,
                        ),
                      ),
                      title: Text(socialCubit.currentUser!.name),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: TextFormField(
                          maxLines: 15,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          controller: textController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'what\'s on your mind'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (socialCubit.postImage != null)
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image.file(
                              socialCubit.postImage!,
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      socialCubit.removePostImage();
                                    },
                                    icon: Icon(Icons.cancel)),
                              ),
                            )
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              socialCubit.getPostImage();
                            },
                            icon: Icon(Icons.photo),
                            label: Text('Add Image'),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Text('# tags'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
