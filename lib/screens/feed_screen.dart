import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubits/social_cubit/social_cubit.dart';
import 'package:social_media_app/cubits/social_cubit/social_states.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/styles/colors.dart';
import 'package:social_media_app/widgets/CreateNewPostItem.dart';

import '../models/post_model.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('dateTime', descending: true)
          .snapshots(),
      builder: (context, postSnapshot) {
        if (postSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (postSnapshot.hasData) {
          //  final socialCubit = SocialCubit().getPostLikesNumber();
          List<Map<String, PostModel>> postsList = postSnapshot.data!.docs
              .map((e) => {e.id: PostModel.fromJson(e.data())})
              .toList()
              .reversed
              .toList();
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image.network(
                        'https://img.freepik.com/free-photo/beautiful-young-brunette-woman-with-pleasant-appearance-tender-smile_273609-18319.jpg?t=st=1664942507~exp=1664943107~hmac=5c5b88cebe4850d5abc8bee7d6eefa969658a129cb61d2e7a190b09226bb571d',
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'let\'s communicate now',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: CreateNewPostItem(
                      currentUser: SocialCubit.get(context).currentUser!),
                ),
                Divider(color: Colors.grey[400], height: 1, thickness: 3),
                ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      // List<PostModel> postList = postSnapshot.data!.docs
                      //     .map(
                      //       (e) => PostModel.fromJson(
                      //         e.data(),
                      //       ),
                      //     )
                      //     .toList()
                      //     .reversed
                      //     .toList();

                      print(index);
                      return buildPostItem(
                          context,
                          (postsList[index].values.toList())[0],
                          (postsList[index].keys.toList())[0],
                          index);
                    },
                    itemCount: postsList.length)
              ],
            ),
          );
        } else {
          return Center(
            child: Text(' add new posts to show.....'),
          );
        }
      },
    );
  }

  Widget buildPostItem(
      BuildContext context, PostModel postModel, String postId, int index) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final socialCubit = SocialCubit.get(context);
          final currentUser = socialCubit.currentUser;

          //final likesList = socialCubit.likes.reversed.toList();
          // print('likes number');
          //  print(likesList.length);
          return SizedBox(
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        postModel.userImage,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(postModel.name),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: defaultColor,
                        )
                      ],
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().add_jm().format(
                            DateTime.parse(postModel.dataTime),
                          ),
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: Icon(Icons.more_horiz)),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[400],
                  ),
                  Container(
                    color: Colors.grey[10],
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      postModel.text,
                      maxLines: 7,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(height: 1.1),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Wrap(
                  //     spacing: 2,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     children: [
                  //       Container(
                  //         height: 30,
                  //         child: MaterialButton(
                  //           minWidth: 1,
                  //           padding: EdgeInsets.zero,
                  //           onPressed: () {},
                  //           child: Text(
                  //             'favourites',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1!
                  //                 .copyWith(color: defaultColor),
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 30,
                  //         child: MaterialButton(
                  //           minWidth: 1,
                  //           padding: EdgeInsets.zero,
                  //           onPressed: () {},
                  //           child: Text(
                  //             'favourites',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1!
                  //                 .copyWith(color: defaultColor),
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 30,
                  //         child: MaterialButton(
                  //           minWidth: 1,
                  //           padding: EdgeInsets.zero,
                  //           onPressed: () {},
                  //           child: Text(
                  //             'favourites',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1!
                  //                 .copyWith(color: defaultColor),
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 30,
                  //         child: MaterialButton(
                  //           minWidth: 1,
                  //           padding: EdgeInsets.zero,
                  //           onPressed: () {},
                  //           child: Text(
                  //             'favourites',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1!
                  //                 .copyWith(color: defaultColor),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  if (postModel.image != '')
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Image.network(
                        postModel.image!,
                        fit: BoxFit.cover,
                        height: 350,
                        width: double.infinity,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(Icons.favorite),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'comments',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(currentUser!.image),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'write a comment...',
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite, color: Colors.grey),
                                color: Colors.grey,
                                onPressed: () async {
                                  await socialCubit.likePost(postId);
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'like',
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
