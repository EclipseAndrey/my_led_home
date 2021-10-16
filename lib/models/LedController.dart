import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_led_home/models/initStatus.dart';
import 'package:my_led_home/socket.dart';
import 'package:rxdart/rxdart.dart';

///  режим --- начало ---- конец ---- доп --------------------
///  Режимы
///  001 - свечение
///  002 - обычный эффект
///  003 - светомузыка
///
///  1 - Свечение
///  000 яркость
///  000 цвет
///  000 насыщенность
///
///  2 - Обычный эффект
///  c - если передаем
///  000 - номер эффекта
///  000 - яркость (если доступно)
///  000 - цвет (если доступно)
///  000 - насыщенность (если доступно)
///
///  3 - светомузыка
///  000 - номер эффекта
///  с - если передаем
///  000 - яркость (если доступно)
///  000 - цвет (если доступно)
///  000 - насыщенность (если доступно)
///
///  обратка тоже самое
///
///
///
///
///
///
///
///




class LedController{

  LedController(this.socket){
    socket.listen(dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false);
  }
  Socket socket;
  BehaviorSubject _statusController = BehaviorSubject<InitStatus>();
  Stream get streamStatus => _statusController.stream;


  static final int countLeds = 300;
  static final int lMode = 3;
  static final int lBegin = 4;
  static final int lEnd = 4;
  static final int lData = 20;

  List<Effect> currentEffects = [];



  updateCurrentEffects()async{
    //TODO update current effects
  }
  addEffect(Effect effect){
    socket.write(effect.toData());
  }

  void errorHandler(error, StackTrace trace){
    print(error);
    message += ("SOCKET:\n $error\n");
    setState(() {

    });
  }

  void doneHandler(){
    socket.destroy();
    printL("SOCKET done");
  }


  void cleanData(){
    socket.destroy();
    socket = null;
  }

  dispose(){
    _statusController.close();
  }


}


class Distance{
  final int begin;
  final int end;

  Distance(this.begin, this.end);
}

class Effect{
  static final int lMode = LedController.lMode;
  static final int lBegin = LedController.lBegin;
  static final int lEnd = LedController.lEnd;
  static final int lData = LedController.lData;
  final int mode;
  final Distance distance;
  Color color;
  int effectMode;

  Effect({
    @required this.mode,
    @required this.distance,
    this.color,
    this.effectMode
  });

  factory Effect.fromData(Iterable<int> charCodes){
    List<int> codes = charCodes.toList();
    Iterable<int> mode = codes.getRange(0, lMode);
    Distance distance = Distance(
        int.parse(String.fromCharCodes(codes, lMode, lMode+lBegin+1)),
        int.parse(String.fromCharCodes(codes, lMode+lBegin+1, lMode+lBegin+lEnd+2))
    );
    int _beginData = lMode+lBegin+lEnd+2;
    String data = String.fromCharCodes(codes, _beginData, _beginData+lData+1);

    Color findColor(){
      bool find = data.contains("c");
      if(find){
        int indexColor = data.indexOf("c");
        int hue = int.parse(data.substring(indexColor+1+3, indexColor+1+3+4));
        int saturation = int.parse(data.substring(indexColor+1+3+4, indexColor+1+3+4+4));
        int value = int.parse(data.substring(indexColor+1, indexColor+1+3));
        Color color = HSVColor.fromAHSV(1, (255/hue)*360, 255/saturation, 255/value).toColor();
        return color;
      }else{
        return null;
      }
    }
    int findEffectMode(){
      bool find = data.contains("m");
      if(find){
        int indexMode = data.indexOf("m");
        int effectMode = int.parse(data.substring(indexMode+1+3, indexMode+1+3+4));
        return effectMode;
      }else{
        return null;
      }
    }
    return Effect(
      mode: int.parse(String.fromCharCodes(mode)),
      distance: distance,
      color: findColor(),
      effectMode: findEffectMode(),
    );
  }

  String _addingNulls(String string, int length){
    String out ="";
    for(int i =0; i < length - string.length; i++){
      out += "0";
    }
    out += string;
    return out;
  }

  String toData(){
    String data = "";
    String colorToString(){
      if(color == null) return "";
      return "c"+ _addingNulls(HSVColor.fromColor(color).value.toInt().toString(), 3)+
            _addingNulls(HSVColor.fromColor(color).hue.toInt().toString(), 3)+
            _addingNulls(HSVColor.fromColor(color).saturation.toInt().toString(), 3);

    }
    String effectModeToString(){
      if(effectMode == null) return "";
      return "m" + _addingNulls(effectMode.toString(), 3);
    }
    if(color != null){
      data += colorToString();
    }
    if(effectMode != null){
      data+= effectModeToString();
    }

    return _addingNulls(mode.toString(), lMode)
        + _addingNulls(distance.begin.toString(), lBegin)
        +_addingNulls(distance.end.toString(), lEnd)
        +_addingNulls(data, lData)
        +"\n";
  }
}