import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../common/appconst/const.dart';
import '../common/language/i18n/i18n.dart';
import 'home/page/home_page.dart';
import 'mine/page/mine_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}
class _RootPageState extends State<RootPage> {
  int currentIndex = 0;
  DateTime? lastPopTime;

  PageController _pageController = PageController(initialPage: 0);
  List<Widget> pages = <Widget>[
    HomePage(),
    MinePage()
  ];
  static const List<String> tabIconsName = [
    "home.png",
    "home_exchange.png",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if(lastPopTime == null || DateTime.now().difference(lastPopTime!) > Duration(seconds: 2)){
            lastPopTime = DateTime.now();
            EasyLoading.showToast(I18n.of(context)!.againexit);
            return true;
          }else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return false;
          }
        },
        child: PageView(
          children: pages,
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        fixedColor: Colors.white,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        items: _createTabarList(),
        onTap: _tabIndexChanged,
      ),
    );
  }

  List<BottomNavigationBarItem> _createTabarList() {
    List<String> tabTitles = [
      I18n.of(context)!.home,
      I18n.of(context)!.mine,
    ];
    return tabTitles.map((e) {
      final index = tabTitles.indexOf(e);
      return BottomNavigationBarItem(
          icon: Image.asset("assets/${tabIconsName[index]}",),
          activeIcon: Image.asset("assets/${tabIconsName[index]}",),
          label: e
      );
    }).toList();
  }

  void _tabIndexChanged(int index) {
    setState(() {
      currentIndex = index;
      _pageController.jumpToPage(index);
    });
    if(index == 0) {

    }
  }

}