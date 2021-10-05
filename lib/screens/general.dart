import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_led_home/socket.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({Key key}) : super(key: key);

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                child: Center(child: Text("Отправить")),
              ),
            ),
          ),
        )

      ],
    );
  }
}
