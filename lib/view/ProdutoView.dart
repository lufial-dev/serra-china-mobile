import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/ingrediente.dart';
import 'package:limas_burger/model/produto.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CarrinhoView.dart';
import 'package:limas_burger/view/CatalogoView.dart';
import 'package:limas_burger/view/EnderecoView.dart';
import 'package:limas_burger/view/dialogs/DialogQuantidadeProduto.dart';
import 'dart:ui' as ui;

import 'package:limas_burger/view/dialogs/DialogUsuario.dart';

class ProdutoView extends StatefulWidget{
  LimasBurgerTabBar _tabBar;
  Produto _produto;
  ProdutoPedido produtoPedido;
  static List<ListTile> _children = <ListTile>[];

  ProdutoView(this._tabBar, this._produto, this.produtoPedido);
  
  @override
  State<StatefulWidget> createState() => ProdutoViewPageState();
} 

class ProdutoViewPageState extends State<ProdutoView>{

  int quantidade = 1;
  bool atualizando = false;
  bool atuaQuant = false;
  Produto produto;

  @override
  void initState() {
    super.initState();
    if(widget.produtoPedido!=null && !atualizando){
      quantidade = widget.produtoPedido.quantidade;
      atuaQuant = true;
    }

  }

  Future<bool> onBackPressed(){
    if(widget.produtoPedido!=null)
      widget._tabBar.setTab2(CarrinhoView.getInstance(widget._tabBar));
    else
      widget._tabBar.setTab1(CatalogoView.getInstance(widget._tabBar));
  }

  getStar(int numero){
    double media = 4.5;
    return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return ui.Gradient.linear(
            media>=numero?Offset(10, 10):media<=numero-1?Offset(0, 0):Offset(0, 4),
            media>numero?Offset(0, 0):media<=numero-1?Offset(0, 0):Offset(10, 0),
            [
              Colors.yellow,
              Colors.grey,
            ],
          );
        },
        child: Icon(Icons.star, size: 20,),
      );
  }

  @override
  Widget build(BuildContext context) { 
    if(!atualizando){
      List<Ingrediente> ingredientes = [];
      for (Ingrediente item in widget._produto.ingredientes){
        Ingrediente ingrediente = Ingrediente(item.id, item.nome, item.status);
        ingrediente.selecionado=item.selecionado;
        ingredientes.add(ingrediente);
      }
      produto = Produto( widget._produto.id,  widget._produto.nome,  widget._produto.imagem,  widget._produto.valor,  widget._produto.status,  ingredientes);
      atualizando = true;
    }
    NumberFormat formatter = NumberFormat("00.00");
    String valor = formatter.format(produto.valor);
    List<Widget> _children = [];
    for(Ingrediente ingrediente in produto.ingredientes){
      _children.add(
        CheckboxListTile(
          value: ingrediente.selecionado,
          activeColor: ingrediente.status==StatusIngrediente.DISPONIVEL?MyColors.secondaryColor:Colors.grey,
          onChanged: (value)=>ingrediente.status==StatusIngrediente.DISPONIVEL?
            setState(()=>ingrediente.selecionado=value):null,
          title: Text(ingrediente.nome),
        ),
      );
    }
    return WillPopScope(
      onWillPop: onBackPressed,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            snap: true,

            actionsIconTheme: IconThemeData(opacity: 0.0),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                Util.URL_IMAGENS+produto.imagem,
                fit: BoxFit.cover,
              ),
              title: Text(produto.nome),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child:Column(
              children: <Widget>[
                 Padding(
                  padding: EdgeInsets.only(top:20, left: 20),
                  child:  Row(
                    children: <Widget>[
                      getStar(1),
                      getStar(2),  
                      getStar(3),
                      getStar(4),  
                      getStar(5),                
                      SizedBox(width: 10,),
                      Text("5 Avaliações"),
                    ],
                  ),
                ),   
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:20, left: 20),
                      child: Text("R\$ ${valor.replaceAll('.', ',')}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),  
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child:  Text("Ingredientes:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),               
                Column(
                  children: _children,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ListTile(
                    title: Text("Quantidade: $quantidade"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogQuantidadeProduto(this);
                        },
                      );
                    },
                  ), 
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width-40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: FlatButton(
                    child: Text(widget.produtoPedido!=null?"Salvar Alterações":"Comprar",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: (){
                      if(widget.produtoPedido!=null){
                        widget.produtoPedido.produto = produto;
                        widget.produtoPedido.quantidade=quantidade;

                        final SnackBar snackBar = SnackBar(
                          backgroundColor: Colors.black54,
                          content: Text("${produto.nome} atualizado",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);
                      }else{
                        if(Util.usuario==null)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogUsuario(ProdutoPedido(null, produto, quantidade), null);
                            },
                          );
                        else
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EnderecoView(ProdutoPedido(null, produto, quantidade), null)));
                      }


                    },)
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width-40,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.secondaryColor),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: FlatButton(
                    child: Text(widget.produtoPedido!=null?"Remover do carrinho":"Adicionar ao carrinho",
                      style: TextStyle(
                        color: MyColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: (){
                      String text = "";
                      if(widget.produtoPedido==null){
                        ProdutoPedido produtoPedido = ProdutoPedido(null, produto, quantidade);
                        Util.carrinho.produtos.add(produtoPedido);
                        text = "${produto.nome} foi adicionado ao carrinho";
                      }else
                        setState(() {
                          Util.carrinho.produtos.remove(widget.produtoPedido);
                          text = "${produto.nome} foi removido do carrinho";
                          widget._tabBar.setTab2(CarrinhoView.getInstance(widget._tabBar));
                        });
                      final SnackBar snackBar = SnackBar(
                        backgroundColor: Colors.black54,
                        
                        content: Text(text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    },)
                ),
              ],
            )
          )
        ],
      )
    );
  }

  void setQuantidade(int i) {
    setState(() {
      quantidade = i;
    });
  }
}