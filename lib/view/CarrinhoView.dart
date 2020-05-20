import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/carrinho.dart';
import 'package:limas_burger/model/ingrediente.dart';
import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/EnderecoView.dart';
import 'package:limas_burger/view/ProdutoView.dart';
import 'package:limas_burger/view/dialogs/Connection.dart';
import 'package:limas_burger/view/dialogs/DialogErrorServer.dart';
import 'package:http/http.dart' as http;

class CarrinhoView extends StatefulWidget{
  LimasBurgerTabBar _pai;
  static CarrinhoView _catalogo;
  static double scroll_position = 0;
  CarrinhoView(this._pai);

  static getInstance(_pai){
    if(_catalogo==null)
      _catalogo = CarrinhoView(_pai);
    return _catalogo;
  }
  
  @override
  State<StatefulWidget> createState() => _CarrinhoViewPageState();
} 

class _CarrinhoViewPageState extends State<CarrinhoView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 255),
        elevation: 0,
        title: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                width: MediaQuery.of(context).size.width/7,
                child: Image(image:AssetImage('assets/images/logo.png')),
              ),
              Text("Carrinho")
            ],
          )
        ),
      ),
      body:Util.carrinho.produtos.length == 0?
      Center(
        child: Text("Seu carrinho está vazio",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ):
      Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: Util.carrinho.produtos.length,
              itemBuilder: (BuildContext context, int index) {
                NumberFormat formatter = NumberFormat("00.00");
                String _ingredientes = "";
                for (Ingrediente ingrediente in Util.carrinho.produtos[index].produto.ingredientes) {
                  _ingredientes+=ingrediente.nome + " | ";}
                String valor = formatter.format(Util.carrinho.produtos[index].produto.valor);
                return Container(
                  margin: EdgeInsets.only(bottom:2),
                  color: Colors.black26,
                  child: ListTile(
                    leading:Image.network(Util.URL_IMAGENS+Util.carrinho.produtos[index].produto.imagem),
                    title: Text("${Util.carrinho.produtos[index].produto.nome}"),
                    subtitle: Text(_ingredientes, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    trailing: Text(valor.replaceAll('.', ',')),
                    onTap: (){
                        widget._pai.setTab2(ProdutoView(widget._pai, Util.carrinho.produtos[index].produto, Util.carrinho.produtos[index]));
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width-40,
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(6)
              ),
              child: FlatButton(
                child: Text("Comprar",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EnderecoView(null, Util.carrinho.produtos)));
                },)
            ),
          ),
        ],
      )
    );
  }
}