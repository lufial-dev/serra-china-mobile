import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CriarContaView.dart';
import 'package:limas_burger/view/dialogs/DialogLogin.dart';

class DialogUsuario extends StatefulWidget{
  ProdutoPedido produto;
  List<ProdutoPedido> produtos;
  DialogUsuario(this.produto, this.produtos);
  @override
  _DialogUsuarioState createState() => _DialogUsuarioState();

}

class _DialogUsuarioState extends State<DialogUsuario>{
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title:Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height/8,
        child: Center(child: Text("Acesse sua conta para continuar comprando", textAlign: TextAlign.center,)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: MyColors.secondaryColor,
              borderRadius: BorderRadius.circular(6)
            ),
            child: FlatButton(
              child: Text("Criar conta",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CriarContaView(widget.produto, widget.produtos)));
              },)
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.secondaryColor),
              borderRadius: BorderRadius.circular(6)
            ),
            child: FlatButton(
              child: Text("Acessar a minha conta",
                style: TextStyle(
                  color: MyColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return DialogLogin(widget.produto, widget.produtos);
                  }
                );
              },)
          ),
        ]
         
      ),
    );  
  }

}
 
 