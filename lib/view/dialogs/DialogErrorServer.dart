import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limas_burger/view/dialogs/Connection.dart';

class DialogErrorServer extends StatefulWidget{
  bool _exit;
  DialogErrorServer(this._exit);
  @override
  _DialogErrorServerState createState() => _DialogErrorServerState();

}

class _DialogErrorServerState extends State<DialogErrorServer>{
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            content: Connection(),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  widget._exit?SystemNavigator.pop():Navigator.of(context).pop();
                },
              ),
            ],
    );  
  }

}
 
 