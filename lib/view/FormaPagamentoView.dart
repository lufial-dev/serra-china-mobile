import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/DadosPedidoView.dart';

class FormaPagamentoView extends StatefulWidget{
  ProdutoPedido produto;
  List<ProdutoPedido> produtos;
  Endereco endereco;
  FormaPagamentoView(this.produto, this.produtos, this.endereco);
  
  
  @override
  State<StatefulWidget> createState() => EnderecoViewPageState();
} 

class EnderecoViewPageState extends State<FormaPagamentoView>{  

  int selectedRadio = 1;
  double troco = 0;
  double valorTotal;
  GlobalKey<FormState> _key = GlobalKey();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale:'pt_Br');
  @override
  void initState() {
    super.initState();
    valorTotal = calcValorTotal();
  }
    
  @override
  Widget build(BuildContext context) {
    
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Como deseja pagar?"),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),

        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width-40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.secondaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: Text("Valor total: ${formatter.format(valorTotal)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("FORMA DE PAGAMENTO:")
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 2),
                color: Colors.black26,
                child: RadioListTile(
                  groupValue: selectedRadio,
                  onChanged: (val) => setState(()=>selectedRadio=val),
                  value: 1,
                  title: Text("Cartão"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 2),
                color: Colors.black26,
                child: RadioListTile(
                  groupValue: selectedRadio,
                  onChanged: (val)=>setState(()=>selectedRadio = val),
                  value: 2,
                  title: Text("Dinheiro"),
                  secondary: Icon(selectedRadio!=2?Icons.arrow_right:Icons.arrow_drop_down),
                  subtitle: selectedRadio==2?Container( 
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Form(
                      key: _key,
                      child: TextFormField(
                        inputFormatters: [  
                            WhitelistingTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter()
                        ],
                        decoration: InputDecoration(
                          labelText: "Troco",
                        ),
                        validator: (text)=>_validarValor(text),
                      ),
                    ),
                  ):null,
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                width: MediaQuery.of(context).size.width-40,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.secondaryColor),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: FlatButton(
                  child: Text("Continuar",
                    style: TextStyle(
                      color: MyColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: _sendForm
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } 

  String _validarValor(String text){
    if(text.length>3){
      text = text.substring(3).replaceAll(',', '.');
      troco = double.parse(text);
      // if(troco>valorTotal)
      //   return "O troco não pode ser maior do que o valor do pedido";
    }
    return null;
  }

  _sendForm(){
    if(selectedRadio == 1 || _key.currentState.validate()){
      Pedido pedido = Pedido(null, DateTime.now(), null, StatusPedido.INICIADO, formaPagamento(selectedRadio), valorTotal, widget.endereco, Util.usuario, getProdutos());       
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DadosPedidoView(pedido)));
    }
  }

  formaPagamento(val){
    if(val==1)
      return FormaDePagamento.CARTAO;
    return FormaDePagamento.DINHEIRO;
  }

  double calcValorTotal() {
    double valor = 0;
    if(widget.produtos!=null)
      for(ProdutoPedido produto in widget.produtos)
        valor+= produto.produto.valor*produto.quantidade;
    else
      valor = widget.produto.produto.valor*widget.produto.quantidade;
    return valor;
  }

  List<ProdutoPedido> getProdutos() {
    List<ProdutoPedido> produtos = [];
    if(widget.produto != null){
      produtos.add(widget.produto);
      return produtos;
    }
    return widget.produtos;
    
  }
}


class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
        print(true);
        return newValue;
    }
    double value = double.parse(newValue.text);
    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");
    String newText = formatter.format(value/100);
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}