import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_pi_mobile/apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

List<dynamic>? _extrairLista(dynamic payload, {required String origem}) {
  if (payload is List<dynamic>) {
    return payload;
  }

  if (payload is Map<String, dynamic>) {
    const chavesPossiveis = ['data', 'dados', 'imoveis', 'resultado', 'items'];

    for (final chave in chavesPossiveis) {
      final valor = payload[chave];
      if (valor is List<dynamic>) {
        return valor;
      }
    }

    final mensagem = payload['mensagem'] ?? payload['erro'] ?? payload['error'];
    if (mensagem != null) {
      debugPrint('Mensagem do backend em $origem: $mensagem');
    }
  }

  debugPrint('Formato inesperado em $origem: ${payload.runtimeType}');
  debugPrint('Payload bruto em $origem: $payload');
  return null;
}

dynamic destacarImovel(int imovelId) async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}imoveis.php?acao=destacar&id=$imovelId",
    );
    final resposta = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Cookie": sessionCookie ?? "",
      },
    );

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

    if (dados["status"] == "erro") {
      debugPrint("Erro ao destacar imóvel: ${dados["mensagem"]}");
      return null;
    }

    debugPrint("Imóvel destacado com sucesso! $dados.mensagem");

    return dados;
  } catch (erro) {
    debugPrint("Falha ao conectar com o backend: $erro");
    return null;
  }
}

void excluirImovel(int imovelId) async {
  if (imovelId <= 0) {
    debugPrint("ID do imóvel inválido: $imovelId");
  }
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}imoveis.php?acao=apagar&id=$imovelId",
    );
    final resposta = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Cookie": sessionCookie ?? "",
      },
    );

    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP: ${resposta.statusCode}");
    }

    if (resposta.body.isEmpty) {
      debugPrint("Resposta vazia do servidor");
    }

    if (resposta.headers["content-type"] == null ||
        !resposta.headers["content-type"]!.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
    }

    final dados = jsonDecode(resposta.body);

    if (dados["status"] == "erro") {
      debugPrint("Erro ao excluir imóvel: ${dados["mensagem"]}");
      return null;
    }

    debugPrint("Imóvel excluido com sucesso! $dados.mensagem");
  } catch (erro) {
    debugPrint("Falha ao conectar com o backend: $erro");
  }
}

Future<List<dynamic>?> listarImoveis() async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}imoveis.php?acao=listar_imoveis",
    );

    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    );

    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP em listarImoveis: ${resposta.statusCode}");
      debugPrint("Corpo da resposta: ${resposta.body}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    final payload = jsonDecode(resposta.body);
    final data = _extrairLista(payload, origem: 'listarImoveis');

    if (data == null) {
      return null;
    }

    for (final imovel in data) {
      final anuncio = imovel["anuncio"];

      if (anuncio != null && anuncio["imagens"] != null) {
        final imagens = anuncio["imagens"] as List<dynamic>;

        for (int i = 0; i < imagens.length; i++) {
          imagens[i] = "${dotenv.get('IPLOCAL')}${imagens[i]}";
        }
      }
    }

    return data;
  } catch (e) {
    debugPrint("ERRO: imoveis.dart - listarImoveis: $e");
    return null;
  }
}

Future<List<dynamic>?> listarImoveisDisponiveis() async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}imoveis.php?acao=listar_disponiveis",
    );
    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    );
    if (resposta.statusCode != 200) {
      debugPrint(
        "Erro HTTP em listarImoveisDisponiveis: ${resposta.statusCode}",
      );
      debugPrint("Corpo da resposta: ${resposta.body}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    if (resposta.body.isEmpty) {
      debugPrint("Resposta vazia do servidor");
      return [];
    }

    final List<dynamic> data = jsonDecode(resposta.body);

    if (data.isEmpty) {
      debugPrint("Nenhum imóvel disponível encontrado");
      return [];
    }

    for (final imovel in data) {
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
          imagens[i] = "${dotenv.get('IPLOCAL')}${imagens[i]}";
        }
      }
    }

    return data;
  } catch (e) {
    debugPrint("Falha ao conectar com o backend: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> getDadosImovel(int id) async {
  try {
    final uri = Uri.parse(
      "${dotenv.get('ADDRESS')}imoveis.php?acao=get_dados_imovel&id=$id",
    );

    final resposta = await http.get(
      uri,
      headers: {"Cookie": sessionCookie ?? ""},
    );
    if (resposta.statusCode != 200) {
      debugPrint("Erro HTTP em getDadosImovel: ${resposta.statusCode}");
      debugPrint("Corpo da resposta: ${resposta.body}");
      return null;
    }

    final contentType = resposta.headers["content-type"];

    if (contentType == null || !contentType.contains("application/json")) {
      debugPrint("Resposta não é JSON");
      debugPrint(resposta.body);
      return null;
    }

    if (resposta.body.isEmpty) {
      debugPrint("Resposta vazia do servidor");
      return null;
    }

    final Map<String, dynamic> data = json.decode(resposta.body);

    // if (data.isEmpty) {
    //   debugPrint("Nenhum dado encontrado para o imóvel com ID $id");
    //   return null;
    // }

    // for (final imovel in data) {
    //   final anuncio = imovel["anuncio"];

    //   if (anuncio != null && anuncio["imagens"] != null) {
    //     final imagens = anuncio["imagens"] as List<dynamic>;

    //     for (int i = 0; i < imagens.length; i++) {
    //       imagens[i] = "${dotenv.get('IPLOCAL')}${imagens[i]}";
    //     }
    //   }
    // }

    return data;
  } catch (e) {
    debugPrint("Falha ao conectar com o backend: $e");
    return null;
  }
}
