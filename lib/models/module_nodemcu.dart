import 'package:flutter/cupertino.dart';

class ModuleNodeMCU{
  final String name;
  final String address;
  final int port;
  final String localName;

  ModuleNodeMCU({
    @required this.name = "ESP",
    @required this.address ="192.168.1.10",
    @required this.port = 80,
    @required this.localName = "ESP"
  });


}