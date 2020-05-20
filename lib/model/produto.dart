import 'dart:convert';

import 'package:limas_burger/model/ingrediente.dart';
import 'package:limas_burger/util/util.dart';
import 'package:http/http.dart' as http;

class Produto{
  int id;
  String nome;
  double valor;
  List<Ingrediente> ingredientes;
  String status;
  String imagem;

  Produto(this.id, this.nome, this.imagem, this.valor, this.status, this.ingredientes);

  static _fromJson(List _result) async {
    if(_result!=null){
      List<Produto> _produtos = <Produto>[];

      _result.forEach((item)async{
        var _id = item["pk"];
        var _nome = item["fields"]["nome"].toString();
        var _valor = item["fields"]["valor"].toString();  
        var _status = item["fields"]["status"].toString(); 
        var _imagem = item["fields"]["imagem"].toString();   
        var _ingredientes = item["fields"]["ingredientes"];
    
        List<Ingrediente> ingredientes = [];

        for (var id in _ingredientes)  {
          List result  = await Ingrediente.getData(id);
          if(result!=null){
            result.forEach((item){
              int _idIng = item["pk"];
              var _nome = item["fields"]["nome"].toString();
              var _status = item["fields"]["status"].toString();

              Ingrediente ingrediente = Ingrediente (_idIng, _nome, _status);
              ingredientes.add(ingrediente); 
            });
          }
          
        }
        Produto p =  Produto(_id, _nome, _imagem, double.parse(_valor), _status, ingredientes);
        _produtos.add(p);   
      });

      return Future.delayed(Duration(seconds: 1), ()=> _produtos);
    }
  }

  static listarProdutos(string , init, fim) async{ 
    try{
      var response = string == null?
        await http.get(
          Uri.encodeFull(Util.URL+"buscar/produtos/"+init.toString()+"-"+fim.toString()),
          headers: {
            "Accept":"apllication/json"
          }
        ):
        await http.get(
          Uri.encodeFull(Util.URL+"buscar/produtos/"+string+"-"+init.toString()),
          headers: {
            "Accept":"apllication/json"
          }
        );
        
        return await _fromJson(jsonDecode(response.body));
    }catch(e){
      return null;
    }
  }
  
  static Future<Produto> listarProdutosPorId(id)async {
    var response = await http.get(
      Uri.encodeFull(Util.URL+"listar/listarPorIdProduto/"+id.toString()),
      headers: {
        "Accept":"apllication/json"
      }
    );
    List<Produto> produtos = await _fromJson(jsonDecode(response.body));
    return produtos[0];
  }

  static listarProdutoPorNome(nome)async {
    var response = await http.get(
      Uri.encodeFull(Util.URL+"buscar/produtos/"+nome),
      headers: {
        "Accept":"apllication/json"
      }
    );

    return await _fromJson(jsonDecode(response.body));
  }
  

  @override
  String toString() {
    // TODO: implement toString
    return nome.toUpperCase();
  }
}