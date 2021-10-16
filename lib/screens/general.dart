import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_led_home/screens/SelectMode.dart';
import 'package:my_led_home/screens/SelectZone.dart';
import 'package:my_led_home/socket.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({Key key}) : super(key: key);

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  int zone;
  int mode;
  Color color = Color.fromRGBO(189, 24, 255, 1);


  @override
  Widget build(BuildContext context) {
    if(zone == null){
      return buildEmptyZone();
    }else if(mode == null){
      return buildSelectMode();
    }else if(zone == 1){
      return buildPol();
    }
    return buildErrorZone();
  }

  Widget buildEmptyZone(){
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: ()async{
                int res = await selectZone(context);
                if(res != null){
                  setState(() {
                    zone = res;
                  });
                }
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(1500)),
                  border: Border.all(color: Colors.black, width: 1)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: Text('Тык', style: TextStyle(color: Colors.black , fontSize: 32),)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPol(){
    return Scaffold(

      body: Scaffold(body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 100,
            ),
          ),
          RotationTransition(
            turns: new AlwaysStoppedAnimation(180/ 360),

            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.white,color.withOpacity(0.3), color.withOpacity(0.2)],
                  [color.withOpacity(0.5), color.withOpacity(0.4),Colors.white,],
                  [Colors.white,color.withOpacity(0.7), color.withOpacity(0.6)],
                  [color, color.withOpacity(0.8) , Colors.white]
                ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.10, 0.23, 0.25, 0.30],
                blur: MaskFilter.blur(BlurStyle.solid, 10),
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),

              waveAmplitude: 0,
              size: Size(
                MediaQuery.of(context).size.width,
                144,
              ),
            ),
          ),
        ],
      )),);
  }

  Widget buildErrorZone(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Зона какая-то неправильная, тыкни и выбери нормальную, э', textAlign: TextAlign.center,),
            ),
            SizedBox(height: 24,),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: ()async{
                int res = await selectZone(context);
                if(res != null){
                  setState(() {
                    zone = res;
                  });
                }
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1500)),
                    border: Border.all(color: Colors.black, width: 1)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: Text('Тык', style: TextStyle(color: Colors.black , fontSize: 32),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildSelectMode(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Выбери режим', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
            ),
            SizedBox(height: 24,),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: ()async{
                int res = await selectMode(context);
                if(res != null){
                  setState(() {
                    mode = res;
                  });
                }
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1500)),
                    border: Border.all(color: Colors.black, width: 1)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: Text('Тык', style: TextStyle(color: Colors.black , fontSize: 32),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
