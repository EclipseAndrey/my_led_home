import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<int> selectMode(BuildContext context)async{

  Widget item ({ @required String name, @required int index,} ){
    return ListTile(
      title: Text(name,style: TextStyle(color: Colors.white, fontSize: 16 , fontWeight: FontWeight.w500)),
      onTap: (){
        Navigator.pop(context,index);
      },
    );
  }

  return await showStickyFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: 1,
    headerHeight: 200,
    context: context,
    headerBuilder: (BuildContext context, double offset) {
      return Container(
        child: Center(
          child: Text("Выберите режим", style: TextStyle(color: Colors.white, fontSize: 18 , fontWeight: FontWeight.w600),),
        ),
      );
    },
    bodyBuilder: (BuildContext context, double offset) {
      return SliverChildListDelegate(
        <Widget>[
          item(name: "Музыка (пока недоступно)", index: 1),
          item(name: "Сплошное свечение", index: 1),

        ],
      );
    },
    anchors: [0, 0.5, 1],
  );
}