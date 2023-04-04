import 'package:flutter/material.dart';

import '../MainViews/AppBarPages/calendar_view.dart';
import '../MainViews/Pages/conversations_view.dart';
import '../MainViews/Pages/home_view.dart';
import '../MainViews/Pages/profile_view.dart';
import '../MainViews/Pages/search_view.dart';

class PageProvider with ChangeNotifier{
  List<Widget> _pages = [
    Home(),
    Search(),
    Conversations(),
    Profile(),
    Calendar()
  ];
  int _currentIndex = 0;
  Widget _page = Home();

  Widget get page => _page;
  int get currentIndex => _currentIndex;

  void changeIndex(int index){
    _page = _pages[index];
    _currentIndex = index;
    notifyListeners();
  }
  void changePage(Widget newPage){
    _page = newPage;
    notifyListeners();
  }
}