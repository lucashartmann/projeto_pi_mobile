import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'package:flutter/foundation.dart';

Future<List<dynamic>?> listarImoveis() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/imoveis.php?acao=listar_imoveis",
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
          imagens[i] = "http://10.0.2.2${imagens[i]}";
        }
      }
    }

    return data as List<dynamic>;
  } catch (e) {
    debugPrint("Erro: $e");
    return null;
  }
}

Future<List<dynamic>?> listarImoveisDisponiveis() async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/imoveis.php?acao=listar_imoveis_disponiveis",
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
      debugPrint(imovel["id"]);
      switch (imovel["status"]) {
        case "Venda":
          imovel["valor_aluguel"] = null;
          break;
        case "Aluguel":
          imovel["valor_venda"] = null;
          break;
        default:
          break;
      }
    }

    for (final imovel in data) {
      final anuncio = imovel["anuncio"];

      if (anuncio != null && anuncio["imagens"] != null) {
        final imagens = anuncio["imagens"] as List<dynamic>;

        for (int i = 0; i < imagens.length; i++) {
          imagens[i] = "http://10.0.2.2${imagens[i]}";
        }
      }
    }

    return data as List<dynamic>;
  } catch (e) {
    debugPrint("Falha ao conectar com o backend: $e");
    return null;
  }
}

Future<List<dynamic>?> getDadosImovel(id) async {
  try {
    final uri = Uri.parse(
      "http://10.0.2.2/PHP/projeto-pi-front/php/api/imoveis.php?acao=get_dados_imovel&id=" +
          id,
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

    // for (final imovel in data) {
    //   final anuncio = imovel["anuncio"];

    //   if (anuncio != null && anuncio["imagens"] != null) {
    //     final imagens = anuncio["imagens"] as List<dynamic>;

    //     for (int i = 0; i < imagens.length; i++) {
    //       imagens[i] = "http://10.0.2.2${imagens[i]}";
    //     }
    //   }
    // }

    return data as List<dynamic>;
  } catch (e) {
    debugPrint("Falha ao conectar com o backend: $e");
    return null;
  }
}
