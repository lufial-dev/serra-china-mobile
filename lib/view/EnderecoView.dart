import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CriarEnderecoView.dart';
import 'package:limas_burger/view/FormaPagamentoView.dart';
import 'package:limas_burger/view/dialogs/DialogErrorServer.dart';

import 'CriarEnderecoView.dart';

class EnderecoView extends StatefulWidget{
  ProdutoPedido produto;
  List<ProdutoPedido> produtos;
  EnderecoView(this.produto, this.produtos);
  
  @override
  State<StatefulWidget> createState() => EnderecoViewPageState();
} 

class EnderecoViewPageState extends State<EnderecoView>{

  @override
  void initState() {
    super.initState();
    _getData();
  }

  

  _getData() async { 
    try{
      var enderecos = [];
      List _resultUsuario = await Usuario.buscarPorId(Util.usuario.id);

      
      _resultUsuario.forEach((item){
        enderecos = item["fields"]["enderecos"];
      });
      Util.usuario.enderecos = <Endereco>[];
      enderecos.forEach((item)async{
        List _resultEndereco = await Endereco.getData(item);
        
        
        _resultEndereco.forEach((item){
          var _id = item['pk'];
          var _bairro = item['fields']['bairro'];
          var _rua = item['fields']['rua'];
          var _numero = item['fields']['numero'];
          var _referencia = item['fields']['referencia'];

          setState(() {  
            Util.usuario.enderecos.add(Endereco(_id, _bairro, _rua, _numero, _referencia)); 
          });
        });
      });


      Future.delayed(Duration(seconds: 1), ()=>setState(() {
        Util.usuario.enderecos.sort((a,b)=>a.id.compareTo(b.id));
        if(Util.usuario.enderecos==null)
          Util.usuario.enderecos = <Endereco>[];
      }));
    }catch(e){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context)=>DialogErrorServer(false)
      );
      
    }
  }

  Future<bool> _onBackPressed() async {
    Util.usuario.enderecos = null;
    return true;
  }

   @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black87,
          title: Text("Onde deseja receber?"),
        ),
        body:Theme(
          data: ThemeData(
              brightness: Brightness.dark
            ),
            child: Util.usuario.enderecos!=null?Container(
            color: Colors.black87,
            child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey,
                          )
                        )
                      ),
                      padding: EdgeInsets.only(left:20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:Text("Endereços cadastrados",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: ListView.builder(
                      itemCount: Util.usuario.enderecos.length+1,
                      itemBuilder: (BuildContext context, int index) {
                        return index!=Util.usuario.enderecos.length?Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text("${Util.usuario.nome}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Container(
                                        margin: EdgeInsets.only(top:10),
                                        child: Text(
                                          "${Util.usuario.enderecos[index].rua}, ${Util.usuario.enderecos[index].numero} - ${Util.usuario.enderecos[index].bairro} \n\n ${Util.usuario.enderecos[index].referencia} \n\n ${Util.usuario.contato}",
                                          style: TextStyle(color: Colors.white ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child:FlatButton(
                                        onPressed: (){}, 
                                        child: FlatButton.icon(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CriarEnderecoView(this, Util.usuario.enderecos[index])));
                                          },
                                          icon: Icon(Icons.edit, color: MyColors.secondaryColor, size: 20,),
                                          label:  Text("Editar", style: TextStyle(color:MyColors.secondaryColor),),
                                        ), 
                                      ),
                                    ),
                                  ],
                                ) ,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FormaPagamentoView(widget.produto, widget.produtos, Util.usuario.enderecos[index])));
                                },
                              ),
                            ),
                            Divider(color: Colors.grey)
                          ],
                        ):Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          width: MediaQuery.of(context).size.width-40,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: MyColors.secondaryColor),
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: FlatButton(
                            child: Text("Adicionar novo endereço",
                              style: TextStyle(
                                color: MyColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CriarEnderecoView(this, null)));
                            },
                          ),
                        );
                      }
                    ),       
                )
                ],
              )
            ):Container(
              color: Colors.black87,
              child: Center(
                child:CircularProgressIndicator()
            )
          ),
        )
      )
    );
  } 

  atualizar(){
    setState(() {
      Util.usuario.enderecos=null;
      _getData();
    });
  }
}