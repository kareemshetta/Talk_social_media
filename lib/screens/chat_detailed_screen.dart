import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubits/social_cubit/social_cubit.dart';
import 'package:social_media_app/cubits/social_cubit/social_states.dart';
import 'package:social_media_app/models/message_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/styles/colors.dart';

class ChatDetailedScreen extends StatelessWidget {
  ChatDetailedScreen({Key? key}) : super(key: key);
  static const routeName = 'chat-detailed';
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userModel.image),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              userModel.name,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 3, right: 4),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('chats')
                    .doc(userModel.id)
                    .collection('messages')
                    .orderBy('dateTime')
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  print('currenet user:${currentUser.uid}');
                  print('target user${userModel.id}');
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (asyncSnapshot.hasData) {
                    print('sccuss');
                    List<MessageModel> messages = [];
                    for (var doc in asyncSnapshot.data!.docs) {
                      messages.add(MessageModel.fromJson(doc.data()));
                    }
                    if (messages.isEmpty) {
                      return Center(
                          child: Text('no messsage to show ..let\'s chat'));
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (currentUser.uid == messages[index].senderId) {
                            return buildMyMessage(messages[index].text);
                          } else {
                            return buildMessage(messages[index].text);
                          }
                        },
                        itemCount: asyncSnapshot.data!.docs.length,
                      );
                    }
                  } else {
                    return Center(
                      child: Text('no data to show'),
                    );
                  }
                },
              ),
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                          hintText: 'put your message',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: MaterialButton(
                      minWidth: 1,
                      onPressed: () {
                        SocialCubit.get(context).sendMessage(
                            text: textController.text,
                            receiverId: userModel.id,
                            dateTime: DateTime.now().toIso8601String());
                        textController.clear();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildMessage(String text) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(0))),
          child: Text(text)),
    ),
  );
}

Widget buildMyMessage(String text) {
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
              color: defaultColor[200],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(15))),
          child: Text(text)),
    ),
  );
}
