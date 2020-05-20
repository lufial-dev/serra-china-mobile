import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limas_burger/model/dao/databasehelper.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/EnderecoView.dart';
import 'package:limas_burger/view/dialogs/DialogLoading.dart';

class DialogLogin extends StatefulWidget{
  ProdutoPedido produto;
  List<ProdutoPedido> produtos;
  DialogLogin(this.produto, this.produtos);
  @override
  _DialogLoginState createState() => _DialogLoginState();

}

class _DialogLoginState extends State<DialogLogin>{
  String email;
  String senha;
  bool validate = false;
  bool userNotExit = false;

  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey _key2 = GlobalKey();



  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title:Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height/8,
        child: Center(child: Text("Acesso a conta", textAlign: TextAlign.center,)),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _key,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              userNotExit?Text("Usuário ou senha incorretos",
                style: TextStyle(color: Colors.red),
              ):Offstage(),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                validator: (text)=>Usuario.validarEmail(text),
                onChanged: (text)=>email = text.trim(),
              ),

              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                ),
                validator: (text)=>Usuario.validarSenha(text),
                onChanged: (text)=>senha = text.trim(),
              ),

              FlatButton(
                child: Text("Esqueceu a senha?"),
                onPressed: (){},
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
                  child: Text("Entrar",
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
      if (_key.currentState.validate()) {
        DialogsLoading.showLoadingDialog(context, _key2);
        userNotExit = false;
        
        List usuarios = await Usuario.autenticar(email, senha);
          usuarios.forEach((item){
            if(item['pk']!=null){
              
              var _id = item['pk'];
              var _nome = item['fields']['nome'];
              var _email = item['fields']['email'];
              var _senha = senha;
              var _contato = item['fields']['contato'];
              
              Util.usuario = Usuario(_id, _nome, _senha, _email, _contato, null);
            }
          });
          if(Util.usuario != null){
            DataBaseHelper db = DataBaseHelper();
            db.insertUsuario(Util.usuario);
            Navigator.of(_key2.currentContext,rootNavigator: true).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EnderecoView(widget.produto, widget.produtos)));
          }else
            setState(() {
              userNotExit = true;
              Navigator.of(_key2.currentContext,rootNavigator: true).pop();
            });        
       
        
      } else {
        setState(() {
          validate = true;
        });
      }
      
    }

  

}
 
 