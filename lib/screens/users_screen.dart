import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components.dart';

import '../models/user_model.dart';
import 'chat_detailed_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!userSnapshot.hasData) {
          return Center(
            child: Text('there is no data to show '),
          );
        } else {
          return ListView.separated(
              itemBuilder: (context, index) {
                final List<UserModel> users = [];
                for (var userDoc in userSnapshot.data!.docs) {
                  if (userDoc.id != currentUser.uid) {
                    users.add(UserModel.fromJson(userDoc.data()));
                  }
                }

                return buildUserItem(users[index], context);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  color: Colors.grey[300],
                  indent: 20,
                  thickness: 1,
                );
              },
              itemCount: userSnapshot.data!.docs.length - 1);
        }
      },
    );
  }
}

Widget buildUserItem(UserModel user, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      onTap: () {
        navigateNamed(context, ChatDetailedScreen.routeName, args: user);
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(user.image),
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    ),
  );
}
