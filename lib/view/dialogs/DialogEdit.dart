import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';

class DialogEdit extends StatefulWidget{
  String input;
  String tipo;
  DialogEdit(this.input, this.tipo);
  @override
  _DialogEditState createState() => _DialogEditState();

}

class _DialogEditState extends State<DialogEdit>{
  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey _key2 = GlobalKey();



  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title:Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height/8,
        child: Center(child: Text("Editar ${widget.tipo}", textAlign: TextAlign.center,)),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _key,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                keyboardType: widget.tipo == "E-mail"? TextInputType.emailAddress: TextInputType.text,
                decoration: InputDecoration(
                  labelText: widget.tipo,
                ),
                validator: (text)=>widget.tipo == "E-mail"? Usuario.validarEmail(text):(){},
                onChanged: (text)=>widget.input = text.trim(),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.circular(6)
                ),
                child: FlatButton(
                  child: Text("Salvar",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: _sendForm 
                )
              ),
            ],
          )
        ),
      ),
    );  
  }


  _sendForm() async {
      
  }

  

}
 
 