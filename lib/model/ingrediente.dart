import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:limas_burger/util/util.dart';
import 'package:limas_burger/view/CatalogoView.dart';
import 'package:limas_burger/view/dialogs/DialogErrorServer.dart';
class Ingrediente{
  int id;
  String nome;
  String status;
  bool selecionado = true;

  Ingrediente(this.id, this.nome, this.status);

  static getData(id)async {
    var response;
    try{
      response = (await http.get(
        Uri.encodeFull(Util.URL+"buscar/ingrediente/"+id.toString()),
        headers: {
          "Accept":"apllication/json"
        })
      );
      return jsonDecode(response.body);
    }on Exception{
      showDialog(
        context: CatalogoView.bContext,
        builder: (BuildContext context) {
          return DialogErrorServer(true);
        },
      );
    }
  }
}