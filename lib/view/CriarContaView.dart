import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:limas_burger/model/dao/databasehelper.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/dialogs/DialogBemVindo.dart';
import 'package:limas_burger/view/dialogs/DialogEmailExiste.dart';
import 'package:limas_burger/view/dialogs/DialogLoading.dart';

class CriarContaView extends StatefulWidget{
  ProdutoPedido produto;
  List<ProdutoPedido> produtos;

  CriarContaView(this.produto, this.produtos);
  @override
  State<StatefulWidget> createState() => CriarContaViewPageState();
} 

class CriarContaViewPageState extends State<CriarContaView>{
  String nome;
  String celular;
  String email;
  String senha;
  TextEditingController controller  = TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<FormState> _key2 = new GlobalKey();
  bool _validate = false;
  BuildContext cxt;
  @override
  void initState() {
    super.initState();

  }

   @override
  Widget build(BuildContext context) {
    cxt = context;
    return Scaffold(
      body: Theme(
        data: ThemeData.dark(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              elevation: 0,
              title: Text("Seus dados"),
            ),
            
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.black87,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                        child: Text("Preencha seus dados",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                    ),
                    
                    Container(
                      margin: EdgeInsets.only(top:10),
                      child: FlatButton(
                        onPressed: (){},
                        child: Text("ou Acesse sua conta",
                          style: TextStyle(
                            color: MyColors.secondaryColor,
                            fontSize: 15
                          ),  
                        )
                      ),
                    ),

                    Form(
                      key: _key,
                      autovalidate: _validate,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Nome"
                              ),
                              validator: (text)=>_validarNome(text),
                              onChanged: (text)=> nome=text.trim(),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller,
                              onChanged: (text){
                                if(text.length==1 && text!="(")
                                  controller.text = "($text";
                                if(text.length==3 && celular.length<3)
                                  controller.text += ") ";
                                if(text.length==10 && celular.length<10)
                                  controller.text += "-";
                                if(text.length == 15)
                                  celular = controller.text;
                                if(text.length > 15)
                                  controller.text = celular;
                                
                                celular=controller.text.trim();
                                
                                controller.selection = new TextSelection.collapsed(offset: controller.text.length);                           
                                
                              },
                              decoration: InputDecoration(
                                labelText: "Celular",
                                hintText: "(00) 00000-0000"
                              ),
                              validator: (text)=>_validarCelular(text),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "E-mail"
                              ),
                              validator: (text)=>Usuario.validarEmail(text),
                              onChanged: (text)=>email=text.trim(),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              onChanged: (text)=>senha=text.trim(),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Senha",
                              ),
                              validator: (text)=>Usuario.validarSenha(text),
                              
                              
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Confirmar Senha",
                              ),
                              validator: (text)=>_validarConfirmarSenha(text),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top:30),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: MyColors.secondaryColor,
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: FlatButton(
                              child: Text("Cadastrar-me",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: _sendForm,
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  String _validarNome(String value){
    value.trim();
    if(value.length==0)
      return "Informe o nome";
    else
      return null;
  }


  String _validarConfirmarSenha(String value){
    value.trim();
    if(value.length==0)
      return "Informe a Senha";
    if(value!=senha)
      return "As senhas não coincidem";
    else
      return null;
  }

  String _validarCelular(String value) {
    value = value.trim();
    String patttern= r'^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o celular";
    } else if(value.length >30){
      return "O celular deve ter o DDD e mais 10 dígitos";
    }else if (!regExp.hasMatch(value)) {
      return "O formato está incorreto";
    }
    return null;
  }

 


  _sendForm() async {
    

    if (_key.currentState.validate()) {
      DialogsLoading.showLoadingDialog(context, _key2);
      if(await _emailExists()){
        Navigator.of(_key2.currentContext,rootNavigator: true).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogEmailExiste();
          },
        );
      }else{
        Usuario usuario = Usuario(
        null, upperNome(nome.trim()), senha.trim(), email.trim(), celular.trim(), []);

        List _result = await usuario.save(); 

        if(_result!=null){
          _result.forEach((item){
            var _id = item["pk"];
            usuario.id = _id;
          });
        }
        DataBaseHelper db = DataBaseHelper();
        print(usuario);
        db.insertUsuario(usuario);
        Util.usuario = usuario;
        
        Navigator.of(_key2.currentContext,rootNavigator: true).pop();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return DialogBemVindo(widget.produto, widget.produtos);
          },
        );
      } 
      
    } else {
      setState(() {
        _validate = true;
      });
    }
    
  }

  Future<bool> _emailExists() async {
    List _result = await Usuario.buscarPorEmail(email); 
    if(_result!=null)
      if(_result.length==0)
        return false;
    return true;
  }

  String upperNome(String text) {
    List<String> list = text.split(" ");
    String result = "";

    list.forEach((txt){
      if(txt!="da" && txt!="do" && txt!="dos"){
        String primeira = txt.substring(0,1);
        String restante = txt.substring(1);
        result+=primeira.toUpperCase()+restante.toLowerCase()+" ";
      }else{
         result+=txt.toLowerCase()+" ";
      }
    });

    return result.trim();

  }

}