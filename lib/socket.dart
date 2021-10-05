import 'dart:io';


Socket socket;
String message = "{ log }\n";

Future<void> send(String text)async{
  socket.write(text.trim());
}
