import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/EnderecoView.dart';

class DialogBemVindo extends StatefulWidget{

  ProdutoPedido produto;
  List<ProdutoPedido> produtos;

  DialogBemVindo(this.produto, this.produtos);

  @override
  _DialogBemVindoState createState() => _DialogBemVindoState();

}

class _DialogBemVindoState extends State<DialogBemVindo>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),

      content: WillPopScope( 
        onWillPop: () async => false,
        child: Container(
          height: 210,
          padding: EdgeInsets.only(top:20),
          color: Colors.black54,       
          child: Column(
            children: <Widget>[
              Icon(Icons.sentiment_very_satisfied, color: MyColors.secondaryColor, size: 60,),
              Container(
                padding: EdgeInsets.only(top:20),
                child:Text("Olá ${Util.usuario.nome.split(' ')[0]}, seja Bem Vindo(a)!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:20),
                child: FlatButton(
                onPressed: (){
                  if(widget.produtos==null && widget.produto==null){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }else
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EnderecoView(widget.produto, widget.produtos)));
                },
                  child:Text("Obrigado!",
                    style: TextStyle(
                      color: MyColors.secondaryColor,
                      fontSize: 20
                    ),
                  ),
              ),
              )
              
            ],
          ),
        ),
      )
      
    );  
  }
}
 
 