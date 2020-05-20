import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/PedidosView.dart';

class DetalhePedidoView extends StatefulWidget {
  LimasBurgerTabBar _tabBar;
  Pedido _pedido;
  DetalhePedidoView(this._tabBar, this._pedido);

  @override
  State<StatefulWidget> createState() => DetalhePedidoViewState();
}

class DetalhePedidoViewState extends State<DetalhePedidoView> {
  final formatDate = DateFormat('dd/MM/dd hh:mm');
  List<ListTile> _listProdutos = List();
  NumberFormat formatterValor = NumberFormat("00.00");
  final double tamanhoFontItem = 15;

  @override
  void initState() {
    List<ProdutoPedido> _produtos = widget._pedido.produtos;
    for (ProdutoPedido produtoPedido in _produtos) {
      NumberFormat formatterValor = NumberFormat("00.00");
      String valor = formatterValor.format(produtoPedido.produto.valor);
      ListTile listTile = ListTile(
        title: Text(produtoPedido.produto.nome,
            style: TextStyle(
                fontSize: tamanhoFontItem, fontWeight: FontWeight.bold)),
        trailing: Text(valor,
            style: TextStyle(
                fontSize: tamanhoFontItem, fontWeight: FontWeight.bold)),
      );

      _listProdutos.add(listTile);
    }
  }

  Future<bool> onBackPressed() {
    widget._tabBar.setTab3(PedidosView.getInstance(widget._tabBar));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromRGBO(0, 0, 0, 255),
              elevation: 0,
              title: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        width: MediaQuery.of(context).size.width / 7,
                        child:
                            Image(image: AssetImage('assets/images/logo.png')),
                      ),
                      Text("Detalhamento do pedido")
                    ],
                  )),
            ),
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Produtos",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Column(children: _listProdutos),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Valor total ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            formatterValor.format(widget._pedido.valorTotal),
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Forma de pagamento ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            widget._pedido.formaDePagamento,
                            style: TextStyle(
                                fontSize: tamanhoFontItem, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Data/Hora do pedido ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            formatDate.format(widget._pedido.dataHoraPedido),
                            style: TextStyle(
                                fontSize: tamanhoFontItem, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Data/Hora da entrega ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            widget._pedido.dataHoraEntrega!= null? formatDate.format(widget._pedido.dataHoraPedido):"Não definida.",
                            style: TextStyle(
                                fontSize: tamanhoFontItem, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Informações do cliente ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Nome: " + widget._pedido.usuario.nome,
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Contato: " + widget._pedido.usuario.contato,
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 20, bottom: 20),
                          child: Text(
                            "Informações de endereço",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Rua: " + widget._pedido.enderecoEntrega.rua,
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Bairro: " + widget._pedido.enderecoEntrega.bairro,
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Nº: " + widget._pedido.enderecoEntrega.numero,
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Referência: " +
                                widget._pedido.enderecoEntrega.referencia,
                            style: TextStyle(
                                fontSize: tamanhoFontItem,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 10,
                    ),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                            color: MyColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: FlatButton(
                          child: Text(
                            "Cancelar pedido",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {},
                        )),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColors.secondaryColor),
                            borderRadius: BorderRadius.circular(6)),
                        child: FlatButton(
                            child: Text(
                              "Editar Pedido",
                              style: TextStyle(
                                color: MyColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {})),
                  ],
                ))
          ],
        ));
  }
}
