import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/appconst/const.dart';
import '../common/commview/btn_action.dart';
import '../common/language/i18n/i18n.dart';

class GuidePage extends StatefulWidget {

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000)).then((value) => _jumpToRoot(context));
  }


  void _jumpToRoot(BuildContext context) async {
    final share = await SharedPreferences.getInstance();
    // if(share.getString(AppConst.KEY_user_token) != null) {
    //   Navigator.of(context).pushNamedAndRemoveUntil('/root', (route) => false);
    // } else {
    //
    // }
    Navigator.of(context).pushNamedAndRemoveUntil('/root', (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.back998,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/背景图.png"),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.asset("assets/手机.png"),
                  Positioned(
                    right: 40,
                    top: 40,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, "/language"),
                      child: Image.asset("assets/语言切换.png")
                    ),
                  )
                ],
              ),
              SizedBox(height: 40,),
              BtnAction(
                title: I18n.of(context)!.login,
                onTap: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
