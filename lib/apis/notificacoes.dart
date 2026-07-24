import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// let notificacoes = [];

// function marcarComoLida(id) {}

Future<List<dynamic>?> carregarNotificacoes() async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}login.php?acao=get_notificacoes",
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

    for (final imovel in data) {
      final anuncio = imovel["anuncio"];

      if (anuncio != null && anuncio["imagens"] != null) {
        final imagens = anuncio["imagens"] as List<dynamic>;

        for (int i = 0; i < imagens.length; i++) {
          imagens[i] = "${dotenv.get('IPLOCAL')}${imagens[i]}";
        }
      }
    }

    return data as List<dynamic>;
  } catch (e) {
    debugPrint("Erro: $e");
    return null;
  }
}
