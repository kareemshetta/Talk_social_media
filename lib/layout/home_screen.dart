import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components.dart';
import 'package:social_media_app/screens/register_screen.dart';

import '../cubits/app_cubit/app_state.dart';
import '../cubits/app_cubit/app_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';
  @override
  Widget build(BuildContext context) {
    final fireAuth = FirebaseAuth.instance;
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final appCubit = AppCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Text('Talk'),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    navigateAndReplacementNamed(
                        context: context,
                        routeName: RegisterSocialScreen.routeName);
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text('log out'),
                ),
              ],
            ),
            body: appCubit.screens[appCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: appCubit.items,
              currentIndex: appCubit.currentIndex,
              onTap: appCubit.changeBottomNavigation,
            ));
      },
    );
  }
}
