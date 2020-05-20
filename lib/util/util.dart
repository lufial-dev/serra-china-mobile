import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limas_burger/model/carrinho.dart';
import 'package:limas_burger/model/pedido.dart';
import 'package:limas_burger/model/usuario.dart';

class Util {
  static const String URL =
      "http://ec2-18-229-29-129.sa-east-1.compute.amazonaws.com:8000/";
  static const String URL_IMAGENS =
      "http://ec2-18-229-29-129.sa-east-1.compute.amazonaws.com:8000/media/";
/*
  static const String URL =
      "http://10.0.0.105:8000/";
  static const String URL_IMAGENS =
      "http://10.0.0.105:8000/media/";
*/
  static final formatDate = DateFormat('dd/MM/yyyy hh:mm');
  static const int QUANT_LIST_PRODUTOS = 10;
  static Carrinho carrinho = Carrinho();
  static List<Pedido> pedidos = List();
  // static List<Endereco> enderecos =[Endereco(1, "Vila Fortuna", "Avenida Nilcea Nunes Machado", "89", "Vizinho do mercado de Antônio"),
  //   Endereco(1, "Vila Fortuna", "Avenida Nilcea Nunes Machado", "89", "Vizinho do mercado de Antônio")
  // ];
  static Usuario
      usuario; // = Usuario(1, "Filipe", "filipe", "filipe", "lfilipealves20@gmail.com", "(87) 9 9646-7908", enderecos);

  static DateTime converterStringEmDateTime(String dateString) {
    DateTime novaData;
    try{
       novaData = DateFormat().add_yMd().add_Hm().parse(dateString);

    }catch(e){

    }
    return novaData;
  }
}

class StatusProduto {
  static const String DISPONIVEL = "Disponível";
  static const String INDISPONIVEL = "Indisponível";
}

class StatusPedido {
  static const String FEITO = "Feito";
  static const String RECEBIDO = "Recebido";
  static const String INICIADO = "Iniciado";
  static const String SAIU_PARA_ENTREGA = "Saiu para entrega";
  static const String ENTRGUE = "Entregue";
}

class StatusIngrediente {
  static const String DISPONIVEL = "Disponível";
  static const String INDISPONIVEL = "Indisponível";
}

class FormaDePagamento {
  static const String CARTAO = "Cartão";
  static const String DINHEIRO = "Dinheiro";
}

class MyColors {
  static final Color secondaryColor = Colors.tealAccent;
}
