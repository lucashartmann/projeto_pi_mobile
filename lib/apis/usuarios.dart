import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<dynamic>?> listarUsuarios() async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}usuarios.php?acao=listar",
    );
    final resposta = await http.get(uri);

    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    if (resposta.body.isEmpty) {
      debugPrint("Resposta vazia do servidor");
      return null;
    }

    if (resposta.headers["content-type"] == null ||
        !resposta.headers["content-type"]!.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    final dados = jsonDecode(resposta.body);

    return dados;
  } catch (erro) {
    debugPrint("Falha ao conectar com o backend: $erro");
    return null;
  }
}
