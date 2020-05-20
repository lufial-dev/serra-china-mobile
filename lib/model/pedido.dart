import 'package:intl/intl.dart';
import 'package:limas_burger/model/endereco.dart';
import 'package:limas_burger/model/produto_pedido.dart';
import 'package:limas_burger/model/usuario.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';

class Pedido {
  int id;
  DateTime dataHoraPedido;
  DateTime dataHoraEntrega;
  List<ProdutoPedido> produtos;
  String status;
  String formaDePagamento;
  double valorTotal;
  Endereco enderecoEntrega;
  Usuario usuario;

  Pedido(
      this.id,
      this.dataHoraPedido,
      this.dataHoraEntrega,
      this.status,
      this.formaDePagamento,
      this.valorTotal,
      this.enderecoEntrega,
      this.usuario,
      this.produtos);

  Pedido.fromJson(Map<String, dynamic> json)
      : id = json['pk'],
        dataHoraEntrega = json['dataHoraEntrega'],
        dataHoraPedido = json['dataHoraPedido'],
        status = json['status'],
        formaDePagamento = json['formaDePagamento'],
        valorTotal = double.parse(json['valorTotal']);

  static buscarPedidosUsuario() async {
    var _result;
    var response;
    try {
      print(Util.usuario.id.toString());
      response = await http.get(
          Uri.encodeFull(
              Util.URL + "buscar/pedido/" + Util.usuario.id.toString()),
          headers: {"Accept": "apllication/json"});

      _result = jsonDecode(response.body);

      return _result;
    } catch (e) {}
    return _result;
  }

  save() async {
    var response;
    
    String data = Util.formatDate.format(dataHoraPedido).trim().replaceAll("/", "-");
    if (id == null) {
      print(formaDePagamento);
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "add/pedido/"+ formaDePagamento + "&" + status + "&" + Util.usuario.id.toString() + "&" + enderecoEntrega.id.toString() + "&" + "Não definida" + '&' + data + "&" + valorTotal.toString()),
          headers: {"Accept": "apllication/json"});
    }
    /*else{
      response = await http.get(
          Uri.encodeFull(Util.URL +
              "editar/endereco/" +
              id.toString() +
              "&" +
              bairro +
              "&" +
              rua +
              "&" +
              numero +
              "&" +
              referencia),
          headers: {"Accept": "apllication/json"});
    }
    */
    var _result;
     print(response.body);
    try {
      _result = jsonDecode(response.body);
    } catch (e) {
      e.toString();
    }
   

    return _result;
  }

  @override
  String toString() {
    // TODO: implement toString
    return status + " - " + usuario.id.toString() + " - " + enderecoEntrega.id.toString();
  }
}
