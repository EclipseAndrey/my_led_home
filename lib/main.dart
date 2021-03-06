import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_led_home/models/initStatus.dart';
import 'package:my_led_home/screens/general.dart';
import 'package:my_led_home/socket.dart';
import 'package:ping_discover_network/ping_discover_network.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Led Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GeneralScreen(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InitStatus initStatus = InitStatus.awaitIP;
  TextEditingController _textEditingController = TextEditingController();





  List<Widget> devices = [];
  bool connecting = false;
  bool searching = false;

   doneHandler (){}

   errorHandler(d){}



  @override
  void initState() {
    super.initState();
    _search();
  }






  Future<void> _tryConnect(String ip)async{

    _textEditingController.text = "";
    printL("Connect $ip");
    Socket.connect(ip, 80).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false);
      printL("initialize");
      socket.write("esp\n");

      setState(() {});
    }).catchError((AsyncError e) {
      printL("Unable to connect: $e");
    });

    connecting = true;
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
    if(initStatus == InitStatus.awaitIP){
      printL("not connected for 3 s");
    }
    connecting = false;
    setState(() {});
    //Connect standard in to the socket
    //stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));


  }

  _search()async{
    devices = [];
    setState(() {
      searching = true;
    });

    List<String> ips = [];
    const port = 80;
    final stream = NetworkAnalyzer.discover2(
      '192.168.1', port,
      timeout: Duration(milliseconds: 5000),
    );

    int found = 0;
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        found++;
        message += ('Found device: ${addr.ip}:$port');
        message += "\n";
        setState(() {

        });
        if(addr.ip != "192.168.1.1") {
          devices.add(deviceItem(addr));
          ips.add(addr.ip);
          setState(() {

          });
        }
      }
    }).onDone(() async{
      message += ('Finish. Found $found device(s)');
      message += "\n";
      setState(() {
        searching = false;
      });
      for(int i = 0; i < ips.length && initStatus == InitStatus.awaitIP; i++){
        await _tryConnect(ips[i]);
      }
    });

  }

  String _initStatusString(InitStatus status) {
    switch (status) {
      case InitStatus.complete:
        return "????????????????????";
        break;
      case InitStatus.awaitIP:
        return "?????????????????? ????????????????????";
        break;
      case InitStatus.error:
        return "????????????";
        break;
      case InitStatus.loading:
        return "??????????????????";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(_initStatusString(initStatus), style: TextStyle(color: Colors.black),),
      //   actions: [
      //     GestureDetector(
      //       behavior: HitTestBehavior.deferToChild,
      //         onTap: (){
      //         //cleanData();
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.all(12.0),
      //           child: Icon(Icons.reset_tv, color: Colors.black, ),
      //         ))
      //   ],
      // ),
      body: connecting?
      Center(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("?????????????? ????????????????????"),
          ),
          CupertinoActivityIndicator(),
        ],
      ),):_buildBody(),
    );
  }

  Widget _buildBody() {
    switch (initStatus) {
      case InitStatus.complete:
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> GeneralScreen()), (route) => false);
        break;
      case InitStatus.awaitIP:
        return _buildCAwaitIP();
        break;
      case InitStatus.error:
        return SizedBox();
        break;
      case InitStatus.loading:
        return Center(child: CupertinoActivityIndicator(),);
        break;
    }
  }

  Widget _buildComplete() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _textEditingController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: (){
              if(_textEditingController.text.isNotEmpty)
              send(_textEditingController.text);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              width: MediaQuery.of(context).size.width-32,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text("??????????????????")),
              ),
            ),
          ),
        )

      ],
    );
  }

  Widget _buildCAwaitIP() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Text("???????????? ??????????????????????", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "10",
                helperStyle: TextStyle(color: Colors.black.withOpacity(0.1  ))
              ),
              controller: _textEditingController,

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: (){
                _tryConnect("192.168.1.${_textEditingController.text.isEmpty?"10":_textEditingController.text}");
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                width: MediaQuery.of(context).size.width-32,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("????????????????????")),
                ),
              ),
            ),
          ),
          devices.length == 0?SizedBox():Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Text("???????????????????? ?? ????????", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
              ),
              searching?Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(),
                ),
              ):SizedBox(),
              Column(
                children: List.generate(devices.length, (index) => devices[index]),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, ),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(message),
          ),

        ],
      ),
    );
  }


  void dataHandler(data){
    print(new String.fromCharCodes(data).trim());
    message += "SOCKET:\n" + new String.fromCharCodes(data).trim() + "\n";

    if(String.fromCharCodes(data).trim() == "ok"){
      initStatus = InitStatus.complete;
      printL("Connected");

      // socket = null;
      // initStatus = InitStatus.awaitIP;
      // printL("not connected: ${String.fromCharCodes(data).trim()}");
    }else{

    }


  }



  printL(String str){
    message += str + "\n";
    setState(() {

    });
  }

  Widget deviceItem(NetworkAddress address){
    return           Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: (){
          _tryConnect(address.ip);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          // width: MediaQuery.of(context).size.width-32,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(address.ip)),
          ),
        ),
      ),
    );
  }





}
