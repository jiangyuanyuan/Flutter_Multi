import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdemo/page/guide_page.dart';
import 'package:flutterdemo/page/root_page.dart';
import 'package:flutterdemo/provider/user.dart';
import 'package:flutterdemo/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/appconst/const.dart';
import 'common/language/i18n/i18n.dart';
import 'common/util/t_event_bus.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => UserModel(),
          child: MyApp()
      )
  );
}
GlobalKey<_FreeLocalizations> freeLocalizationStateKey1 =
new GlobalKey<_FreeLocalizations>(); //

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      ScreenUtilInit(
        designSize: Size(375, 667),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () =>
            MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primaryColor: const Color(0xff5C96EA),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: AppBarTheme(elevation: 0, brightness: Brightness.light),
                  primaryTextTheme: TextTheme(headline6: TextStyle(fontSize:17, fontFamily: "PingFang-Medium", color: AppColor.font333)),
                ),
                debugShowCheckedModeBanner: false,
                onGenerateRoute: onGenerateRoute,
                home:  GuidePage(),
                localizationsDelegates: const [
                  I18n.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: I18n.delegate.supportedLocales,
                builder: (context, child) {
                  // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent, animate: true);
                  return Material(
                      type: MaterialType.transparency,
                      child: FreeLocalizations(
                        key: freeLocalizationStateKey1,
                        child: FlutterEasyLoading(
                          child: child,
                        ),
                      ),
                    );
                }
            )
      );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


class FreeLocalizations extends StatefulWidget {
  final Widget child;

  FreeLocalizations({required Key key, required this.child}) : super(key: key);

  @override
  State<FreeLocalizations> createState() {
    return new _FreeLocalizations();
  }
}

class _FreeLocalizations extends State<FreeLocalizations> {
  Locale _locale = const Locale('zh', '');

  Future<Locale> getDeviceLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageStr = prefs.getString('languageCode');
    String? country = prefs.getString('countryCode');
    if(languageStr != null) {
      return Locale(languageStr, country);
    } else {
      prefs.setString('languageCode', "zh");
      prefs.setString('countryCode', "");
      return _locale;
    }

  }

  //监听bus
  void listen(){
    teventBus.on<Locale>().listen((locale){
      changeLocale(locale);
    });
  }

  changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    Future<Locale> locale = getDeviceLocale();
    locale.then((locales) async {
      if(locale != null) {
        changeLocale(locales);
        // 设置语言
        I18n.locale = locales;
        teventBus.fire(locales);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    freeLocalizationStateKey1.currentState?.listen();
    return new Localizations.override(
      context: context,
      locale: _locale,
      child: widget.child,
    );
  }
}

