
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/language/i18n/i18n.dart';
import '../../../common/textstyle/textstyle.dart';

class MinePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text("我的", style: AppFont.textStyle(14, color: Colors.white.withOpacity(0.5)),);

  }

}