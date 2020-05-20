import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limas_burger/view/ProdutoView.dart';

class DialogQuantidadeProduto extends StatefulWidget{
  ProdutoViewPageState _pai;
  DialogQuantidadeProduto(this._pai);
  @override
  _DialogQuantidadeProdutoState createState() => _DialogQuantidadeProdutoState();

}

class _DialogQuantidadeProdutoState extends State<DialogQuantidadeProduto>{
  Widget itemFinal = Text("Mais de 4 Unidades");
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    int intemCount = 5;
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height/8,
        child: Center(child: Text("Quantidade")),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width-40,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: intemCount,
          itemBuilder: (BuildContext context, int index) {
            return(
              Column(
                  children:<Widget>[
                    InkWell(
                      onTap: (){
                        if(index<intemCount-1){
                          widget._pai.setQuantidade(index+1);
                          Navigator.pop(context);
                        }else{
                          setState(() {
                            itemFinal = Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child:TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20
                                ),
                                onSubmitted: (value){
                                  try{
                                    widget._pai.setQuantidade(int.parse(value));
                                    Navigator.pop(context);
                                  }on Exception{
                                    print("isto não é um número");
                                  }
                                  
                                },
                                onTap: (){
                                  setState(() {
                                    _scrollController.jumpTo(160);
                                  });
                                },
                              ),
                            );
                          });
                        }
                      },
                      child: Center(
                        child:Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: index==intemCount-1?itemFinal:Text(index==0?"${index+1} Unidade":"${index+1} Unidades")),
                      )
                    ),
                    Divider()
                  ],
                )
            );          
          },
        )
      )
    );  
  }
}
 
 