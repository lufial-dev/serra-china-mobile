import 'dart:convert';
import 'package:limas_burger/model/endereco.dart';
import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';

class Usuario{
  int id;
  String nome;
  List<Endereco> enderecos = [];
  String senha;
  String email;
  String contato;

  Usuario(this.id, this.nome, this.senha, this.email, this.contato, this.enderecos);

  save()async {
    var response = await http.get(
      Uri.encodeFull(Util.URL+"add/usuario/"+nome+"&"+email+"&"+senha+"&"+contato),
      headers: {
        "Accept":"apllication/json"
      }
    );
    var _result;
    try{
      _result = jsonDecode(response.body);
    }catch(e){}
    
    return _result;
    
  }

  static buscarPorEmail(String email) async{
     var response = await http.get(
      Uri.encodeFull(Util.URL+"buscar/usuario/"+email),
      headers: {
        "Accept":"apllication/json"
      }
    );

    var _result;
    try{
      _result = jsonDecode(response.body);
    }catch(e){}
    
    return _result;
  }

  static buscarPorId(int id) async{
      var _result;
      var response; 
      try{
        response = await http.get(
        Uri.encodeFull(Util.URL+"buscar/usuario/"+id.toString()),
        headers: {
          "Accept":"apllication/json"
        }
      );
      _result = jsonDecode(response.body);
      }catch(e){}
      
      return _result;
   
  }

  static autenticar(email, senha)async{
    var _result;
      var response; 
      try{
        response = await http.get(
        Uri.encodeFull(Util.URL+"usuario/autenticar/"+email+"&"+senha),
        headers: {
          "Accept":"apllication/json"
        }
      );
      _result = jsonDecode(response.body);
      }catch(e){}
      
      return _result;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'contato' : contato
    };
  }

  static validarEmail(String value){
    value = value.trim();
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o E-mail";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }

 static validarSenha(String value){
    value.trim();
    if(value.length==0)
      return "Informe a senha";
    else
      return null;
  }

  static Usuario fromJson(var json){
    var _id = json[0]['pk'];
    var _nome = json[0]['fields']['nome'];
    var _contato = json[0]['fields']['contato'];
    var _email = json[0]['fields']['email'];
    var _enderecos = json[0]['fields']['enderecos'];

    Usuario usuario = Usuario(_id, _nome, null, null, _contato, null);


    return usuario;
  }

}