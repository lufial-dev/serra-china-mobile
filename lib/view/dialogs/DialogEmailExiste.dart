import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/util/util.dart';

class DialogEmailExiste extends StatefulWidget{

  @override
  _DialogEmailExisteState createState() => _DialogEmailExisteState();

}

class _DialogEmailExisteState extends State<DialogEmailExiste>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(   
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Container(
        height: MediaQuery.of(context).size.height/9,
        color: Colors.black54,
        child:Center(
          child: Text("Email já cadastrado",
            style: TextStyle(color: Colors.white),
          ), 
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
           color: Colors.black54,
           border: Border(
             top: BorderSide(
               color: Colors.grey
             )
           )
        ),
       
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child:FlatButton(
              onPressed: (){},
                child:Text("Acessar minha conta",
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    color: MyColors.secondaryColor
                  ),
                ),
            ),
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child:Text("Tentar outro Email",    
                  textAlign: TextAlign.center,        
                  style: TextStyle(
                      color: MyColors.secondaryColor
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );  
  }
}
 
 