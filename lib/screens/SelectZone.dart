import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<int> selectZone(BuildContext context)async{

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
          child: Text("Выберите зону", style: TextStyle(color: Colors.white, fontSize: 18 , fontWeight: FontWeight.w600),),
        ),
      );
    },
    bodyBuilder: (BuildContext context, double offset) {
      return SliverChildListDelegate(
        <Widget>[
          item(name: "Пол блять", index: 1),
          item(name: "Снова пол блять", index: 1),
          item(name: "Тут тоже пол", index: 1),
          item(name: "И тут пол", index: 1),
          item(name: "Пусто", index: 1),
          item(name: "Пусто", index: 1),
          item(name: "Пусто", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Пол", index: 1),
          item(name: "Ты ожидал что-то еще?", index: 1),
          item(name: "Нет", index: 1),
          item(name: "Тут", index: 1),
          item(name: "Только", index: 1),
          item(name: "Пол.", index: 1),
        ],
      );
    },
    anchors: [0, 0.5, 1],
  );
}
