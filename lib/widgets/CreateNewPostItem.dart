import 'package:flutter/material.dart';

import '../components.dart';
import '../models/user_model.dart';
import '../screens/creat_post_screen.dart';

class CreateNewPostItem extends StatelessWidget {
  const CreateNewPostItem({
    required this.currentUser,
    Key? key,
  }) : super(key: key);
  final UserModel currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(currentUser.image),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              focusColor: Colors.grey,
              onTap: () {
                navigateNamed(context, CreatePostScreen.routeName);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'what\'s on your mind?',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
