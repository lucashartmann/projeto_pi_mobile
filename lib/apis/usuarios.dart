import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<dynamic>?> getUsuario(int id) async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}usuarios.php?acao=buscar&id=$id",
    );
    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    );
    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    final data = jsonDecode(resposta.body);
    return data as List<dynamic>;
  } catch (erro) {
    debugPrint("Falha ao conectar com o backend: $erro");
    return null;
  }
}

Future<List<dynamic>?> listarPessoas(String tipo) async {
  try {
    final uri = Uri.parse("${dotenv.get('ADDRESS')}usuarios.php?acao=listar");
    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    );
    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    final data = jsonDecode(resposta.body);

    return data as List<dynamic>;
  } catch (error) {
    debugPrint("ERRO: usuarios.dart - listarPessoas: $error");
    return null;
  }
}
