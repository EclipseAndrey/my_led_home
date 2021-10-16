import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_led_home/models/EffectData.dart';
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
/// при инициализации получить данные с есп
///
/// отправить режим
/// получить данные с есп если прошло более 3 сек
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
  BehaviorSubject _logsController = BehaviorSubject<String>();
  Stream get streamLogs => _logsController.stream;

  static final int countLeds = 300;
  static final int lMode = 3;
  static final int lBegin = 4;
  static final int lEnd = 4;
  static final int lData = 20;

  List<Effect> currentEffects = [];


  bool awaitData = false;



  updateCurrentEffects()async{
    //TODO update current effects
    socket.write("gd\n");
    awaitData = true;
  }



  addEffect(Effect effect){
    socket.write(effect.toData());
  }

  void errorHandler(error, StackTrace trace){
    print(error);
    printL("SOCKET:\n $error\n");

  }

  void doneHandler(){
    socket.destroy();
    printL("SOCKET done");
  }

  void dataHandler(data){
    parseData( data);
    awaitData = false;
    setState();
  }


  void parseData(String data){
    
  }






  void cleanData(){
    socket.destroy();
    socket = null;
  }

  dispose(){
    _statusController.close();
    _logsController.close();
  }

  printL(String str){
    message += str + "\n";
    setState();
  }




  setState(){
    _logsController.sink.add(message);
    //todo
  }



}



