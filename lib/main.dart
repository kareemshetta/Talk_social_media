import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubits/app_cubit/app_cubit.dart';
import 'package:social_media_app/screens/chat_detailed_screen.dart';
import 'package:social_media_app/screens/creat_post_screen.dart';
import 'package:social_media_app/screens/edit_screen.dart';
import 'package:social_media_app/screens/settings_screen.dart';
import './cubits/social_cubit/social_cubit.dart';
import './layout/home_screen.dart';
import './screens/register_screen.dart';
import './screens/social_login_screen.dart';
import './cubits/observer_cubit.dart';
import './styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit(),
        ),
        BlocProvider<SocialCubit>(
          create: (context) => SocialCubit(),
          // ..getCurrentUserData()
          // ..getPostLikesNumber(),
          //  ..getPosts(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Talk',
        theme: lightTheme,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapShot) {
              if (userSnapShot.data != null) {
                SocialCubit.get(ctx)
                  ..getCurrentUserData()
                  ..getPostLikesNumber();
                return HomeScreen();
              } else {
                return RegisterSocialScreen();
              }
            }),
        routes: {
          LoginSocialScreen.routeName: (ctx) => LoginSocialScreen(),
          RegisterSocialScreen.routeName: (ctx) => RegisterSocialScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          EditScreen.routeName: (ctx) => EditScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          CreatePostScreen.routeName: (ctx) => CreatePostScreen(),
          ChatDetailedScreen.routeName: (ctx) => ChatDetailedScreen(),
        },
      ),
    );
  }
}
