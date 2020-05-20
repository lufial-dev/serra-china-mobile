import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Connection extends StatefulWidget{
  @override
  _ConnectionState createState() => _ConnectionState();

}

class _ConnectionState extends State<Connection>{
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150.0,
        height: 150.0,
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.signal_wifi_off,
                color: Colors.grey,
                size: 50,
              ),
              Spacer(),
              Text("Ops!",
                
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              Spacer(),
              Text("Verifique sua conexão com a internet.",
              textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18
            
                ),
              )
            ],
          )
        ),
      )
    );
  }

}