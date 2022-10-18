import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/local/cache_helper.dart';

import '../../screens/feed_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/users_screen.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialState());

  static AppCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  ThemeMode themMode = ThemeMode.light;
  bool isDark = false;

  void changeTheme() async {
    isDark = !isDark;
    await CacheHelper.setBoolean(key: 'isDark', value: isDark);
    emit(ChangeAppThemeState());
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.message,
        ),
        label: 'chat'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];
  List<Widget> screens = [FeedScreen(), UserScreen(), SettingsScreen()];

  int currentIndex = 0;
  void changeBottomNavigation(int index) async {
    if (index == 2) {
      // SocialCubit.get(context).getAllUsers()
    }
    currentIndex = index;
    emit(AppBottomNavigationChangeState());
  }
}
